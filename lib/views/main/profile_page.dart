import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:laundry/util/session.dart';
import 'package:laundry/util/validator.dart';
import 'package:responsive_screen/responsive_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ValidationMixin{
  final _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Informasi Akun", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              showAlert(
                context: context,
                title: "Logout",
                body: "Apakah Anda yakin ingin keluar?",
                barrierDismissible: false,
                actions: [
                  AlertAction(
                    text: "Cancel",
                    onPressed: () => null
                  ),
                  AlertAction(
                    text: "Lanjutkan",
                    onPressed: () {
                      sessions.clear();
                      navService.navigateReplaceTo("/login");
                    }
                  ),
                ]
              );
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              child: SizedBox(
                width: double.infinity,
                height: hp(40),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text("Keterangan Nota", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              child: SizedBox(
                width: double.infinity,
                height: hp(40),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text("Keterangan Nota", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              child: SizedBox(
                width: double.infinity,
                height: hp(40),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text("Keterangan Nota", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}