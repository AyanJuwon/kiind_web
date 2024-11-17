// To parse this JSON data, do
//
//     final Categories = CategoriesFromMap(jsonString);

import 'dart:convert';

import 'package:kiind_web/core/models/sub_categories_model.dart';

class Categories {
  Categories(
      {required this.id,
      required this.title,
      this.color,
      this.image,
      this.selected,
      this.children});

  final int id;
  final String title;
  final String? color;
  final String? image;
  final List<SubCategories>? children;

  bool? selected;

  Categories copyWith(
          {int? id,
          required String title,
          String? color,
          String? image,
          bool? selected,
          List<SubCategories>? children}) =>
      Categories(
          id: id ?? this.id,
          title: title,
          color: color ?? this.color,
          image: image ?? this.image,
          selected: selected ?? this.selected,
          children: children ?? this.children);

  factory Categories.fromJson(String str) =>
      Categories.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Categories.fromMap(Map<String, dynamic> json) => Categories(
      id: json["id"],
      title: json["title"],
      color: json["color"],
      image: json["image_url"],
      selected: json["selected"],
      children: ((json["children"] ?? []) as List<dynamic>)
          .map((e) => SubCategories.fromMap(e))
          .toList());

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "color": color,
        "image": image,
        "selected": selected,
        "children": children
      };
}
