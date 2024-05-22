import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    Database? db = await database;
    return await db!.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query('users');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        email: maps[i]['email'],
        password: maps[i]['password'],
      );
    });
  }

  Future<bool> isValidUser(String email, String password) async {
    Database? db = await database;
    List<Map<String, dynamic>> result = await db!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
}
