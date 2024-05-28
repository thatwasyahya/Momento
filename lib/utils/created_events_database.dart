import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/CreatedEvent.dart';


class CreatedEventDatabase {
  static final CreatedEventDatabase instance = CreatedEventDatabase._init();

  static Database? _database;

  CreatedEventDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('createdevents.db');
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
CREATE TABLE createdEvents (
  id $idType,
  name $textType,
  city $textType,
  date $textType,
  venue $textType,
  imageUrl $textType
  )
''');
  }

  Future<void> create(CreatedEvent event) async {
    final db = await instance.database;

    await db.insert('createdEvents', event.toMap());
  }

  Future<List<CreatedEvent>> readAllEvents() async {
    final db = await instance.database;

    final orderBy = 'date DESC';
    final result = await db.query('createdEvents', orderBy: orderBy);

    return result.map((json) => CreatedEvent(
      name: json['name'] as String,
      city: json['city'] as String,
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
