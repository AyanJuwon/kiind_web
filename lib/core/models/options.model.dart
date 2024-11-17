import 'dart:convert';

import 'package:kiind_web/core/util/extensions/num_extentions.dart';

class Options {
  Options({
    this.id,
    this.userId,
    this.campaignId,
    this.amount1,
    this.amount2,
    this.amount3,
    this.amount4,
    this.customEnabled,
    this.ip,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? userId;
  final int? campaignId;
  final num? amount1;
  final num? amount2;
  final num? amount3;
  final num? amount4;
  final String? customEnabled;
  final String? ip;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  List<num> get values => [
        amount1 ?? 1,
        amount2 ?? 5,
        amount3 ?? 10,
        amount4 ?? 20,
      ];

  String valueAt(
    index, {
    num multiplier = 1,
  }) =>
      (values[index] * multiplier).leanString;

  String faceValueAt(
    index, {
    num multiplier = 1,
  }) =>
      '£${valueAt(index, multiplier: multiplier)}';

  Options copyWith({
    int? id,
    int? userId,
    int? campaignId,
    num? amount1,
    num? amount2,
    num? amount3,
    num? amount4,
    String? customEnabled,
    String? ip,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Options(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        campaignId: campaignId ?? this.campaignId,
        amount1: amount1 ?? this.amount1,
        amount2: amount2 ?? this.amount2,
        amount3: amount3 ?? this.amount3,
        amount4: amount4 ?? this.amount4,
        customEnabled: customEnabled ?? this.customEnabled,
        ip: ip ?? this.ip,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Options.fromJson(String str) => Options.fromMap(json.decode(str));

  factory Options.forWallet() => Options(
        amount1: 20,
        amount2: 50,
        amount3: 100,
        amount4: 250,
      );

  String toJson() => json.encode(toMap());

  factory Options.fromMap(Map<String, dynamic> json) => Options(
        id: json["id"],
        userId: json["user_id"],
        campaignId: json["campaign_id"],
        amount1: json["amount1"],
        amount2: json["amount2"],
        amount3: json["amount3"],
        amount4: json["amount4"],
        customEnabled: json["custom_enabled"],
        ip: json["ip"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ''),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "campaign_id": campaignId,
        "amount1": amount1,
        "amount2": amount2,
        "amount3": amount3,
        "amount4": amount4,
        "custom_enabled": customEnabled,
        "ip": ip,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
