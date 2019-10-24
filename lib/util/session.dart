import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Sessions {
  SharedPreferences prefs;

  Future<bool> checkAuth() async {
    prefs = await SharedPreferences.getInstance();
    var res = await prefs.getString("auth");
    if (res == null) return false;
    return true;
  }

  save(String key, String data) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
    prefs.commit();
  }

  clear() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String> load(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  remove(String key) async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<String> loadAuth() async {
    prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("token");
    if (user != null) {
      return user;
    }
  }
}

final sessions = Sessions();