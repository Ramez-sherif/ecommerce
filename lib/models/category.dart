import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
Map<String, IconData> iconsMap = {
  'watch': Icons.watch,
  'electrical_services': Icons.electrical_services,
  'call_end_outlined': Icons.call_end_outlined,
  'call_made': Icons.call_made,
  'ac_unit':Icons.ac_unit,
  'list':Icons.list
};
class CategoryModel {
  final String id, name, description;
  IconData icon = Icons.error;

 

  CategoryModel(
      {required this.id,
      required this.name,
      required this.description,
      required iconName}) {
    icon = iconsMap[iconName]!;
  }

  factory CategoryModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return CategoryModel(
        id: document.id,
        name: document['name'],
        description: document['description'],
        iconName: document['icon_name']);
  }

  @override
  String toString() =>
      'CategoryModel(id: $id, name: $name, description: $description)';
}
