// To parse this JSON data, do
//
//     final customers = customersFromJson(jsonString);

import 'dart:convert';

Customers customersFromJson(String str) => Customers.fromJson(json.decode(str));

String customersToJson(Customers data) => json.encode(data.toJson());

class Customers {
    int currentPage;
    List<Customer> data;
    String firstPageUrl;
    int from;
    dynamic nextPageUrl;
    String path;
    int perPage;
    dynamic prevPageUrl;
    int to;

    Customers({
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

    factory Customers.fromJson(Map<String, dynamic> json) => Customers(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null ? null : List<Customer>.from(json["data"].map((x) => Customer.fromJson(x))),
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

class Customer {
    String id;
    String name;
    String slug;
    String phoneNumber;
    String email;
    dynamic deletedAt;
    DateTime createdAt;
    DateTime updatedAt;
    String usersId;

    Customer({
        this.id,
        this.name,
        this.slug,
        this.phoneNumber,
        this.email,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.usersId,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        email: json["email"] == null ? null : json["email"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        usersId: json["users_id"] == null ? null : json["users_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "email": email == null ? null : email,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "users_id": usersId == null ? null : usersId,
    };
}
