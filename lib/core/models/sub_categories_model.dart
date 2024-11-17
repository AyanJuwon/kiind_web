// To parse this JSON data, do
//
//     final SubCategories = SubCategoriesFromMap(jsonString);

import 'dart:convert';

class SubCategories {
  SubCategories({this.id, required this.title, this.selected});

  final int? id;
  final String title;
  bool? selected;

  SubCategories copyWith({int? id, String? title, bool? selected}) =>
      SubCategories(
          id: id ?? this.id,
          title: title ?? this.title,
          selected: selected ?? this.selected);

  factory SubCategories.fromJson(String str) =>
      SubCategories.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubCategories.fromMap(Map<String, dynamic> json) => SubCategories(
      id: json["id"], title: json["title"], selected: json["selected"]);

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "selected": selected};
}
