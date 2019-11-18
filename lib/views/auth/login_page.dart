import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/blocs/login_bloc.dart';
import 'package:laundry/util/session.dart';
import 'package:laundry/util/validator.dart';
import 'package:laundry/widget/loading.dart';
import 'package:laundry/widget/top_shape.dart';
import 'package:responsive_screen/responsive_screen.dart';

class LoginPage extends StatefulWidget {
  String data;
  LoginPage([this.data]);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidationMixin {
  final _key = new GlobalKey<ScaffoldState>();
  final _form = new GlobalKey<FormState>();
  final bloc = BlocProvider.getBloc<LoginBloc>();

  @override
  void initState() { 
    super.initState();
    init();
  }

  init() async {
    if (widget.data != null) {
      sessions.clear();
      await Future.delayed(const Duration(milliseconds: 500));
      // _key?.currentState.showSnackBar(SnackBar(
      //   content: Text("Sesi telah habis, silakan login kembali!"),
      // ));
      showAlert(
        context: context,
        title: "Session Expired",
        body: "Sesi telah habis, silakan login kembali!"
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return Stack(
      children: <Widget>[
        Scaffold(
          key: _key,
          body: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    TopBar(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Logo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28))
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: hp(5)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: bloc.setEmail,
                    decoration: InputDecoration(
                      labelText: "Email",
                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                    ),
                  ),
                ),
                SizedBox(height: hp(1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    validator: validatePassword,
                    onSaved: bloc.setPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 10, 35, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      StreamBuilder(
                        initialData: "",
                        stream: bloc.getVersion,
                        builder: (context, snapshot) {
                          return Text(snapshot.data, style: TextStyle(fontSize: 12, color: Colors.black45));
                        }
                      )
                    ],
                  ),
                ),
                SizedBox(height: hp(2)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    onPressed: () => bloc.doLogin(_form),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: Text("MASUK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
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