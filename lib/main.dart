import 'package:flutter/material.dart';
import 'randomButtons.dart';

void main() => runApp(RandomButtonsApp());

class RandomButtonsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: Colors.amber)),
        home: RandomButtons());
  }
}
