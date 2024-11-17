// To parse this JSON data, do
//
//     final campaignUpdate = campaignUpdateFromMap(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:jiffy/jiffy.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';

class CampaignUpdate {
  CampaignUpdate({
    this.id,
    this.title,
    this.details,
    this.createdAt,
    this.campaignId,
    this.userId,
    this.file,
    this.ip,
    this.status,
    this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? details;
  final DateTime? createdAt;
  final int? campaignId;
  final int? userId;
  final dynamic file;
  final String? ip;
  final int? status;
  final DateTime? updatedAt;

  Jiffy? get createdAtJiffy {
    Jiffy? j;

    try {
      j = createdAt.isNotNullOrEmpty ? Jiffy.parse(createdAt.toString()) : null;
    } catch (e) {
      log(e.toString());
    }

    return j;
  }

  Jiffy? get updatedAtJiffy {
    Jiffy? j;

    try {
      j = updatedAt.isNotNullOrEmpty ? Jiffy.parse(updatedAt.toString()) : null;
    } catch (e) {
      log(e.toString());
    }

    return j;
  }

  CampaignUpdate copyWith({
    int? id,
    String? title,
    String? details,
    DateTime? createdAt,
    int? campaignId,
    int? userId,
    dynamic file,
    String? ip,
    int? status,
    DateTime? updatedAt,
  }) =>
      CampaignUpdate(
        id: id ?? this.id,
        title: title ?? this.title,
        details: details ?? this.details,
        createdAt: createdAt ?? this.createdAt,
        campaignId: campaignId ?? this.campaignId,
        userId: userId ?? this.userId,
        file: file ?? this.file,
        ip: ip ?? this.ip,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory CampaignUpdate.fromJson(String str) =>
      CampaignUpdate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CampaignUpdate.fromMap(Map<String, dynamic> json) => CampaignUpdate(
        id: json["id"],
        title: json["title"],
        details: json["details"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ''),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
        campaignId: json["campaign_id"],
        userId: json["user_id"],
        file: json["file"],
        ip: json["ip"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "details": details,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "campaign_id": campaignId,
        "user_id": userId,
        "file": file,
        "ip": ip,
        "status": status,
      };
}
