// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/services/collections_config.dart';

class CategoryService {
  static var db = FirebaseFirestore.instance;

  /// get all categories from firestore database
  static Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> categories = [];

    await db
        .collection(CollectionConfig.categories)
        .get()
        .then((collection_snapshot) {
      for (var doc in collection_snapshot.docs) {
        categories.add(CategoryModel.fromFirestore(doc));
      }
      return categories;
    }).onError((error, stackTrace) {
      print("Error getting document: $error");
      return categories;
    });
    return categories;
  }
}
