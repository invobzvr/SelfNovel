import 'package:flutter/material.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:selfnovel/model/novel.dart';

class ReaderDrawer extends StatelessWidget {
  const ReaderDrawer(this.nvl, this.pc);

  final Novel nvl;
  final PageController pc;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ScrollablePositionedList.separated(
        padding: EdgeInsets.zero,
        initialScrollIndex: nvl.progress,
        separatorBuilder: (ctx, idx) => const Divider(height: 0),
        itemCount: nvl.catalog.length,
        itemBuilder: (ctx, idx) {
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Tooltip(
                message: nvl.catalog[idx].title,
                child: Text(
                  nvl.catalog[idx].title,
                  overflow: TextOverflow.ellipsis,
                  style: idx == nvl.progress ? const TextStyle(fontWeight: FontWeight.bold) : null,
                ),
              ),
            ),
            onTap: () {
              pc.jumpToPage(idx);
              Navigator.pop(ctx);
            },
          );
        },
      ),
    );
  }
}
