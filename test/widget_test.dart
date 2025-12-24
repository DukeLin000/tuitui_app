// ...existing code...
import 'package:flutter/material.dart';
// ...existing code...
void main() => runApp(MyApp());
// ...existing code...
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tuitui_app',
      home: Scaffold(
        appBar: AppBar(title: Text('tuitui_app')),
        body: Center(child: Text('Hello')),
      ),
    );
  }
}
// ...existing code...