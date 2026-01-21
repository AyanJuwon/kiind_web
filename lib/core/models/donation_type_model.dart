class DonationType {
  final int id;
  final String title;
  final String? description;

  DonationType({
    required this.id,
    required this.title,
    this.description,
  });

  factory DonationType.fromMap(Map<String, dynamic> map) {
    return DonationType(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}

class DonationTypeResponse {
  final List<DonationType> donationTypes;

  DonationTypeResponse({
    required this.donationTypes,
  });

  factory DonationTypeResponse.fromMap(Map<String, dynamic> map) {
    final typesList = map['data'] as List<dynamic>?;
    
    return DonationTypeResponse(
      donationTypes: typesList != null
          ? typesList.map((type) => DonationType.fromMap(type)).toList()
          : [],
    );
  }
}