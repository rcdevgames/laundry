import 'package:flutter/material.dart';

class TransactionPrintPage extends StatefulWidget {
  @override
  _TransactionPrintPageState createState() => _TransactionPrintPageState();
}

class _TransactionPrintPageState extends State<TransactionPrintPage> {
  final _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Cetak Bukti Transaksi", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: null,
    );
  }
}