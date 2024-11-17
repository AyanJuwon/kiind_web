class CategoryModel {
  final int id;
  final String title;
  final String? image;

  CategoryModel({required this.id, required this.title, this.image});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
        id: map['id'], title: map['title'], image: map['image_url']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'image_url': image};
  }
}
