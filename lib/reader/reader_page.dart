import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kxlib/kxlib.dart' as kx show ChapterView; // ignore: UNUSED_IMPORT

import 'package:selfnovel/model/novel.dart';
import 'package:selfnovel/reader/chapter_view.dart'; // ignore: UNUSED_IMPORT

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
    List ctlg = widget.nvl.catalog;
    return Scaffold(
      drawer: Drawer(
        child: ListView.separated(
          separatorBuilder: (ctx, idx) => const Divider(height: 0),
          itemCount: ctlg.length,
          itemBuilder: (ctx, idx) {
            return ListTile(
              title: Text(ctlg[idx].title),
              onTap: () {
                pc.jumpToPage(idx);
                Navigator.pop(ctx);
              },
            );
          },
        ),
      ),
      body: PageView.builder(
        controller: pc,
        itemCount: ctlg.length,
        itemBuilder: (ctx, idx) => kx.ChapterView(ctlg[idx]),
      ),
    );
  }
}
