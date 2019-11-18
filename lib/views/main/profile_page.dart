import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/blocs/user_bloc.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:laundry/util/session.dart';
import 'package:laundry/util/validator.dart';
import 'package:laundry/widget/loading.dart';
import 'package:responsive_screen/responsive_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ValidationMixin{
  final _key = new GlobalKey<ScaffoldState>();
  final _form = new GlobalKey<FormState>();

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
    final bloc = BlocProvider.getBloc<UserBloc>();

    return Stack(
      children: <Widget>[
        Scaffold(
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
                  child: Form(
                    key: _form,
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
                          controller: bloc.oldCtrl,
                          title: "Password Lama",
                          validator: validateRequired,
                          onSaved: bloc.setOld
                        ),
                        input(
                          controller: bloc.newCtrl,
                          title: "Password Baru",
                          validator: validateRequired,
                          onSaved: bloc.setNew
                        ),
                        input(
                          controller: bloc.confCtrl,
                          title: "Konfirmasi Password Baru",
                          validator: validateRequired,
                          onSaved: bloc.setConf
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(26, 10, 26, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.lightBlue,
                                onPressed: () => bloc.doChangePassword(_form),
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
        ),
        StreamBuilder(
          initialData: false,
          stream: bloc.isLoading,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return Loading(snapshot.data);
          }
        )
      ],
    );
  }
}