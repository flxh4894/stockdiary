import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'diary.db');

    return await openDatabase(path, version: 2, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE diary(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          text TEXT NOT NULL,
          date TEXT NOT NULL
        )'''
      );
      db.execute('''
        CREATE TABLE memo (
          "id"	INTEGER,
          "text"	TEXT NOT NULL,
          "date"	TEXT NOT NULL,
          "check_yn"	INTEGER NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
      return db.execute('''
        CREATE TABLE stock_list (
          "id"	INTEGER,
          "diary_id"	INTEGER NOT NULL,
          "name"	TEXT NOT NULL,
          "deal_type"	NUMERIC NOT NULL,
          "price"	INTEGER NOT NULL,
          "amount"	INTEGER NOT NULL,
          "date"	TEXT,
          FOREIGN KEY("diary_id") REFERENCES "diary"("id"),
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }
}
