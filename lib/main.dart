import 'package:flutter/material.dart';
import 'package:custom_gauge/gauge.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gauge Example'),
        ),
        body: Center(
          child: Gauge(),
        ),
      ),
    );
  }
}
