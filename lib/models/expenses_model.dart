// To parse this JSON data, do
//
//     final expenses = expensesFromJson(jsonString);

import 'dart:convert';

Expenses expensesFromJson(String str) => Expenses.fromJson(json.decode(str));

String expensesToJson(Expenses data) => json.encode(data.toJson());

class Expenses {
    int currentPage;
    List<Expense> data;
    String firstPageUrl;
    int from;
    dynamic nextPageUrl;
    String path;
    int perPage;
    dynamic prevPageUrl;
    int to;

    Expenses({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
    });

    factory Expenses.fromJson(Map<String, dynamic> json) => Expenses(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null ? null : List<Expense>.from(json["data"].map((x) => Expense.fromJson(x))),
        firstPageUrl: json["first_page_url"] == null ? null : json["first_page_url"],
        from: json["from"] == null ? null : json["from"],
        nextPageUrl: json["next_page_url"],
        path: json["path"] == null ? null : json["path"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] == null ? null : json["to"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage == null ? null : currentPage,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl == null ? null : firstPageUrl,
        "from": from == null ? null : from,
        "next_page_url": nextPageUrl,
        "path": path == null ? null : path,
        "per_page": perPage == null ? null : perPage,
        "prev_page_url": prevPageUrl,
        "to": to == null ? null : to,
    };
}

class Expense {
    String id;
    String name;
    String slug;
    int expenses;
    dynamic deletedAt;
    DateTime createdAt;
    DateTime updatedAt;
    String usersId;
    DateTime time;
    String description;

    Expense({
        this.id,
        this.name,
        this.slug,
        this.expenses,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.usersId,
        this.time,
        this.description,
    });

    factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        expenses: json["expenses"] == null ? null : json["expenses"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        usersId: json["users_id"] == null ? null : json["users_id"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        description: json["description"] == null ? null : json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "expenses": expenses == null ? null : expenses,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "users_id": usersId == null ? null : usersId,
        "time": time == null ? null : time.toIso8601String(),
        "description": description == null ? null : description,
    };
}
