// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
    int currentPage;
    List<Product> data;
    String firstPageUrl;
    int from;
    String nextPageUrl;
    String path;
    int perPage;
    String prevPageUrl;
    int to;

    Products({
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

    factory Products.fromJson(Map<String, dynamic> json) => Products(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null ? null : List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
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

class Product {
    String id;
    String name;
    String slug;
    int price;
    dynamic deletedAt;
    DateTime createdAt;
    DateTime updatedAt;
    String usersId;
    String time;
    int totalTime;

    Product({
        this.id,
        this.name,
        this.slug,
        this.price,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.usersId,
        this.time,
        this.totalTime,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        price: json["price"] == null ? null : json["price"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        usersId: json["users_id"] == null ? null : json["users_id"],
        time: json["time"] == null ? null : json["time"],
        totalTime: json["total_time"] == null ? null : json["total_time"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "price": price == null ? null : price,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "users_id": usersId == null ? null : usersId,
        "time": time == null ? null : time,
        "total_time": totalTime == null ? null : totalTime,
    };
}
