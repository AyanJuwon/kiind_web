import 'package:equatable/equatable.dart';

class Charity extends Equatable {
  final int id;
  final String title;
  final String? email;
  final String slug;
  final int categoryId;
  final String categoryTitle;
  final String? details;
  final String? primaryColor;
  final String? secondaryColor;
  final String? image;
  final String? image_url;

  const Charity({
    required this.id,
    required this.title,
    this.email,
    required this.slug,
    required this.categoryId,
    required this.categoryTitle,
    this.details,
    this.primaryColor,
    this.secondaryColor,
    this.image,
    this.image_url,
  });

  factory Charity.fromMap(Map<String, dynamic> map) {
    return Charity(
      id: map['id'],
      title: map['title'],
      email: map['email'],
      slug: map['slug'],
      categoryId: map['category_id'],
      details: map['details'],
      primaryColor: map['primary_color'],
      secondaryColor: map['secondary_color'],
      categoryTitle: map['category_title'],
      image: map['image'],
      image_url: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'email': email,
      'slug': slug,
      'category_id': categoryId,
      'details': details,
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
      'category_title': categoryTitle,
      'image': image,
      'image_url': image_url
    };
  }

  @override
  List<Object?> get props => [id, categoryId];
}
