import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';

class AuthProvider with ChangeNotifier {
  // Seeded on first successful login attempt with these exact credentials,
  // since Firebase's email/password provider has no concept of a plain
  // "admin" username and there is no Admin SDK backend to pre-create it.
  static const _adminEmail = 'duongtrieuphu2311@gmail.com';
  static const _adminPassword = '123456';

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

  Future<String?> login({required String email, required String password}) async {
    final normalizedEmail = email.trim().toLowerCase();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      // Self-healing: whoever successfully signs in with the designated admin
      // email is granted the admin role, even if that account already existed
      // as a regular user from earlier testing.
      if (normalizedEmail == _adminEmail) {
        await _firestore.collection('users').doc(credential.user!.uid).set(
          {'role': 'admin'},
          SetOptions(merge: true),
        );
      }
      await _loadUser(credential.user!);
      return null;
    } on FirebaseAuthException catch (e) {
      // Newer Firebase projects have email-enumeration protection enabled,
      // which reports 'invalid-credential' instead of 'user-not-found' even
      // when the account simply doesn't exist yet — so the admin account
      // must be bootstrapped on any of these codes, not just 'user-not-found'.
      const missingAccountCodes = {'user-not-found', 'invalid-credential', 'wrong-password'};
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

  /// Live list of every account (both roles) for the admin account-management screen.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchAllUsers() {
    return _firestore.collection('users').orderBy('name').snapshots();
  }

  /// Creates a brand-new login (user or admin) from inside the admin panel.
  ///
  /// Uses a secondary, throwaway [FirebaseApp] instance so that signing the
  /// new account in (an unavoidable side effect of the client-only
  /// `createUserWithEmailAndPassword` call) does not sign the admin who is
  /// performing this action out of their own session.
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
      });
      await secondaryAuth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return 'Không thể tạo tài khoản: $e';
    }
  }

  /// Edits the display name / role of any account. Email and password belong
  /// to Firebase Auth and can only be changed by that account itself, so they
  /// are intentionally not editable from here.
  Future<String?> updateUserProfile(
    String uid, {
    required String name,
    required String role,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'name': name.trim(),
        'role': role,
      });
      if (uid == _auth.currentUser?.uid) {
        await _loadUser(_auth.currentUser!);
      }
      return null;
    } catch (e) {
      return 'Không thể cập nhật tài khoản: $e';
    }
  }

  /// Removes an account's profile/role data from Firestore. This does NOT
  /// delete the underlying Firebase Authentication login — the client SDK
  /// can only ever delete the *currently signed-in* user, never another
  /// account, so fully revoking someone else's login requires a backend
  /// (Cloud Functions + Admin SDK), which this project doesn't have.
  Future<String?> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      return null;
    } catch (e) {
      return 'Không thể xóa tài khoản: $e';
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
