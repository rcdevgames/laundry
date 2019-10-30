import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  final _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Trasanction", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
      ),
      body: SizedBox(),
    );
  }
}