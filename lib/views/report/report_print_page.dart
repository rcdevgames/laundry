import 'package:flutter/material.dart';

class ReportPrintPage extends StatefulWidget {
  @override
  _ReportPrintPageState createState() => _ReportPrintPageState();
}

class _ReportPrintPageState extends State<ReportPrintPage> {
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