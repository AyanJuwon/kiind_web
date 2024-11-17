// // To parse this JSON data, do
// //
// //     final Search = SearchFromMap(jsonString);
//
import 'dart:convert';
import 'dart:developer';

import 'package:jiffy/jiffy.dart';

class Search {
  Search({
    this.id,
    this.title,
    this.createdAt,
    this.postCategoryId,
    // this.type,
  });
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

  Search copyWith({
    int? id,
    String? title,
    String? postCategoryId,
    // String? type,
    String? createdAt,
  }) =>
      Search(
          id: id ?? this.id,
          title: title ?? this.title,
          postCategoryId: postCategoryId ?? this.postCategoryId,
          // type: type ?? this.type,
          createdAt: createdAt);

  factory Search.fromJson(String str) => Search.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Search.fromMap(Map<String, dynamic> json) => Search(
      id: json["id"],
      title: json["title"],
      createdAt: json['created_at'],
      postCategoryId: json["post_category_id"]);
  // type: json["type"]
  // createdAt: json;["created_at"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "post_category_id": postCategoryId,
        // "type": type,
        "created_at": createdAt
      };
}
