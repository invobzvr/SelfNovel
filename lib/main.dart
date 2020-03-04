import 'package:flutter/material.dart';

import 'package:selfnovel/shelf/shelf_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self Novel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShelfPage(),
    );
  }
}
