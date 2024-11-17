// // To parse this JSON data, do
// //
// //     final notification = notificationFromMap(jsonString);
//
import 'dart:convert';
import 'dart:developer';

import 'package:jiffy/jiffy.dart';

class Notification {
  Notification({
    this.uuid,
    this.id,
    this.title,
    this.createdAt,
    this.postCategoryId,
    // this.type,
  });
  final String? uuid;
  late final int? id;
  final String? title;
  // final String? type;
  final String? createdAt;
  final String? postCategoryId;

  Jiffy? get createdAtJiffy {
    Jiffy? j;

    try {
      j = createdAt != null ? Jiffy.parse(createdAt!) : null;
    } catch (e) {
      log(e.toString());
    }

    return j;
  }

  Notification copyWith({
    String? uuid,
    int? id,
    String? title,
    String? postCategoryId,
    // String? type,
    String? createdAt,
  }) =>
      Notification(
          uuid: uuid ?? this.uuid,
          id: id ?? this.id,
          title: title ?? this.title,
          postCategoryId: postCategoryId ?? this.postCategoryId,
          // type: type ?? this.type,
          createdAt: createdAt);

  factory Notification.fromJson(String str) =>
      Notification.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Notification.fromMap(Map<String, dynamic> json) => Notification(
      uuid: json["id"],
      id: json["data"]["id"],
      title: json["data"]["title"],
      createdAt: json["data"]['created_at'],
      postCategoryId: json["data"]["post_category_id"]);

  factory Notification.fromPushMap(Map<String, dynamic> json) => Notification(
      uuid: '${json["id"]}',
      id: int.tryParse('${json["id"]}'),
      title: json["title"],
      createdAt: json['created_at'],
      postCategoryId: json["post_category_id"]);
  // type: json["type"]
  // createdAt: json;["created_at"]);

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "id": id,
        "title": title,
        "post_category_id": getCategoryId(),
        // "type": type,
        "created_at": createdAt,
        "__meta_requires_fetch": true,
      };

  int? getCategoryId() {
    int? id;

    switch (postCategoryId) {
      case "News":
        id = 1;
        break;
      case "Podcast":
        id = 2;
        break;
      case "Video":
        id = 3;
        break;
      case "Live":
        id = 4;
        break;
      default:
    }

    return id;
  }
}
