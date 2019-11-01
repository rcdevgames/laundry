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

  Widget input({
    TextEditingController controller, 
    @required String title, 
    void Function(String) onSaved, 
    String Function(String) validator,
    bool enabled,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 10, 26, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title),
          SizedBox(height: 3),
          TextFormField(
            controller: controller,
            validator: validator,
            onSaved: onSaved,
            enabled: enabled,
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              border: OutlineInputBorder(borderSide: BorderSide(width: 1))
            ),
          )
        ],
      ),
    );
  }

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
                height: hp(50),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text("Ganti Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                      ),
                    ),
                    input(
                      title: "Password Lama",
                      validator: validateRequired
                    ),
                    input(
                      title: "Password Baru",
                      validator: validateRequired
                    ),
                    input(
                      title: "Konfirmasi Password Baru",
                      validator: validateRequired
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(26, 10, 26, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.lightBlue,
                            onPressed: () => null,
                            child: Text("Simpan Perubahan", style: TextStyle(color: Colors.white)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
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