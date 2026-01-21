class CharityDonationType {
  final int id;
  final String name;
  final String description;

  CharityDonationType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CharityDonationType.fromJson(Map<String, dynamic> json) {
    return CharityDonationType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  static List<CharityDonationType> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((item) => CharityDonationType.fromJson(item)).toList();
  }
}