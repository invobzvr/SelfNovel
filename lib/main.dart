import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:selfnovel/shelf/shelf_page.dart';
import 'package:selfnovel/utils/sql.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SQL.init().then((val) => runApp(App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self Novel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      home: ShelfPage(),
    );
  }
}
