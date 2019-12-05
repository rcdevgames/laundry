// To parse this JSON data, do
//
//     final newTransaction = newTransactionFromJson(jsonString);

import 'dart:convert';

NewTransaction newTransactionFromJson(String str) => NewTransaction.fromJson(json.decode(str));

String newTransactionToJson(NewTransaction data) => json.encode(data.toJson());

class NewTransaction {
    String id;
    String transactionId;
    String qty;
    int price;
    int total;
    DateTime deletedAt;
    DateTime createdAt;
    DateTime updatedAt;
    String usersId;
    String productName;
    String productTime;
    int productTotalTime;
    int percenLaba;

    NewTransaction({
        this.id,
        this.transactionId,
        this.qty,
        this.price,
        this.total,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.usersId,
        this.productName,
        this.productTime,
        this.productTotalTime,
        this.percenLaba,
    });

    factory NewTransaction.fromJson(Map<String, dynamic> json) => NewTransaction(
        id: json["id"] == null ? null : json["id"],
        transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
        qty: json["qty"] == null ? null : json["qty"],
        price: json["price"] == null ? null : json["price"],
        total: json["total"] == null ? null : json["total"],
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        usersId: json["users_id"] == null ? null : json["users_id"],
        productName: json["product_name"] == null ? null : json["product_name"],
        productTime: json["product_time"] == null ? null : json["product_time"],
        productTotalTime: json["product_total_time"] == null ? null : json["product_total_time"],
        percenLaba: json["percen_laba"] == null ? null : json["percen_laba"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "transaction_id": transactionId == null ? null : transactionId,
        "qty": qty == null ? null : qty,
        "price": price == null ? null : price,
        "total": total == null ? null : total,
        "deleted_at": deletedAt == null ? null : deletedAt.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "users_id": usersId == null ? null : usersId,
        "product_name": productName == null ? null : productName,
        "product_time": productTime == null ? null : productTime,
        "product_total_time": productTotalTime == null ? null : productTotalTime,
        "percen_laba": percenLaba == null ? null : percenLaba,
    };
}
