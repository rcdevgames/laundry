import 'package:flutter/foundation.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/util/api.dart';
import 'package:laundry/util/session.dart';

class AuthProvider {
  Future<Auth> actionLogin(String email, String password) async {
    final response = await api.oAuth(body: {
      "email": email,
      "password": password
    });

    print(response.body);

    if (response.statusCode == 200) {
      return compute(authFromJson, api.getContent(response.body));
      
    } else if(response.statusCode == 401) {
      throw Exception("Email atau Password salah!");
    } else {
      throw Exception(api.getError(response.body));
    }
  }

  Future<String> changePassword(String old_password, String new_password, String conf_password) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("user/update-password", body: {
      "users_id": user.id,
      "old_password": old_password,
      "new_password": new_password,
      "confirm_password": conf_password
    }, auth: true);

    print({
      "users_id": user.id,
      "old_password": old_password,
      "new_password": new_password,
      "confirm_password": conf_password
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      return "Berhasil Merubah Password";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }
}