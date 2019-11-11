import 'package:flutter/foundation.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/report_model.dart';
import 'package:laundry/util/api.dart';
import 'package:laundry/util/session.dart';

class ReportProvider {
  Future<Report> getReport(String month) async {
    final user = await compute(authFromJson, await sessions.load("auth"));

    final response = await api.post("report", body: {
      "users_id": user.id,
      "month": month
    }, auth: true);

    if (response.statusCode == 200) {
      return compute(reportFromJson, api.getContent(response.body));
    }else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }else{
      throw Exception(response.body);
    }
  }
}