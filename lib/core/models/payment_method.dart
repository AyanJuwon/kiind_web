// To parse this JSON data, do
//
//     final paymentMethod = paymentMethodFromMap(jsonString);

import 'dart:convert';

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.title,
    this.type,
    this.userId,
    this.ip,
    this.status,
    this.apiKey,
    this.apiSecret,
    this.other,
    this.txCharges,
    this.chargeType,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? type;
  final int? userId;
  final String? ip;
  final String? status;
  final String? apiKey;
  final String? apiSecret;
  final dynamic other;
  final String? txCharges;
  final String? chargeType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentMethod copyWith({
    int? id,
    String? title,
    String? type,
    int? userId,
    String? ip,
    String? status,
    String? apiKey,
    String? apiSecret,
    dynamic other,
    String? txCharges,
    String? chargeType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PaymentMethod(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        userId: userId ?? this.userId,
        ip: ip ?? this.ip,
        status: status ?? this.status,
        apiKey: apiKey ?? this.apiKey,
        apiSecret: apiSecret ?? this.apiSecret,
        other: other ?? this.other,
        txCharges: txCharges ?? this.txCharges,
        chargeType: chargeType ?? this.chargeType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory PaymentMethod.fromJson(String str) =>
      PaymentMethod.fromMap(json.decode(str));

  String get label => title == 'Stripe' ? 'Card' : title ?? 'N/A';

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromMap(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        userId: json["user_id"],
        ip: json["ip"],
        status: json["status"],
        apiKey: json["api_key"],
        apiSecret: json["api_secret"],
        other: json["other"],
        txCharges: json["tx_charges"],
        chargeType: json["charge_type"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ''),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "type": type,
        "user_id": userId,
        "ip": ip,
        "status": status,
        "api_key": apiKey,
        "api_secret": apiSecret,
        "other": other,
        "tx_charges": txCharges,
        "charge_type": chargeType,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
