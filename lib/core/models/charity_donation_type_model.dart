class CharityDonationType {
  final int id;
  final String title;
  final String description;

  CharityDonationType({
    required this.id,
    required this.title,
    required this.description,
  });

  factory CharityDonationType.fromJson(Map<String, dynamic> json) {
    return CharityDonationType(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  static List<CharityDonationType> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((item) => CharityDonationType.fromJson(item)).toList();
  }
}
