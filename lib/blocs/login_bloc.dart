import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/providers/repository.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:laundry/util/session.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _version = BehaviorSubject<String>();
  final _loading = BehaviorSubject<bool>.seeded(false);

  //Getter
  Stream<bool> get isLoading => _loading.stream;
  Stream<String> get getVersion => _version.stream;

  //Setter
  Function(bool) get setLoading => _loading.sink.add;
  Function(String) get setEmail => _email.sink.add;
  Function(String) get setPassword => _password.sink.add;

  LoginBloc() {
    getVer();
  }


  //Function
  doLogin(GlobalKey<FormState> key) async {
    if (key.currentState.validate()) {
      key.currentState.save();
      
      setLoading(true);
      try {
        final auth = await repo.actionLogin(_email.value, _password.value);
        sessions.save("token", auth.token);
        sessions.save("auth", jsonEncode(auth.toJson()));
        setLoading(false);
        navService.navigateReplaceTo("/main");
      } on TimeoutException catch (_) {
        setLoading(false);
        showAlert(
          context: key.currentContext,
          title: "Request Timeout",
          body: "Waktu telah habis, silahkan coba kembali."
        );
      } catch (e) {
        setLoading(false);
        showAlert(
          context: key.currentContext,
          title: "Error",
          body: e.toString().replaceAll("Exception: ", "")
        );
      }
    }
  }

  getVer() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version.sink.add("v${packageInfo.version}+${packageInfo.buildNumber}");
  }

}