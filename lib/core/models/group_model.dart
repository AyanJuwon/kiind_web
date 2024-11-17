import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';

class Group {
  Group({
    this.id,
    this.title,
    this.userId,
    this.status,
    this.website,
    this.joined,
    this.email,
    this.countryId,
    this.socialNumber,
    this.vat,
    this.address,
    this.phone,
    this.currencyId,
    this.slug,
    this.srNo,
    this.parent,
    this.groupSuper,
    this.subGroupLevel,
    this.categoryId,
    this.primaryColor,
    this.secondaryColor,
    this.ip,
    this.createdAt,
    this.updatedAt,
    this.details,
    this.country,
    this.groupCategory,
    this.currency,
  });

  final int? id;
  final String? title;
  final int? userId;
  final String? status;
  final String? website;
  final String? email;
  final int? countryId;
  bool? joined;
  final String? socialNumber;
  final String? vat;
  final String? address;
  final dynamic phone;
  final int? currencyId;
  final String? slug;
  final dynamic srNo;
  final int? parent;
  final String? groupSuper;
  final int? subGroupLevel;
  final int? categoryId;
  final String? primaryColor;
  final String? secondaryColor;
  final dynamic ip;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic details;
  final Country? country;
  final String? groupCategory;
  final Currency? currency;
  Map<int, Group> subGroups = {};

  Color? get bgColor => primaryColor?.asColorFromHex;
  bool get isSubgroup => "$parent" == groupSuper;

  bool get hasChildren => subGroups.isNotEmpty;

  Group copyWith({
    int? id,
    String? title,
    int? userId,
    String? status,
    String? website,
    bool? joined,
    String? email,
    int? countryId,
    String? socialNumber,
    String? vat,
    String? address,
    dynamic phone,
    int? currencyId,
    String? slug,
    dynamic srNo,
    int? parent,
    String? groupSuper,
    int? subGroupLevel,
    int? categoryId,
    String? primaryColor,
    String? secondaryColor,
    dynamic ip,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic details,
    Country? country,
    String? groupCategory,
    Currency? currency,
  }) =>
      Group(
        id: id ?? this.id,
        title: title ?? this.title,
        userId: userId ?? this.userId,
        status: status ?? this.status,
        website: website ?? this.website,
        email: email ?? this.email,
        joined: joined ?? this.joined,
        countryId: countryId ?? this.countryId,
        socialNumber: socialNumber ?? this.socialNumber,
        vat: vat ?? this.vat,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        currencyId: currencyId ?? this.currencyId,
        slug: slug ?? this.slug,
        srNo: srNo ?? this.srNo,
        parent: parent ?? this.parent,
        groupSuper: groupSuper ?? this.groupSuper,
        subGroupLevel: subGroupLevel ?? this.subGroupLevel,
        categoryId: categoryId ?? this.categoryId,
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        ip: ip ?? this.ip,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        details: details ?? this.details,
        country: country ?? this.country,
        groupCategory: groupCategory ?? this.groupCategory,
        currency: currency ?? this.currency,
      );

  factory Group.fromJson(String str) => Group.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Group.fromMap(Map<String, dynamic> json) => Group(
        id: json["id"],
        title: json["title"],
        userId: json["user_id"],
        status: json["status"],
        website: json["website"],
        email: json["email"],
        joined: json["joined"],
        countryId: json["country_id"],
        socialNumber: json["social_number"],
        vat: json["vat"],
        address: json["address"],
        phone: json["phone"],
        currencyId: json["currency_id"],
        slug: json["slug"],
        srNo: json["sr_no"],
        parent: json["parent"],
        groupSuper: json["super"],
        subGroupLevel: json["sub_group_level"],
        categoryId: json["category_id"],
        primaryColor: json["primary_color"],
        secondaryColor: json["secondary_color"],
        ip: json["ip"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        details: json["details"],
        country: json["country"] == null
            ? null
            : Country.fromMap(Map.from(json["country"])),
        groupCategory: json["group_category"],
        currency: json["currency"] == null
            ? null
            : Currency.fromMap(Map.from(json["currency"])),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "user_id": userId,
        "status": status,
        "website": website,
        "email": email,
        "joined": joined,
        "country_id": countryId,
        "social_number": socialNumber,
        "vat": vat,
        "address": address,
        "phone": phone,
        "currency_id": currencyId,
        "slug": slug,
        "sr_no": srNo,
        "parent": parent,
        "super": groupSuper,
        "sub_group_level": subGroupLevel,
        "category_id": categoryId,
        "primary_color": primaryColor,
        "secondary_color": secondaryColor,
        "ip": ip,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "details": details,
        "country": country?.toMap(),
        "group_category": groupCategory,
        "currency": currency?.toMap(),
      };
}

class Country {
  Country({
    this.id,
    this.title,
    this.code,
    this.flag,
    this.iso,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? code;
  final String? flag;
  final String? iso;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Country copyWith({
    int? id,
    String? title,
    String? code,
    String? flag,
    String? iso,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Country(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        flag: flag ?? this.flag,
        iso: iso ?? this.iso,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Country.fromJson(String str) => Country.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        id: json["id"],
        title: json["title"],
        code: json["code"],
        flag: json["flag"],
        iso: json["ISO"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "code": code,
        "flag": flag,
        "ISO": iso,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Currency {
  Currency({
    this.id,
    this.title,
    this.symbol,
    this.location,
    this.iso,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? symbol;
  final String? location;
  final String? iso;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Currency copyWith({
    int? id,
    String? title,
    String? symbol,
    String? location,
    String? iso,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Currency(
        id: id ?? this.id,
        title: title ?? this.title,
        symbol: symbol ?? this.symbol,
        location: location ?? this.location,
        iso: iso ?? this.iso,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Currency.fromJson(String str) => Currency.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Currency.fromMap(Map<String, dynamic> json) => Currency(
        id: json["id"],
        title: json["title"],
        symbol: json["symbol"],
        location: json["location"],
        iso: json["ISO"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] ?? ''),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] ?? ''),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "symbol": symbol,
        "location": location,
        "ISO": iso,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
