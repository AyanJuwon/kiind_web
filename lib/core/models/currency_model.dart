import 'dart:convert';

class Currency {
  Currency({
    this.id,
    this.title,
    this.symbol,
    this.location,
    this.iso,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? title;
  final String? symbol;
  final String? location;
  final String? iso;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Currency copyWith({
    int? id,
    String? title,
    String? symbol,
    String? location,
    String? iso,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Currency(
        id: id ?? this.id,
        title: title ?? this.title,
        symbol: symbol ?? this.symbol,
        location: location ?? this.location,
        iso: iso ?? this.iso,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Currency.fromJson(String str) => Currency.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Currency.fromMap(Map<String, dynamic> json) => Currency(
        id: json["id"],
        title: json["title"],
        symbol: json["symbol"],
        location: json["location"],
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
        "symbol": symbol,
        "location": location,
        "ISO": iso,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
