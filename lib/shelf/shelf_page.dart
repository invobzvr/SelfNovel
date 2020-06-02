import 'dart:math';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:kxlib/kxlib.dart' as kx show AttachDialogOption; // ignore: UNUSED_IMPORT

import 'package:selfnovel/model/novel.dart';
import 'package:selfnovel/utils/sql.dart';
import 'package:selfnovel/reader/reader_page.dart';

class ShelfPage extends StatefulWidget {
  @override
  _ShelfPageState createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  List<Novel> list = [];

  @override
  void initState() {
    super.initState();
    SQL.select().then((val) {
      list.addAll(val);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shelf')),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx, idx) {
          Novel nvl = list[idx];
          return Card(
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      height: 120,
                      color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withAlpha(125),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nvl.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(nvl.catalog[nvl.progress].title),
                          const SizedBox(height: 5),
                          Text(DateTime.fromMillisecondsSinceEpoch(nvl.ts).toString())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => ReaderPage(nvl)),
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    children: [
                      SimpleDialogOption(
                        child: Text('Parse Catalog'),
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              content: TextFormField(
                                autofocus: true,
                                initialValue: r'[\n\r]{1,2}[^\u3000\n\r]+[\n\r]{1,2}\u3000',
                                onFieldSubmitted: (str) => SQL.update(nvl..parseCatalog(str)).then((val) => Navigator.pop(ctx)),
                              ),
                            ),
                          );
                        },
                      ),
                      kx.AttachDialogOption(nvl),
                      SimpleDialogOption(
                        child: Text('Delete'),
                        onPressed: () {
                          list.remove(nvl);
                          SQL.delete(nvl);
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FilePicker.getFilePath(
            type: FileType.CUSTOM,
            fileExtension: 'txt',
          ).then((fp) {
            if (fp == null) return;
            Novel nvl = Novel.init(fp);
            list.add(nvl);
            SQL.insert(nvl);
            setState(() {});
          });
        },
      ),
    );
  }
}
