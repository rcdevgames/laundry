import 'package:flutter/material.dart';
import 'package:responsive_screen/responsive_screen.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Trasanction", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight - 15),
          child: DefaultTabController(
            length: 3,
            child: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("Transaksi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("Status", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("Riwayat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                )
              ],
            ),
          )
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cari Kata Kunci",
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}