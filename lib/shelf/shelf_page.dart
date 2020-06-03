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
        itemBuilder: (lvCtx, idx) {
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
                      child: nvl.cover == null ? null : Image.network(nvl.cover),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nvl.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          Text(nvl.author ?? '\x01', style: TextStyle(fontStyle: FontStyle.italic)),
                          const SizedBox(height: 5),
                          Text(nvl.catalog[nvl.progress].title, softWrap: false, overflow: TextOverflow.ellipsis),
                          Text(DateTime.fromMillisecondsSinceEpoch(nvl.ts).toString())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (prCtx) => ReaderPage(nvl))),
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (sdCtx) => SimpleDialog(
                    children: [
                      SimpleDialogOption(
                        child: Text('Parse Catalog'),
                        onPressed: () {
                          Navigator.pop(sdCtx);
                          showDialog(
                            context: context,
                            builder: (adCtx) => AlertDialog(
                              content: TextFormField(
                                autofocus: true,
                                initialValue: r'[\n\r]{1,2}([^\u3000\n\r]+)[\n\r]{1,2}\u3000',
                                onFieldSubmitted: (str) async {
                                  await SQL.update(nvl..parseCatalog(str));
                                  Navigator.pop(adCtx);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      kx.AttachDialogOption(context, nvl),
                      SimpleDialogOption(
                        child: Text('Delete'),
                        onPressed: () async {
                          list.remove(nvl);
                          await SQL.delete(nvl);
                          setState(() {});
                          Navigator.pop(sdCtx);
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
          ).then((fp) async {
            if (fp == null) return;
            Novel nvl = Novel.init(fp);
            list.add(nvl);
            await SQL.insert(nvl).then((id) => nvl.id = id);
            setState(() {});
          });
        },
      ),
    );
  }
}
