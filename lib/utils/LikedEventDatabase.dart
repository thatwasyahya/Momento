import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/LikedEvent.dart';

class LikedEventDatabase {
  static final LikedEventDatabase instance = LikedEventDatabase._init();

  static Database? _database;

  LikedEventDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('likedevents.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE likedEvents (
        id $idType,
        name $textType,
        date $textType,
        venue $textType,
        imageUrl $textType
      )'''
    );
  }

  Future<void> create(LikedEvent likedEvent) async {
    final db = await instance.database;

    await db.insert('likedEvents', likedEvent.toMap());
  }

  Future<List<LikedEvent>> readAllEvents() async {
    final db = await instance.database;

    final orderBy = 'name ASC';
    final result = await db.query('likedEvents', orderBy: orderBy);

    return result.map((json) => LikedEvent(
      name: json['name'] as String,
      date: json['date'] as String,
      venue: json['venue'] as String,
      imageUrl: json['imageUrl'] as String,
    )).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}