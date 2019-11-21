import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/util/session.dart';
import 'package:laundry/views/main/home_page.dart';
import 'package:laundry/views/main/profile_page.dart';
import 'package:laundry/views/main/setting_page.dart';
import 'package:laundry/views/main/transaction_page.dart';

class LayoutPage extends StatefulWidget {
  @override
  LayoutPageState createState() => LayoutPageState();
}

class LayoutPageState extends State<LayoutPage> {
  final _key = new GlobalKey<ScaffoldState>();
  int page;
  Auth user;

  @override
  void initState() { 
    super.initState();
    initSessions();
    page = 0;
    setState(() {});
  }

  initSessions() async {
    var data = await sessions.load("auth");
    if (data != null) {
      user = await compute(authFromJson, data);
    }
    setState(() {});
  }

  @override
  void dispose() { 
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Builder(
        builder: (ctx) {
          switch (page) {
            case 0: return new HomePage(user);
            case 1: return new TransactionPage();
            case 2: return new ProfilePage();
            default: return Container();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: page,
        onTap: (i) => setState(() => page = i),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.listAlt),
            title: Text("Transaksi")
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userAlt),
            title: Text("Akun")
          ),
        ],
      ),
    );
  }
}