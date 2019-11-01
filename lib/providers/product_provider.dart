import 'package:flutter/foundation.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/product_model.dart';
import 'package:laundry/util/api.dart';
import 'package:laundry/util/session.dart';

class ProductProvider {
  Future<Products> fetchProduct(int page, String search) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("product?page=$page", body: {
      "users_id": user.id,
      "search": search
    }, auth: true);

    if (response.statusCode == 200) {
      return compute(productsFromJson, api.getContent(response.body));
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> addProduct(String name, int price, String time, int total_time) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("product/store", body: {
      "name": name,
      "price": price.toString(),
      "users_id": user.id,
      "time": time,
      "total_time": total_time
    }, auth: true);

    if (response.statusCode == 200) {
      return "Berhasil Menambahkan Produk";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> editProduct(String id, String name, int price, String time, int total_time) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("product/update", body: {
      "id": id,
      "name": name,
      "price": price.toString(),
      "users_id": user.id,
      "time": time,
      "total_time": total_time
    }, auth: true);

    if (response.statusCode == 200) {
      return "Berhasil Merubah Data Produk";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }

  Future<String> deleteProduct(String id) async {
    final response = await api.post("product/destroy", body: {
      "id": id
    }, auth: true);

    if (response.statusCode == 200) {
      return "Berhasil Menghapus Data Produk";
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }
}