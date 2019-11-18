import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/providers/repository.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:rxdart/subjects.dart';

class UserBloc extends BlocBase {
  final oldCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confCtrl = TextEditingController();
  
  final _old = BehaviorSubject<String>();
  final _new = BehaviorSubject<String>();
  final _conf = BehaviorSubject<String>();
  final _loading = BehaviorSubject<bool>.seeded(false);

  //Getter
  Stream<bool> get isLoading => _loading.stream;

  //Setter
  Function(String) get setNew => _new.sink.add;
  Function(String) get setOld => _old.sink.add;
  Function(String) get setConf => _conf.sink.add;
  Function(bool) get setLoading => _loading.sink.add;

  @override
  void dispose() { 
    super.dispose();
    oldCtrl.dispose();
    newCtrl.dispose();
    confCtrl.dispose();
    _old.close();
    _new.close();
    _conf.close();
    _loading.close();
  }

  //Function
  doChangePassword(GlobalKey<FormState> key) async {
    if (key.currentState.validate()) {
      key.currentState.save();

      try {
        setLoading(true);
        var data = await repo.changePassword(_old.value, _new.value, _conf.value);
        oldCtrl.clear();
        newCtrl.clear();
        confCtrl.clear();
        
        setLoading(false);
        showAlert(
          context: key.currentContext,
          title: "Success",
          body: data
        );
      } catch (e) {
        setLoading(false);
        if (e.toString().contains("Unauthorized")) {
          return navService.navigateReplaceTo("/login", "unauthorized");
        }
        showAlert(
          context: key.currentContext,
          title: "Error",
          body: e.toString().replaceAll("Exception: ", "")
        );
      }
    }
  }

}