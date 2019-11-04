import 'package:flutter/foundation.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/expenses_model.dart';
import 'package:laundry/util/api.dart';
import 'package:laundry/util/session.dart';

class ExpenseProvider {
  Future<Expenses> fetchExpense(int page, String search) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("expenses?page=$page", body: {
      "users_id": user.id,
      "search": search
    }, auth: true);

    if (response.statusCode == 200) {
      return compute(expensesFromJson, api.getContent(response.body));
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> addExpense(String name, String expense, String time, String description) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("expenses/store", body: {
      "name": name,
      "expenses": expense,
      "users_id": user.id,
      "time": time,
      "description": description
    }, auth: true);

    if (response.statusCode == 200) {
      return "Berhasil Menambahkan Pengeluaran";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> editExpense(String id, String name, String expense, String time, String description) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("expenses/update", body: {
      "id": id,
      "name": name,
      "expenses": expense,
      "users_id": user.id,
      "time": time,
      "description": description
    }, auth: true);

    if (response.statusCode == 200) {
      return "Berhasil Merubah Data Pengeluaran";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> deleteExpense(String id) async {
    final response = await api.post("expenses/destroy", body: {
      "id": id
    }, auth: true);

    if (response.statusCode == 200) {
      return "Berhasil Menghapus Data Pengaluaran";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }
}