import 'package:flutter/material.dart';

import 'package:selfnovel/model/chapter.dart';
import 'package:selfnovel/model/paragraph.dart';

class ChapterView extends StatelessWidget {
  ChapterView(this.cpt);

  final Chapter cpt;

  final List<Paragraph> _pars = [];

  List<Paragraph> get pars {
    if (_pars.length == 0) cpt.text.split(RegExp('[\n\r]+')).forEach((text) => _pars.add(Paragraph(text)));
    return _pars;
  }

  @override
  Widget build(BuildContext context) {
    cpt.set();
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: pars.length,
      itemBuilder: (ctx, idx) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(pars[idx].text, style: idx > 0 ? null : const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        );
      },
    );
  }
}
