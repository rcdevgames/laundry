import 'package:flutter/foundation.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/new_transaction_model.dart';
import 'package:laundry/models/transaction_model.dart';
import 'package:laundry/util/api.dart';
import 'package:laundry/util/session.dart';

class TransactionProvider {
  Future<Transactions> fetchTransaction(int page, String type) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("transaction?page=$page", body: {
      "users_id": user.id,
      "status": type
    }, auth: true);

    if (response.statusCode == 200) {
      return compute(transactionsFromJson, api.getContent(response.body));
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<NewTransaction> createTransaction(String product_id, int qty, String name, String phone, String email, String id) async {
    final user = await compute(authFromJson, await sessions.load("auth"));
    Map<String, dynamic> body;
    if (id != null) {
      body = {
        "users_id": user.id,
        "customer_id": id,
        "product_id": product_id,
        "qty": qty
      };
    } else {
      body = {
        "users_id": user.id,
        "name": name,
        "phone_number": phone,
        "email": email,
        "product_id": product_id,
        "qty": qty
      };
    }

    final response = await api.post("transaction/store", body: body, auth: true);

    if (response.statusCode == 200) {
      return compute(newTransactionFromJson, api.getContent(response.body));
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> updateTransaction(String id, String status) async {
    final user = await compute(authFromJson, await sessions.load("auth"));
    final response = await api.post("transaction/update", body: {
      "users_id": user.id,
      "status": status,
      "id": id
    }, auth: true);
    
    if (response.statusCode == 200) {
      return "Transaksi Berhasil di Ubah.";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }
}