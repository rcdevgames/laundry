import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/customer_model.dart';
import 'package:laundry/util/api.dart';
import 'package:laundry/util/session.dart';

class CustomerProvider {
  Future<Customers> fetchCustomer(int page, String search) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("customer?page=$page", body: {
      "users_id": user.id,
      "search": search
    }, auth: true);

    if (response.statusCode == 200) {
      return compute(customersFromJson, api.getContent(response.body));
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }
  Future<List<Customer>> fetchCustomerAll() async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("customer", body: {
      "users_id": user.id,
      "type": "all"
    }, auth: true);

    if (response.statusCode == 200) {
      return List<Customer>.from(jsonDecode(response.body)["data"].map((x) => Customer.fromJson(x)));
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> addCustomer(String name, String phone, String email) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("customer/store", body: {
      "name": name,
      "phone_number": phone,
      "users_id": user.id,
      "email": email,
    }, auth: true);

    if (response.statusCode == 200) {
      return "Berhasil Menambahkan Customer";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> editCustomer(String id, String name, String phone, String email) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("customer/update", body: {
      "id": id,
      "name": name,
      "phone_number": phone,
      "users_id": user.id,
      "email": email,
    }, auth: true);

    if (response.statusCode == 200) {
      return "Berhasil Merubah Data Customer";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> deleteCustomer(String id) async {
    final response = await api.post("customer/destroy", body: {
      "id": id
    }, auth: true);

    if (response.statusCode == 200) {
      return "Berhasil Menghapus Data Customer";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }
}