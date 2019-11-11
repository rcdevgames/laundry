// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
    int transactionDone;
    int transactionDoneTotal;
    int expenses;
    int expensesTotal;
    int transactionProses;
    int transactionProsesTotal;
    int customerTotal;
    int productTotal;
    int expensesSistem;
    int profit;

    Report({
        this.transactionDone,
        this.transactionDoneTotal,
        this.expenses,
        this.expensesTotal,
        this.transactionProses,
        this.transactionProsesTotal,
        this.customerTotal,
        this.productTotal,
        this.expensesSistem,
        this.profit,
    });

    factory Report.fromJson(Map<String, dynamic> json) => Report(
        transactionDone: json["transaction_done"] == null ? null : int.parse(json["transaction_done"].toString()),
        transactionDoneTotal: json["transaction_done_total"] == null ? null : int.parse(json["transaction_done_total"].toString()),
        expenses: json["expenses"] == null ? null : int.parse(json["expenses"].toString()),
        expensesTotal: json["expenses_total"] == null ? null : int.parse(json["expenses_total"].toString()),
        transactionProses: json["transaction_proses"] == null ? null : int.parse(json["transaction_proses"].toString()),
        transactionProsesTotal: json["transaction_proses_total"] == null ? null : int.parse(json["transaction_proses_total"].toString()),
        customerTotal: json["customer_total"] == null ? null : int.parse(json["customer_total"].toString()),
        productTotal: json["product_total"] == null ? null : int.parse(json["product_total"].toString()),
        expensesSistem: json["expenses_sistem"] == null ? null : int.parse(json["expenses_sistem"].toString()),
        profit: json["profit"] == null ? null : int.parse(json["profit"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "transaction_done": transactionDone == null ? null : transactionDone,
        "transaction_done_total": transactionDoneTotal == null ? null : transactionDoneTotal,
        "expenses": expenses == null ? null : expenses,
        "expenses_total": expensesTotal == null ? null : expensesTotal,
        "transaction_proses": transactionProses == null ? null : transactionProses,
        "transaction_proses_total": transactionProsesTotal == null ? null : transactionProsesTotal,
        "customer_total": customerTotal == null ? null : customerTotal,
        "product_total": productTotal == null ? null : productTotal,
        "expenses_sistem": expensesSistem == null ? null : expensesSistem,
        "profit": profit == null ? null : profit,
    };
}
