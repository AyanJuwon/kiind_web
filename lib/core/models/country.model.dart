import 'dart:convert';

class Country {
  Country({
    this.id,
    this.title,
    this.code,
    this.flag,
    this.iso,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? code;
  final String? flag;
  final String? iso;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Country copyWith({
    int? id,
    String? title,
    String? code,
    String? flag,
    String? iso,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Country(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        flag: flag ?? this.flag,
        iso: iso ?? this.iso,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Country.fromJson(String str) => Country.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        id: json["id"],
        title: json["title"],
        code: json["code"],
        flag: json["flag"],
        iso: json["ISO"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] ?? ''),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] ?? ''),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "code": code,
        "flag": flag,
        "ISO": iso,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
