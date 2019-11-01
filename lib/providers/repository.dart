import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/product_model.dart';
import 'package:laundry/providers/auth_provider.dart';
import 'package:laundry/providers/product_provider.dart';

class Repository {
  final authProvider = new AuthProvider();
  Future<Auth> actionLogin(String email, String password) => authProvider.actionLogin(email, password);

  final productProvider = new ProductProvider();
  Future<Products> fetchProduct([int page = 1, String search = ""]) => productProvider.fetchProduct(page, search);
  Future<String> addProduct(String name, int price, String time, int total_time) => productProvider.addProduct(name, price, time, total_time);
  Future<String> editProduct(String id, String name, int price, String time, int total_time) => productProvider.editProduct(id, name, price, time, total_time);
  Future<String> deleteProduct(String id) => productProvider.deleteProduct(id);

  

}

final repo = new Repository();