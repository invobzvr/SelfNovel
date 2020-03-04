import 'package:selfnovel/model/novel.dart';

class Chapter {
  Novel novel;
  int index;
  String title;
  int start;
  int end;

  Chapter(this.novel, this.title, this.start, this.end);

  Chapter.fromMap(this.novel, Map<String, dynamic> map) {
    index = map['index'] as int;
    title = map['title'] as String;
    start = map['start'] as int;
    end = map['end'] as int;
  }

  Map<String, dynamic> toMap() => {
        'index': index,
        'title': title,
        'start': start,
        'end': end,
      };

  String get text => novel.text.substring(start, novel.catalog[index + 1].start);
}
