import 'package:flutter/material.dart';
import 'randomButtons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.purple,
            appBarTheme: AppBarTheme(backgroundColor: Colors.amber)),
        home: RandomButtons());
  }
}
