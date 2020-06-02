import 'dart:convert';
import 'dart:io';

import 'package:selfnovel/model/chapter.dart';

class Novel {
  int id;
  String name;
  String path;
  int ts;
  List<Chapter> catalog;
  int progress;

  String _text;

  Novel.init(this.path) {
    ts = DateTime.now().millisecondsSinceEpoch;
    name = RegExp('.+[\\/](.*?)\.txt').firstMatch(path).group(1);
    parseCatalog('第.*?章.*');
    progress = 0;
  }

  Novel.fromMap(Map<String, dynamic> map) {
    id = map['rowid'] as int;
    name = map['name'] as String;
    path = map['path'] as String;
    ts = map['ts'] as int;
    catalog = [for (dynamic cpt in jsonDecode(map['catalog']) as List<dynamic>) Chapter.fromMap(this, cpt)];
    progress = map['progress'] as int;
  }

  Chapter operator [](int index) {
    if (!index.isNegative && index < catalog.length) return catalog[index];
    return null;
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'path': path,
        'ts': ts,
        'catalog': jsonEncode([for (Chapter cpt in catalog) cpt.toMap()]),
        'progress': progress,
      };

  void parseCatalog(String source) {
    catalog = RegExp(source).allMatches(text).map((m) => Chapter(this, m.group(0), m.start, m.end)).toList();
    catalog.forEach((cpt) => cpt.index = catalog.indexOf(cpt));
  }

  String get text {
    if (_text == null) _text = File(path).readAsStringSync();
    return _text;
  }
}
