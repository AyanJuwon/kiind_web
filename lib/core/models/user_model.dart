import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kiind_web/core/constants/env_keys.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';

class User extends ChangeNotifier {
  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.emailVerifiedAt,
      this.username,
      this.avatar,
      this.realBalance,
      this.wallet,
      this.address,
      this.country,
      this.currencyId,
      this.githubId,
      this.googleId,
      this.facebookId,
      this.ip,
      this.status,
      this.defaultGroupId,
      this.groupId,
      this.createdAt,
      this.updatedAt,
      this.groupJoined,
      this.avatarUrl,
      String? password,
      String? passwordConfirmation,
      this.hasPortfolio,
      this.categorySelected}) {
    _password = password;
    _passwordConfirmation = passwordConfirmation;
  }

  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final DateTime? emailVerifiedAt;
  final String? username;
  final String? avatar;
  final String? address;
  final int? country;
  final int? currencyId;
  final String? githubId;
  final String? googleId;
  final String? facebookId;
  final String? ip;
  final String? status;
  final String? defaultGroupId;
  final int? groupId;
  final num? realBalance;
  final Wallet? wallet;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? groupJoined;
  final String? avatarUrl;
  bool? hasPortfolio;
  bool? categorySelected;

  String? _password, _passwordConfirmation;
  bool get hasJoinedGroup => groupJoined.isNotNullOrEmpty;

  String get safeAvatar =>
      avatarUrl.isNullOrEmpty ? kDefaultAvatar.env : avatarUrl!;

  bool get isVerified => emailVerifiedAt.isNotNullOrEmpty;

  Jiffy? get createdAtJiffy {
    Jiffy? j;

    try {
      j = createdAt.isNotNullOrEmpty ? Jiffy.parse(createdAt as String) : null;
    } catch (e) {
      log(e.toString());
    }

    return j;
  }

  Jiffy? get updatedAtJiffy {
    Jiffy? j;

    try {
      j = updatedAt.isNotNullOrEmpty ? Jiffy.parse(updatedAt as String) : null;
    } catch (e) {
      log(e.toString());
    }

    return j;
  }

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      emailVerifiedAt: DateTime.tryParse(json["email_verified_at"] ?? ''),
      username: json["username"],
      avatar: json["avatar"],
      address: json["address"],
      country: json["country"],
      currencyId: json["currency_id"],
      realBalance: json["real_balance"],
      wallet: json["wallet"] == null
          ? null
          : Wallet.fromMap(
              Map<String, dynamic>.from(json["wallet"]),
            ),
      githubId: json["github_id"],
      googleId: json["google_id"],
      facebookId: json["facebook_id"],
      ip: json["ip"],
      status: json["status"],
      defaultGroupId: json["default_group_id"],
      groupId: json["group_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ''),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
      groupJoined: json["group_joined"],
      avatarUrl: json["avatar_url"],
      hasPortfolio: json['portfolio'] ?? false,
      categorySelected: json['category_selected'] ?? false);

  User copyWith(
          {int? id,
          String? name,
          String? email,
          String? phone,
          DateTime? emailVerifiedAt,
          String? username,
          String? avatar,
          String? address,
          int? country,
          int? currencyId,
          String? githubId,
          num? realBalance,
          Wallet? wallet,
          String? googleId,
          String? facebookId,
          String? ip,
          String? status,
          String? defaultGroupId,
          int? groupId,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? groupJoined,
          String? avatarUrl,
          bool? hasPortfolio,
          bool? categorySelected}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        username: username ?? this.username,
        avatar: avatar ?? this.avatar,
        address: address ?? this.address,
        country: country ?? this.country,
        currencyId: currencyId ?? this.currencyId,
        realBalance: realBalance ?? this.realBalance,
        wallet: wallet ?? this.wallet,
        githubId: githubId ?? this.githubId,
        googleId: googleId ?? this.googleId,
        facebookId: facebookId ?? this.facebookId,
        ip: ip ?? this.ip,
        status: status ?? this.status,
        defaultGroupId: defaultGroupId ?? this.defaultGroupId,
        groupId: groupId ?? this.groupId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        groupJoined: groupJoined ?? this.groupJoined,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        hasPortfolio: hasPortfolio ?? this.hasPortfolio,
        categorySelected: categorySelected ?? this.categorySelected,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "username": username,
        "avatar": avatar,
        "address": address,
        "country": country,
        "currency_id": currencyId,
        "real_balance": realBalance,
        "wallet": wallet?.toMap(),
        "github_id": githubId,
        "google_id": googleId,
        "facebook_id": facebookId,
        "ip": ip,
        "status": status,
        "default_group_id": defaultGroupId,
        "group_id": groupId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "group_joined": groupJoined,
        "avatar_url": avatarUrl,
        'portfolio': hasPortfolio,
        'category_selected': categorySelected
      };

  Map<String, dynamic> toRegistrationMap() => {
        "name": name,
        "email": email,
        "username": username,
        "password": _password,
        "password_confirmation": _passwordConfirmation,
      };

  Map<String, dynamic> toUpdateMap() => {
        "name": name,
        "phone": phone,
        "username": username,
        "country": country,
        "address": address,
      };

  Map<String, dynamic> toLoginMap() => {
        // "username": username,
        "email": email,
        "password": _password,
      };

  Map<String, dynamic> toGoogleLoginMap() => {
        // "username": username,
        "email": email,
        "googleAuthCode": googleId,
      };

  Map<String, dynamic> toFacebookLoginMap() => {
        // "username": username,
        "email": email,
        "access_token": facebookId,
      };

  Map<String, dynamic> toAppleLoginMap() => {
        // "username": username,
        "email": email,
        "googleAuthCode": googleId,
      };
}

class Wallet {
  Wallet({
    this.id,
    this.holderType,
    this.holderId,
    this.name,
    this.slug,
    this.description,
    this.meta,
    this.balance,
    this.decimalPlaces,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? holderType;
  final int? holderId;
  final String? name;
  final String? slug;
  final dynamic description;
  final List<dynamic>? meta;
  final String? balance;
  final int? decimalPlaces;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  double get realBalance => ((num.tryParse(balance ?? '0') ?? 0) / 100);

  Wallet copyWith({
    int? id,
    String? holderType,
    int? holderId,
    String? name,
    String? slug,
    dynamic description,
    List<dynamic>? meta,
    String? balance,
    int? decimalPlaces,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Wallet(
        id: id ?? this.id,
        holderType: holderType ?? this.holderType,
        holderId: holderId ?? this.holderId,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        description: description ?? this.description,
        meta: meta ?? this.meta,
        balance: balance ?? this.balance,
        decimalPlaces: decimalPlaces ?? this.decimalPlaces,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Wallet.fromJson(String str) => Wallet.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Wallet.fromMap(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        holderType: json["holder_type"],
        holderId: json["holder_id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        meta: json["meta"] != null
            ? (json["meta"] is List
                ? List<dynamic>.from(json["meta"])
                : [json["meta"]]) // Wrap in a list if it's not already one
            : [],
        balance: json["balance"],
        decimalPlaces: json["decimal_places"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ''),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "holder_type": holderType,
        "holder_id": holderId,
        "name": name,
        "slug": slug,
        "description": description,
        "meta": List<dynamic>.from((meta ?? []).map((x) => x)),
        "balance": balance,
        "decimal_places": decimalPlaces,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
