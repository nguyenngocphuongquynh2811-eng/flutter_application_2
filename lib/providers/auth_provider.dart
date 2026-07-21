import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../data/app_database.dart';
import '../models/app_user.dart';

class AuthProvider with ChangeNotifier {
  static const _currentEmailKey = 'current_email';

  Database? _db;
  AppUser? _currentUser;
  bool _isInitialized = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    _db = await AppDatabase.instance.database();

    final prefs = await SharedPreferences.getInstance();
    final currentEmail = prefs.getString(_currentEmailKey);
    if (currentEmail != null) {
      _currentUser = await _findUser(currentEmail);
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (await _findUser(normalizedEmail) != null) {
      return 'Email này đã được đăng ký.';
    }

    final user = AppUser(name: name.trim(), email: normalizedEmail, password: password);
    await _db!.insert('users', user.toJson());
    await _setCurrentUser(user);
    return null;
  }

  Future<String?> login({required String email, required String password}) async {
    final normalizedEmail = email.trim().toLowerCase();
    final user = await _findUser(normalizedEmail);
    if (user == null || user.password != password) {
      return 'Tài khoản hoặc mật khẩu không đúng.';
    }
    await _setCurrentUser(user);
    return null;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentEmailKey);
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    final user = _currentUser;
    if (user == null) return;

    await _db!.delete('users', where: 'email = ?', whereArgs: [user.email]);
    await logout();
  }

  Future<AppUser?> _findUser(String email) async {
    final rows = await _db!.query('users', where: 'email = ?', whereArgs: [email]);
    if (rows.isEmpty) return null;
    return AppUser.fromJson(rows.first);
  }

  Future<void> _setCurrentUser(AppUser user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentEmailKey, user.email);
    notifyListeners();
  }
}
