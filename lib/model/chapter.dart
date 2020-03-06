import 'package:selfnovel/model/novel.dart';
import 'package:selfnovel/utils/sql.dart';

class Chapter {
  Novel novel;
  int index;
  String title;
  int start;
  int end;
  String tag;

  Chapter(this.novel, this.title, this.start, this.end);

  Chapter.fromMap(this.novel, Map<String, dynamic> map) {
    index = map['index'] as int;
    title = map['title'] as String;
    start = map['start'] as int;
    end = map['end'] as int;
    tag = map['tag'] as String;
  }

  Map<String, dynamic> toMap() => {
        'index': index,
        'title': title,
        'start': start,
        'end': end,
        'tag': tag,
      };

  Future<int> set() async => await SQL.updateProgress(novel..progress = index);

  String get text => novel.text.substring(start, novel[index + 1]?.start);
}
