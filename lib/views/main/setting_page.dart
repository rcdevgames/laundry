import 'package:flutter/material.dart';
import 'package:laundry/util/validator.dart';
import 'package:responsive_screen/responsive_screen.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with ValidationMixin {
  final _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Pengaturan", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
      ),
      body: Padding(
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
    );
  }
}