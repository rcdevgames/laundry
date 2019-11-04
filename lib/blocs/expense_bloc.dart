import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/models/expenses_model.dart';
import 'package:laundry/providers/repository.dart';
import 'package:laundry/util/api.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:rxdart/subjects.dart';

class ExpenseBloc extends BlocBase {
  final _name = BehaviorSubject<String>();
  final _expense = BehaviorSubject<String>();
  final _time = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _loading = BehaviorSubject<bool>();
  final _expenses = BehaviorSubject<Expenses>();
  final _total = BehaviorSubject<int>.seeded(0);

  //Getter
  Stream<Expenses> get getExpenses => _expenses.stream;
  Stream<bool> get isLoading => _loading.stream;
  Stream<int> get getTotal => _total.stream;

  //Setter
  Function(String) get setName => _name.sink.add;
  Function(String) get setExpense => _expense.sink.add;
  Function(String) get setTime => _time.sink.add;
  Function(String) get setDesc => _description.sink.add;
  Function(Expenses) get setExpenses => _expenses.sink.add;
  Function(bool) get setLoading => _loading.sink.add;
  Function(int) get setTotal => _total.sink.add;


  @override
  void dispose() {
    super.dispose();
    api.close();
  }

  //Function
  reset() {

  }
  Future fetchData() async {
    try {
      final data = await repo.fetchExpense();
      data.data.forEach((i) => setTotal(_total.value + i.expenses));
      print(_total.value);
      _expenses.sink.add(data);
    } catch (e) {
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login");
      }
      _expenses.sink.addError(e.toString().replaceAll("Exception: ", ""));
    }
  }
  addData(GlobalKey<FormState> key) async {
    if (key.currentState.validate()) {
      key.currentState.save();
      
      try {
        setLoading(true);
        String data = await repo.addExpense(_name.value, _expense.value, _time.value, _description.value);
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
        String data = await repo.editExpense(id, _name.value, _expense.value, _time.value, _description.value);
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
      title: "Hapus Pengeluaran",
      body: "Apakah anda yakin ingin menghapus pengeluaran ini?",
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
              final data = await repo.deleteExpense(id);
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