import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/services/categories_icons.dart';

class CategoryModel {
  final String id, name, description;
  IconData icon = Icons.error;
  String iconName = "";
  CategoryModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.iconName}) {
    icon = iconsMap[iconName] == null ? Icons.error : iconsMap[iconName]!;
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
  String getKeyFromIconData(IconData value) {
    for (var entry in iconsMap.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return "";
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      
    };
  }

  @override
  String toString() =>
      'CategoryModel(id: $id, name: $name, description: $description,icon_name:$iconName)';
}
