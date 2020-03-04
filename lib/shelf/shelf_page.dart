import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

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
              return Card(
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  child: Center(child: Text(ss.data[idx].name)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => ReaderPage(ss.data[idx])),
                    );
                  },
                  onLongPress: () => SQL.delete(ss.data[idx]).then((val) => setState(() {})),
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
          ).then((fp) => SQL.insert(Novel.init(fp))).then((val) => setState(() {}));
        },
      ),
    );
  }
}
