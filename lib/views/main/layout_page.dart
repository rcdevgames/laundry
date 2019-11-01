import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  void initState() { 
    super.initState();
    page = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Builder(
        builder: (ctx) {
          switch (page) {
            case 0: return new HomePage();
            case 1: return new TransactionPage();
            // case 2: return new SettingPage();
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
          // BottomNavigationBarItem(
          //   icon: Icon(FontAwesomeIcons.cog),
          //   title: Text("Pengaturan")
          // ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userAlt),
            title: Text("Akun")
          ),
        ],
      ),
    );
  }
}