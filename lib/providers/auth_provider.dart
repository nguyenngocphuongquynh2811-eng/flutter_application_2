import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    );
    _isEmailVerified = refreshed.emailVerified;
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
