import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:laundry/models/report_model.dart';
import 'package:laundry/providers/repository.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:rxdart/subjects.dart';

class ReportBloc extends BlocBase {
  final _report_data = BehaviorSubject<Report>();
  final _loading = BehaviorSubject<bool>.seeded(false);
  final _month = BehaviorSubject<String>.seeded("");

  ReportBloc() {
    fetchReport();
  }

  //Getter
  Stream<Report> get getReport => _report_data.stream;
  Stream<bool> get isLoading => _loading.stream;
  Stream<String> get getMonth => _month.stream;

  //Setter
  Function(Report) get setReport => _report_data.sink.add;
  Function(bool) get setLoading => _loading.sink.add;
  Function(String) get setMonth => _month.sink.add;

  @override
  void dispose() { 
    super.dispose();
    _report_data.close();
    _loading.close();
    // _month.close();
    print("Report Dispose");
  }

  //Function
  Future fetchReport() async {
    try {
      setLoading(true);
      final data = await repo.getReport(_month.value);
      print(data.toJson().toString());
      setReport(data);
      setLoading(false);
    } catch (e) {
      print(e.toString());
      setLoading(false);
      if (e.toString().contains("Unauthorized")) {
        return navService.navigateReplaceTo("/login", "unauthorized");
      }
      _report_data.sink.addError(e.toString().replaceAll("Exception: ", ""));
    }
  }
}