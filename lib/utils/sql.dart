import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import 'package:selfnovel/model/novel.dart';

class SQL {
  static const String _DB_NAME = 'sn.db';

  static bool ready = false;
  static Database db;

  static Future<void> init() async {
    if (db != null) return;
    String dbPath = await getDatabasesPath();
    db = await openDatabase(
      join(dbPath, _DB_NAME),
      version: 1,
      onCreate: (db, ver) async => await db.execute('CREATE TABLE novels(name TEXT,author TEXT,cover TEXT,path TEXT,ts INT,catalog TEXT,progress INT)'),
    );
  }

  static Future<List<Novel>> select() async {
    return (await db.query('novels', columns: ['rowid', '*'])).map((map) => Novel.fromMap(map)).toList();
  }

  static Future<int> insert(Novel novel) async {
    return await db.insert(
      'novels',
      novel.toMap(),
    );
  }

  static Future<int> update(Novel novel) async {
    return await db.update(
      'novels',
      novel.toMap(),
      where: 'rowid=?',
      whereArgs: [novel.id],
    );
  }

  static Future<int> updateProgress(Novel novel) async {
    return await db.update(
      'novels',
      {'progress': novel.progress},
      where: 'rowid=?',
      whereArgs: [novel.id],
    );
  }

  static Future<int> delete(Novel novel) async {
    return await db.delete(
      'novels',
      where: 'rowid=?',
      whereArgs: [novel.id],
    );
  }
}
