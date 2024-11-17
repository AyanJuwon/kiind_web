import 'dart:convert';
import 'dart:developer';

import 'package:jiffy/jiffy.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';

class Transaction {
  Transaction(
      {this.id,
      this.type,
      this.action,
      this.amount,
      this.campaign,
      this.createdAt,
      this.updatedAt});

  late final int? id;
  final String? type;
  final String? action;
  final String? amount;

  final String? campaign;
  final String? createdAt;
  final String? updatedAt;

  Jiffy? get createdAtJiffy {
    Jiffy? j;

    try {
      j = createdAt.isNotNullOrEmpty ? Jiffy.parse(createdAt!) : null;
    } catch (e) {
      log(e.toString());
    }

    return j;
  }

  Jiffy? get updatedAtJiffy {
    Jiffy? j;

    try {
      j = updatedAt.isNotNullOrEmpty ? Jiffy.parse(updatedAt!) : null;
    } catch (e) {
      log(e.toString());
    }

    return j;
  }

  Transaction copyWith({
    int? id,
    String? type,
    String? action,
    String? amount,
    String? campaign,
    String? createdAt,
    String? updatedAt,
  }) =>
      Transaction(
        id: id ?? this.id,
        type: type ?? this.type,
        action: action ?? this.action,
        amount: amount ?? this.amount,
        campaign: campaign ?? this.campaign,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Transaction.fromJson(String str) =>
      Transaction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
        id: json["id"] is int ? json["id"] : int.tryParse('${json["id"]}'),
        campaign: json["campaign"],
        action: json["action"],
        type: json["type"],
        amount: json["amount"].toString(),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "action": action,
        "campaign": campaign,
        "amount": amount,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
