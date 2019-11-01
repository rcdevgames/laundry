import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/models/product_model.dart';
import 'package:laundry/providers/repository.dart';
import 'package:laundry/util/api.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final _products = BehaviorSubject<Products>();
  final _product = BehaviorSubject<Product>();
  final _loading = BehaviorSubject<bool>.seeded(false);
  final _name = BehaviorSubject<String>();
  final _price = BehaviorSubject<int>();
  final _time = BehaviorSubject<String>();
  final _total_time = BehaviorSubject<int>();
  final _id = BehaviorSubject<int>();

  //Getter
  Stream<Products> get getProducts => _products.stream;
  Stream<Product> get getProduct => _product.stream;
  Stream<bool> get isLoading => _loading.stream;
  Stream<String> get getName => _name.stream;
  Stream<String> get getTime => _time.stream;
  Stream<int> get getPrice => _price.stream;
  Stream<int> get getTotalTime => _total_time.stream;

  //Setter
  Function(Products) get setProducts => _products.sink.add;
  Function(Product) get setProduct => _product.sink.add;
  Function(bool) get setLoading => _loading.sink.add;
  Function(String) get setName => _name.sink.add;
  Function(String) get setTime => _time.sink.add;
  Function(int) get setPrice => _price.sink.add;
  Function(int) get setTotalTime => _total_time.sink.add;
  Function(int) get setID => _id.sink.add;

  @override
  void dispose() { 
    super.dispose();
    api.close();
  }

  //Function
  reset() {
    setProduct(null);
    setLoading(false);
    setName(null);
    setTime(null);
    setPrice(null);
    setTotalTime(null);
    setID(null);
  }

  Future fetchData() async {
    try {
      final data = await repo.fetchProduct();
      _products.sink.add(data);
    } catch (e) {
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login");
      }
      _products.sink.addError(e.toString().replaceAll("Exception: ", ""));
    }
  }

  addData(GlobalKey<FormState> key) async {
    if (key.currentState.validate()) {
      key.currentState.save();
      
      try {
        setLoading(true);
        String data = await repo.addProduct(_name.value, _price.value, _time.value, _total_time.value);
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
  
  editData(GlobalKey<FormState> key, String id) async {
    if (key.currentState.validate()) {
      key.currentState.save();

      try {
        setLoading(true);
        String data = await repo.editProduct(id, _name.value, _price.value, _time.value, _total_time.value);
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

  deleteData(GlobalKey<ScaffoldState> key, String id) async {
    showAlert(
      context: key.currentContext,
      title: "Hapus Produk",
      body: "Apakah anda yakin ingin menghapus produk ini?",
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
              final data = await repo.deleteProduct(id);
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