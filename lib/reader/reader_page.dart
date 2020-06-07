import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:selfnovel/model/novel.dart';
import 'package:selfnovel/reader/reader_drawer.dart';
import 'package:selfnovel/reader/chapter_view.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage(this.nvl);

  final Novel nvl;

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  PageController pc;

  @override
  void initState() {
    pc = PageController(initialPage: widget.nvl.progress);
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    pc.dispose();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ReaderDrawer(widget.nvl, pc),
      body: PageView.builder(
        controller: pc,
        itemCount: widget.nvl.catalog.length,
        itemBuilder: (ctx, idx) => ChapterView(widget.nvl.catalog[idx]),
      ),
    );
  }
}
