import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/customer_model.dart';
import 'package:laundry/models/expenses_model.dart';
import 'package:laundry/models/product_model.dart';
import 'package:laundry/providers/auth_provider.dart';
import 'package:laundry/providers/customer_provider.dart';
import 'package:laundry/providers/expenses_provider.dart';
import 'package:laundry/providers/product_provider.dart';

class Repository {
  final authProvider = new AuthProvider();
  Future<Auth> actionLogin(String email, String password) => authProvider.actionLogin(email, password);

  final productProvider = new ProductProvider();
  Future<Products> fetchProduct([int page = 1, String search = ""]) => productProvider.fetchProduct(page, search);
  Future<String> addProduct(String name, int price, String time, int total_time) => productProvider.addProduct(name, price, time, total_time);
  Future<String> editProduct(String id, String name, int price, String time, int total_time) => productProvider.editProduct(id, name, price, time, total_time);
  Future<String> deleteProduct(String id) => productProvider.deleteProduct(id);

  final customerProvider = new CustomerProvider();
  Future<Customers> fetchCustomer([int page = 1, String search = ""]) => customerProvider.fetchCustomer(page, search);
  Future<String> addCustomer(String name, String phone, String email) => customerProvider.addCustomer(name, phone, email);
  Future<String> editCustomer(String id, String name, String phone, String email) => customerProvider.editCustomer(id, name, phone, email);
  Future<String> deleteCustomer(String id) => customerProvider.deleteCustomer(id);

  final expenseProvider = new ExpenseProvider();
  Future<Expenses> fetchExpense([int page = 1, String search = ""]) => expenseProvider.fetchExpense(page, search);
  Future<String> addExpense(String name, String expense, String time, String description) => expenseProvider.addExpense(name, expense, time, description);
  Future<String> editExpense(String id, String name, String expense, String time, String description) => expenseProvider.editExpense(id, name, expense, time, description);
  Future<String> deleteExpense(String id) => expenseProvider.deleteExpense(id);

}

final repo = new Repository();