import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Single shared accounts database. Both shop customers and the admin
/// login live in the same `users` table, distinguished by `role`.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> database() async {
    final cached = _db;
    if (cached != null) return cached;

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'app_auth.db');

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            role TEXT NOT NULL DEFAULT 'user'
          )
        ''');
      },
    );

    // Ensures a default admin login always exists, even on a pre-existing db file.
    await db.insert(
      'users',
      {'name': 'Admin', 'email': 'admin', 'password': '123456', 'role': 'admin'},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    _db = db;
    return db;
  }
}
