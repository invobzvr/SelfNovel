import 'package:flutter/material.dart';

import 'package:selfnovel/model/chapter.dart';

class ChapterView extends StatelessWidget {
  ChapterView(this.cpt);

  final Chapter cpt;

  @override
  Widget build(BuildContext context) {
    cpt.set();
    return SingleChildScrollView(
      child: Material(
        color: Colors.white,
        child: Text(cpt.text, style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
    );
  }
}
