import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/models/transaction_model.dart';
import 'package:laundry/providers/repository.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:rxdart/rxdart.dart';

class ReturnBloc extends BlocBase {
  final _trx_process = new BehaviorSubject<Transactions>();
  final _loading = new BehaviorSubject<bool>.seeded(false);

  //Getter
  Stream<Transactions> get getProcessTRX => _trx_process.stream;
  Stream<bool> get isLoading => _loading.stream;

  //Setter
  Function(bool) get setLoading => _loading.sink.add;
  Function(Transactions) get setProcessTRX => _trx_process.sink.add;

  @override
  void dispose() { 
    super.dispose();
    _trx_process.close();
    _loading.close();
  }

  //Function
  Future fetchProcessTrasaction({String url, String search}) async {
    try {
      if (url != null) {
        final uri = Uri.parse(url);
        final data = await repo.fetchTransaction(int.parse(uri.queryParameters['page']), "proses", search);
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
  doFinish(BuildContext context, String id) async {
    try {
      setLoading(true);
      var data = await repo.updateTransaction(id, "selesai");
      await fetchProcessTrasaction();
      setLoading(false);
      showAlert(
        context: context,
        title: "Success",
        body: data,
      );
    } catch (e) {
      print(e.toString());
      setLoading(false);
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login", "unauthorized");
      }
      showAlert(
        context: context,
        title: "Error",
        body: e.toString().replaceAll("Exception: ", "")
      );
    }
  }
}