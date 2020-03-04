import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:selfnovel/model/novel.dart';
import 'package:selfnovel/reader/chapter_view.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage(this.nvl);

  final Novel nvl;

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(initialPage: widget.nvl.progress),
      itemCount: widget.nvl.catalog.length,
      itemBuilder: (ctx, idx) {
        return ChapterView(widget.nvl.catalog[idx]);
      },
    );
  }
}
