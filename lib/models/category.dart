import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id, name, description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return CategoryModel(
      id: document.id,
      name: document['name'],
      description: document['description'],
    );
  }

  @override
  String toString() =>
      'CategoryModel(id: $id, name: $name, description: $description)';
}
