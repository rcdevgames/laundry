import 'package:flutter/foundation.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/util/api.dart';

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
}