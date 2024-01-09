import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id, name, description;
  final int iconCode;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconCode,
  });

  // ignore: empty_constructor_bodies
  factory CategoryModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return CategoryModel(
      id: document.id,
      name: document['name'],
      description: document['description'],
      iconCode: document['icon_code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'icon_code': iconCode,
    };
  }

  @override
  String toString() =>
      'CategoryModel(id: $id, name: $name, description: $description, icon_code:$iconCode)';
}
