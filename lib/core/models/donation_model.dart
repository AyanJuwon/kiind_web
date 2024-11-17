// To parse this JSON data, do
//
//     final donation = donationFromMap(jsonString);

import 'dart:convert';

import 'package:kiind_web/core/models/campaign_model.dart';

class Donation {
  Donation({
    this.id,
    this.campaignId,
    this.groupId,
    this.userId,
    this.anonymous,
    this.name,
    this.email,
    this.phone,
    this.country,
    this.amount,
    this.status,
    this.paymentMethod,
    this.txId,
    this.ip,
    this.createdAt,
    this.updatedAt,
    this.campaign,
  });

  final int? id;
  final int? campaignId;
  final String? groupId;
  final int? userId;
  final int? anonymous;
  final String? name;
  final String? email;
  final String? phone;
  final String? country;
  final String? amount;
  final String? status;
  final String? paymentMethod;
  final String? txId;
  final String? ip;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Campaign? campaign;

  Donation copyWith({
    int? id,
    int? campaignId,
    String? groupId,
    int? userId,
    int? anonymous,
    String? name,
    String? email,
    String? phone,
    String? country,
    String? amount,
    String? status,
    String? paymentMethod,
    String? txId,
    String? ip,
    DateTime? createdAt,
    DateTime? updatedAt,
    Campaign? campaign,
  }) =>
      Donation(
        id: id ?? this.id,
        campaignId: campaignId ?? this.campaignId,
        groupId: groupId ?? this.groupId,
        userId: userId ?? this.userId,
        anonymous: anonymous ?? this.anonymous,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        country: country ?? this.country,
        amount: amount ?? this.amount,
        status: status ?? this.status,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        txId: txId ?? this.txId,
        ip: ip ?? this.ip,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        campaign: campaign ?? this.campaign,
      );

  factory Donation.fromJson(String str) => Donation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Donation.fromMap(Map<String, dynamic> json) => Donation(
        id: json["id"],
        campaignId: json["campaign_id"],
        groupId: json["group_id"],
        userId: json["user_id"],
        anonymous: json["anonymous"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        country: json["country"],
        amount: json["amount"],
        status: json["status"],
        paymentMethod: json["payment_method"],
        txId: json["tx_id"],
        ip: json["ip"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ''),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
        campaign: json["campaign"] == null
            ? null
            : Campaign.fromMap(json["campaign"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "campaign_id": campaignId,
        "group_id": groupId,
        "user_id": userId,
        "anonymous": anonymous,
        "name": name,
        "email": email,
        "phone": phone,
        "country": country,
        "amount": amount,
        "status": status,
        "payment_method": paymentMethod,
        "tx_id": txId,
        "ip": ip,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "campaign": campaign?.toMap(),
      };
}
