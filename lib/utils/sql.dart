import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:selfnovel/model/novel.dart';

class SQL {
  static const String _DB_NAME = 'sn.db';

  static bool ready = false;
  static Database _db;

  static Future<void> init() async {
    if (_db != null) return;
    String dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, _DB_NAME),
      version: 1,
      onCreate: (db, ver) async => await db.execute('CREATE TABLE novels(name TEXT,path TEXT,catalog TEXT,progress INT)'),
    );
  }

  static Future<List<Novel>> select() async {
    return (await _db.query('novels', columns: ['rowid', '*'])).map((map) => Novel.fromMap(map)).toList();
  }

  static Future<int> insert(Novel novel) async {
    return await _db.insert(
      'novels',
      novel.toMap(),
    );
  }

  static Future<int> update(Novel novel) async {
    return await _db.update(
      'novels',
      novel.toMap(),
      where: 'rowid=?',
      whereArgs: [novel.id],
    );
  }

  static Future<int> delete(Novel novel) async {
    return await _db.delete(
      'novels',
      where: 'rowid=?',
      whereArgs: [novel.id],
    );
  }
}
