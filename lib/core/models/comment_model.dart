// To parse this JSON data, do
//
//     final comment = commentFromMap(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:jiffy/jiffy.dart';
import 'package:kiind_web/core/models/user_model.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';

class Comment extends Comparable {
  Comment({
    this.id,
    this.postId,
    this.userId,
    this.parentId,
    this.groupId,
    this.body,
    this.ip,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  final int? id;
  final int? postId;
  final int? userId;
  final int? parentId;
  final int? groupId;
  final String? body;
  final String? ip;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  Jiffy? get createdAtJiffy {
    Jiffy? j;

    try {
      j = createdAt!.isNotNullOrEmpty ? Jiffy.parse(createdAt as String) : null;
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

  Comment copyWith({
    int? id,
    int? postId,
    int? userId,
    int? parentId,
    int? groupId,
    String? body,
    String? ip,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) =>
      Comment(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
        parentId: parentId ?? this.parentId,
        groupId: groupId ?? this.groupId,
        body: body ?? this.body,
        ip: ip ?? this.ip,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );

  factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        id: json["id"],
        postId: json["post_id"],
        userId: json["user_id"],
        parentId: json["parent_id"],
        groupId: json["group_id"],
        body: json["body"],
        ip: json["ip"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] ?? ''),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] ?? ''),
        user: json["user"] == null ? null : User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "post_id": postId,
        "user_id": userId,
        "parent_id": parentId,
        "group_id": groupId,
        "body": body,
        "ip": ip,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toMap(),
      };

  @override
  int compareTo(other) => (updatedAt ?? DateTime.now())
      .compareTo(other.updatedAt ?? DateTime.now());
}
