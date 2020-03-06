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

class _ShelfPageState extends State<ShelfPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('Shelf')),
      body: FutureBuilder<List<Novel>>(
        future: SQL.init().then((val) => SQL.select()),
        builder: (ctx, ss) {
          if (ss.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 4,
            ),
            itemCount: ss.data?.length ?? 0,
            itemBuilder: (ctx, idx) {
              Novel nvl = ss.data[idx];
              return Card(
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  child: Center(child: Text(nvl.name)),
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
                            child: Text('Delete'),
                            onPressed: () => SQL.delete(nvl).then((val) => Navigator.pop(context)).then((val) => setState(() {})),
                          ),
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
                        ],
                      ),
                    );
                  },
                ),
              );
            },
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
            SQL.insert(Novel.init(fp));
            setState(() {});
          });
        },
      ),
    );
  }
}
