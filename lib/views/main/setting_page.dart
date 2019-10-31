import 'package:flutter/material.dart';
import 'package:laundry/util/validator.dart';
import 'package:responsive_screen/responsive_screen.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with ValidationMixin {
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
            height: hp(55),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text("Keterangan Nota", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                  ),
                ),
                input(
                  title: "Nama Toko",
                  validator: validateRequired
                ),
                input(
                  title: "Alamat",
                  validator: validateRequired
                ),
                input(
                  title: "Nomor Telpon",
                  validator: validateRequired
                ),
                input(
                  title: "Email",
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
    );
  }
}