import 'dart:convert';
import 'dart:io';

import 'package:selfnovel/model/chapter.dart';

class Novel {
  Novel(this.id, this.name, this.path, this.catalog, this.progress);

  int id;
  String name;
  String path;
  List<Chapter> catalog;
  int progress;

  String _text;

  Novel.init(this.path) {
    String str = text;
    name = path.split('/').last;
    catalog = RegExp('第.*?章.*').allMatches(str).map((m) => Chapter(this, m.group(0), m.start, m.end)).toList();
    catalog.forEach((cpt) => cpt.index = catalog.indexOf(cpt));
    progress = 0;
  }

  Novel.fromMap(Map<String, dynamic> map) {
    id = map['rowid'] as int;
    name = map['name'] as String;
    path = map['path'] as String;
    catalog = [for (dynamic cpt in jsonDecode(map['catalog']) as List<dynamic>) Chapter.fromMap(this, cpt)];
    progress = map['progress'] as int;
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'path': path,
        'catalog': jsonEncode([for (Chapter cpt in catalog) cpt.toMap()]),
        'progress': progress,
      };

  String get text {
    if (_text == null) _text = File(path).readAsStringSync();
    return _text;
  }
}
