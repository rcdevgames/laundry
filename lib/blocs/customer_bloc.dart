import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/models/customer_model.dart';
import 'package:laundry/providers/repository.dart';
import 'package:laundry/util/api.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:rxdart/rxdart.dart';

class CustomerBloc extends BlocBase {
  final _customers = BehaviorSubject<Customers>();
  final _loading = BehaviorSubject<bool>.seeded(false);
  final _name = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();

  //Getter
  Stream<Customers> get getCustomers => _customers.stream;
  Stream<bool> get isLoading => _loading.stream;

  //Setter
  Function(Customers) get setCustomers => _customers.sink.add;
  Function(bool) get setLoading => _loading.sink.add;
  Function(String) get setEmail => _email.sink.add;
  Function(String) get setName => _name.sink.add;
  Function(String) get setPhone => _phone.sink.add;

  @override
  void dispose() { 
    super.dispose();
    api.close();
    _customers.close();
    _loading.close();
    _name.close();
    _email.close();
    _phone.close();
  }

  //Function
  reset() {
    setLoading(false);
    setEmail(null);
    setName(null);
    setPhone(null);
  }

  Future fetchData() async {
    try {
      final data = await repo.fetchCustomer();
      _customers.sink.add(data);
    } catch (e) {
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login");
      }
      _customers.sink.addError(e.toString().replaceAll("Exception: ", ""));
    }
  }

  loadMore(String url) async {
    try {
      final uri = Uri.parse(url);
      final data = await repo.fetchCustomer(int.parse(uri.queryParameters['page']));
      final customers = data.toJson();
      customers['data'] = _customers.value.data + data.data;
      _customers.sink.add(await compute(customersFromJson, jsonEncode(customers)));
    } catch (e) {
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login");
      }
      _customers.sink.addError(e.toString().replaceAll("Exception: ", ""));
    }
  }

  addCustomer(GlobalKey<FormState> key) async {
    if (key.currentState.validate()) {
      key.currentState.save();
      
      try {
        setLoading(true);
        print("${_name.value}, ${_phone.value}, ${_email.value}");
        String data = await repo.addCustomer(_name.value, _phone.value, _email.value);
        await fetchData();
        setLoading(false);
        showAlert(
          context: key.currentContext,
          title: "Success",
          body: data,
          actions: [
            AlertAction(
              text: "Confirm",
              onPressed: () => navService.navigatePop()
            )
          ]
        );
      } catch (e) {
        setLoading(false);
        print(e.toString().replaceAll("Exception: ", ""));
        if (e.toString().contains("Unauthorized")) {
          return navService.navigateReplaceTo("/login");
        }
        showAlert(
          context: key.currentContext,
          title: "Error",
          body: e.toString().replaceAll("Exception: ", "")
        );
      }
    }
  }

  editCustomer(GlobalKey<FormState> key, String id) async {
    if (key.currentState.validate()) {
      key.currentState.save();

      try {
        setLoading(true);
        print("${_name.value}, ${_phone.value}, ${_email.value}");
        String data = await repo.editCustomer(id, _name.value, _phone.value, _email.value);
        await fetchData();
        setLoading(false);
        showAlert(
          context: key.currentContext,
          title: "Success",
          body: data,
          actions: [
            AlertAction(
              text: "Ok",
              onPressed: () => navService.navigatePop()
            )
          ]
        );
      } catch (e) {
        setLoading(false);
        print(e.toString().replaceAll("Exception: ", ""));
        if (e.toString().contains("Unauthorized")) {
          return navService.navigateReplaceTo("/login");
        }
        showAlert(
          context: key.currentContext,
          title: "Error",
          body: e.toString().replaceAll("Exception: ", "")
        );
      }
    }
  }

  deleteCustomer(GlobalKey<ScaffoldState> key, String id) async {
    showAlert(
      context: key.currentContext,
      title: "Hapus Customer",
      body: "Apakah anda yakin ingin menghapus customer ini?",
      actions: [
        AlertAction(
          text: "Cancel",
          onPressed: () => null
        ),
        AlertAction(
          text: "Confirm",
          onPressed: () async {
            try {
              setLoading(true);
              final data = await repo.deleteCustomer(id);
              await fetchData();
              setLoading(false);

              showAlert(
                context: key.currentContext,
                title: "Success",
                body: data,
              );
            } catch (e) {
              setLoading(false);
              print(e.toString().replaceAll("Exception: ", ""));
              if (e.toString().contains("Unauthorized")) {
                return navService.navigateReplaceTo("/login");
              }
              showAlert(
                context: key.currentContext,
                title: "Error",
                body: e.toString().replaceAll("Exception: ", "")
              );
            }
          }
        ),
      ]
    );
  }


}