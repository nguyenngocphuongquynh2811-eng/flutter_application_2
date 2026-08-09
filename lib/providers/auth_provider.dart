import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/app_user.dart';

class AuthProvider with ChangeNotifier {
  static const _adminEmail = 'duongtrieuphu2311@gmail.com';
  static const _adminPassword = '123456';

  /// Số ngày không đăng nhập tối đa trước khi bị auto-khóa (3 tháng).
  static const _inactiveLockDays = 90;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _currentUser;
  bool _isEmailVerified = false;
  bool _isInitialized = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isEmailVerified => _isEmailVerified;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _loadUser(user);
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(name.trim());
      await _firestore.collection('users').doc(user.uid).set({
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'role': 'user',
        'lastLogin': FieldValue.serverTimestamp(),
      });
      await user.sendEmailVerification();
      await _loadUser(user);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return 'Đăng ký thất bại: $e';
    }
  }

  Future<String?> login(
      {required String email, required String password}) async {
    final normalizedEmail = email.trim().toLowerCase();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final uid = credential.user!.uid;

      if (normalizedEmail == _adminEmail) {
        // Admin gốc: tự cấp quyền, bỏ qua mọi luật khóa.
        await _firestore.collection('users').doc(uid).set(
          {'role': 'admin'},
          SetOptions(merge: true),
        );
      } else {
        final data =
            (await _firestore.collection('users').doc(uid).get()).data() ?? {};

        // 1) Khóa thủ công có thời hạn (nếu dùng).
        final locked = data['lockedUntil'];
        if (locked is Timestamp && locked.toDate().isAfter(DateTime.now())) {
          await _auth.signOut();
          return 'Tài khoản đang bị khóa đến '
              '${DateFormat('dd/MM/yyyy HH:mm').format(locked.toDate())}.';
        }

        // 2) Khóa do không đăng nhập quá 3 tháng.
        final last = data['lastLogin'];
        if (last is Timestamp &&
            DateTime.now().difference(last.toDate()).inDays >
                _inactiveLockDays) {
          await _auth.signOut();
          return 'Tài khoản bị khóa do không đăng nhập quá 3 tháng. '
              'Vui lòng liên hệ admin để mở khóa.';
        }
      }

      // Qua hết -> cập nhật mốc đăng nhập gần nhất.
      await _firestore
          .collection('users')
          .doc(uid)
          .set({'lastLogin': FieldValue.serverTimestamp()}, SetOptions(merge: true));

      await _loadUser(credential.user!);
      return null;
    } on FirebaseAuthException catch (e) {
      const missingAccountCodes = {
        'user-not-found',
        'invalid-credential',
        'wrong-password'
      };
      if (missingAccountCodes.contains(e.code) &&
          normalizedEmail == _adminEmail &&
          password == _adminPassword) {
        return _bootstrapAdmin();
      }
      return _mapAuthError(e);
    } catch (e) {
      return 'Đăng nhập thất bại: $e';
    }
  }

  Future<String?> _bootstrapAdmin() async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: _adminEmail,
        password: _adminPassword,
      );
      final user = credential.user!;
      await user.updateDisplayName('Admin');
      await _firestore.collection('users').doc(user.uid).set({
        'name': 'Admin',
        'email': _adminEmail,
        'role': 'admin',
        'lastLogin': FieldValue.serverTimestamp(),
      });
      await _loadUser(user);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return 'Không thể tạo tài khoản admin: $e';
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Không tìm thấy tài khoản với email này.';
      }
      return _mapAuthError(e);
    } catch (e) {
      return 'Không thể gửi email đặt lại mật khẩu: $e';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    _isEmailVerified = false;
    notifyListeners();
  }

  Future<String?> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    try {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      _currentUser = null;
      _isEmailVerified = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Vui lòng đăng xuất và đăng nhập lại trước khi xóa tài khoản.';
      }
      return e.message ?? 'Không thể xóa tài khoản.';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAllUsers() {
    return _firestore.collection('users').orderBy('name').snapshots();
  }

  Future<String?> createAccountAsAdmin({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    FirebaseApp secondaryApp;
    try {
      try {
        secondaryApp = Firebase.app('admin_provisioning');
      } catch (_) {
        secondaryApp = await Firebase.initializeApp(
          name: 'admin_provisioning',
          options: Firebase.app().options,
        );
      }
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      final newUser = credential.user!;
      await newUser.updateDisplayName(name.trim());
      await _firestore.collection('users').doc(newUser.uid).set({
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'role': role,
        'lastLogin': FieldValue.serverTimestamp(),
      });
      await secondaryAuth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return 'Không thể tạo tài khoản: $e';
    }
  }

  Future<String?> updateUserProfile(
    String uid, {
    required String name,
    required String role,
    String? avatarBase64,
  }) async {
    try {
      final data = <String, dynamic>{'name': name.trim(), 'role': role};
      if (avatarBase64 != null) data['avatarBase64'] = avatarBase64;
      await _firestore.collection('users').doc(uid).update(data);
      if (uid == _auth.currentUser?.uid) {
        await _loadUser(_auth.currentUser!);
      }
      return null;
    } catch (e) {
      return 'Không thể cập nhật tài khoản: $e';
    }
  }

  Future<String?> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      return null;
    } catch (e) {
      return 'Không thể xóa tài khoản: $e';
    }
  }

  /// Mở khóa: xóa khóa thủ công + reset mốc không hoạt động (kích hoạt lại).
  Future<String?> unlockUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lockedUntil': FieldValue.delete(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return 'Không thể mở khóa: $e';
    }
  }

  /// Đổi mật khẩu của CHÍNH tài khoản đang đăng nhập.
  Future<String?> changeOwnPassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) return 'Chưa đăng nhập.';
    try {
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Vui lòng đăng xuất và đăng nhập lại trước khi đổi mật khẩu.';
      }
      return _mapAuthError(e);
    }
  }

  Future<void> resendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<void> refreshEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.reload();
    _isEmailVerified = _auth.currentUser?.emailVerified ?? false;
    notifyListeners();
  }

  Future<void> _loadUser(User user) async {
    await user.reload();
    final refreshed = _auth.currentUser!;
    final doc = await _firestore.collection('users').doc(refreshed.uid).get();
    final data = doc.data();

    _currentUser = AppUser(
      name: (data?['name'] as String?) ?? refreshed.displayName ?? '',
      email: refreshed.email ?? '',
      role: (data?['role'] as String?) ?? 'user',
      avatarBase64: data?['avatarBase64'] as String?,
    );
    _isEmailVerified = refreshed.emailVerified;
    notifyListeners();
  }

  Future<void> updateAvatar(String base64Image) async {
    final user = _auth.currentUser;
    if (user == null || _currentUser == null) return;

    await _firestore.collection('users').doc(user.uid).set(
      {'avatarBase64': base64Image},
      SetOptions(merge: true),
    );

    _currentUser = AppUser(
      name: _currentUser!.name,
      email: _currentUser!.email,
      role: _currentUser!.role,
      avatarBase64: base64Image,
    );
    notifyListeners();
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email này đã được đăng ký.';
      case 'invalid-email':
        return 'Email không hợp lệ.';
      case 'weak-password':
        return 'Mật khẩu quá yếu (tối thiểu 6 ký tự).';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không đúng.';
      default:
        return e.message ?? 'Đã xảy ra lỗi, vui lòng thử lại.';
    }
  }
}
