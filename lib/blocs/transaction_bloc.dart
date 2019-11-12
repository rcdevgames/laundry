import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/models/customer_model.dart';
import 'package:laundry/models/product_model.dart';
import 'package:laundry/models/transaction_model.dart';
import 'package:laundry/providers/repository.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:rxdart/subjects.dart';

class TransactionBloc extends BlocBase {
  final _paging = new BehaviorSubject<int>.seeded(0);
  final _trx_process = new BehaviorSubject<Transactions>();
  final _trx_complete = new BehaviorSubject<Transactions>();
  final _customer_list = new BehaviorSubject<List<Customer>>();
  final _product_list = new BehaviorSubject<List<Product>>();
  final _customer_list_backup = new BehaviorSubject<List<Customer>>();
  final _product_list_backup = new BehaviorSubject<List<Product>>();
  final _loading = new BehaviorSubject<bool>.seeded(false);
  final _users_id = new BehaviorSubject<String>();
  final _name = new BehaviorSubject<String>();
  final _phone = new BehaviorSubject<String>();
  final _email = new BehaviorSubject<String>();
  final _product_id = new BehaviorSubject<String>();
  final _qty = new BehaviorSubject<int>();

  TransactionBloc() {
    fetchProcessTrasaction();
    fetchCompleteTransaction();
  }

  //Getter
  Stream<int> get getPage => _paging.stream;
  Stream<Transactions> get getProcessTRX => _trx_process.stream;
  Stream<Transactions> get getCompleteTRX => _trx_complete.stream;
  Stream<List<Customer>> get getCustomer => _customer_list.stream;
  Stream<List<Product>> get getProduct => _product_list.stream;
  Stream<bool> get isLoading => _loading.stream;
  Stream<String> get getCustomerID => _users_id.stream;

  //Setter
  Function(bool) get setLoading => _loading.sink.add;
  Function(int) get setPage => _paging.sink.add;
  Function(Transactions) get setProcessTRX => _trx_process.sink.add;
  Function(Transactions) get setCompleteTRX => _trx_complete.sink.add;
  Function(String) get setCustomer => _users_id.sink.add;
  Function(String) get setName => _name.sink.add;
  Function(String) get setPhone => _phone.sink.add;
  Function(String) get setEmail => _email.sink.add;
  Function(String) get setProductID => _product_id.sink.add;
  Function(int) get setQTY => _qty.sink.add;


  //Function
  Future fetchProducts() async {
    try {
      final data = await repo.fetchProductAll();
      _product_list.sink.add(data);
      _product_list_backup.sink.add(data);
    } catch (e) {
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login", "unauthorized");
      }
      _product_list.sink.addError(e.toString().replaceAll("Exception: ", ""));
    }
  }
  fetchCustomer() async {
    try {
      final data = await repo.fetchCustomerAll();
      _customer_list.sink.add(data);
      _customer_list_backup.sink.add(data);
    } catch (e) {
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login", "unauthorized");
      }
      _customer_list.sink.addError(e.toString().replaceAll("Exception: ", ""));
    }
  }
  Future fetchProcessTrasaction([String url]) async {
    try {
      if (url != null) {
        final uri = Uri.parse(url);
        final data = await repo.fetchTransaction(int.parse(uri.queryParameters['page']));
        final transaction = data.toJson();
        transaction['data'] = _trx_process.value.data + data.data;
        _trx_process.sink.add(await compute(transactionsFromJson, jsonEncode(transaction)));
      }else{
        final data = await repo.fetchTransaction(1);
        _trx_process.sink.add(data);
      }
    } catch (e) {
      print(e.toString());
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login", "unauthorized");
      }
      _trx_process.sink.addError(e.toString().replaceAll("Exception: ", ""));
    }
  }
  Future fetchCompleteTransaction([String url]) async {
    try {
      if (url != null) {
        final uri = Uri.parse(url);
        final data = await repo.fetchTransaction(int.parse(uri.queryParameters['page']), "selesai");
        final transaction = data.toJson();
        transaction['data'] = _trx_complete.value.data + data.data;
        _trx_complete.sink.add(await compute(transactionsFromJson, jsonEncode(transaction)));
      }else{
        final data = await repo.fetchTransaction(1, "selesai");
        _trx_complete.sink.add(data);
      }
    } catch (e) {
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login", "unauthorized");
      }
      _trx_complete.sink.addError(e.toString().replaceAll("Exception: ", ""));
    }
  }
  doTransaction(GlobalKey<FormState> key) async {
    if (key.currentState.validate()) {
      key.currentState.save();
      setLoading(true);
      try {
        var result = await repo.createTransaction(_product_id.value, _qty.value, _name.value, _phone.value, _email.value, _users_id.value);
        setLoading(false);
        showAlert(
          context: key.currentContext,
          title: "Transaksi Berhasil",
          body: result
        );
      } catch (e) {
        setLoading(false);
        if (e.toString().contains("Unauthorized")) {
          return navService.navigateReplaceTo("/login", "unauthorized");
        }
        showAlert(
          context: key.currentContext,
          title: "Transaksi Gagal",
          body: e.toString().replaceAll("Exception: ", "")
        );
      }
    }
  }
  filterCustomer(String query) {
    List<Customer> filter = [];
    if (query.isEmpty) {
      _customer_list.sink.add(_customer_list_backup.value);
    }else{
      _customer_list_backup.value.forEach((i) {
        if (i.name.toLowerCase().contains(query) || i.phoneNumber.contains(query)) {
          filter.add(i);
        }
      });
      _customer_list.sink.add(filter);
    }
  }
  filterProduct(String query) {
    List<Product> filter = [];
    if (query.isNotEmpty) {
      _product_list_backup.value.forEach((i) {
        if (i.name.toLowerCase().contains(query)) {
          filter.add(i);
        }
      });
      _product_list.sink.add(filter);
    }else{
      _product_list.sink.add(_product_list_backup.value);
    }
  }
}