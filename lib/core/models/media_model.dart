import 'dart:convert';
import 'dart:developer';

import 'package:jiffy/jiffy.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';

class MediaFile {
  MediaFile({
    this.id,
    this.title,
    this.type,
    this.typeId,
    this.groupId,
    this.file,
    this.size,
    this.mime,
    this.ext,
    this.ip,
    this.main,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
  });

  final int? id;
  final String? title;
  final String? type;
  final dynamic typeId;
  final int? groupId;
  final String? file;
  final String? size;
  final String? mime;
  final String? ext;
  final String? ip;
  final int? main;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? fileUrl;

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

  MediaFile copyWith({
    int? id,
    String? title,
    String? type,
    dynamic typeId,
    int? groupId,
    String? file,
    String? size,
    String? mime,
    String? ext,
    String? ip,
    int? main,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fileUrl,
  }) =>
      MediaFile(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        typeId: typeId ?? this.typeId,
        groupId: groupId ?? this.groupId,
        file: file ?? this.file,
        size: size ?? this.size,
        mime: mime ?? this.mime,
        ext: ext ?? this.ext,
        ip: ip ?? this.ip,
        main: main ?? this.main,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        fileUrl: fileUrl ?? this.fileUrl,
      );

  factory MediaFile.fromJson(String str) => MediaFile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MediaFile.fromMap(Map<String, dynamic> json) => MediaFile(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        typeId: json["type_id"],
        groupId: json["group_id"],
        file: json["file"],
        size: json["size"],
        mime: json["mime"],
        ext: json["ext"],
        ip: json["ip"],
        main: json["main"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] ?? ''),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] ?? ''),
        fileUrl: json["file_url"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "type": type,
        "type_id": typeId,
        "group_id": groupId,
        "file": file,
        "size": size,
        "mime": mime,
        "ext": ext,
        "ip": ip,
        "main": main,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "file_url": fileUrl,
      };
}
