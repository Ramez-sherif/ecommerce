// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:ecommerce/services/product.dart';

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
      log("Error getAllCategories in Category Service document: $error");
      return categories;
    });
    return categories;
  }

  // create a new category
  static Future<bool> createCategory(CategoryModel category) async {
    try {
      await db
          .collection(CollectionConfig.categories)
          .doc()
          .set(category.toMap());
      return true;
    } catch (e) {
      log("Category Service: $e");
      return false;
    }
  }

  static CategoryModel getMostSoldCategory(List<ProductModel> allproducts){
    Map<CategoryModel,int> categoriesSoldStock = {};
    for(var item in allproducts){
      if(categoriesSoldStock.containsKey(item.category)){
        categoriesSoldStock[item.category] = (categoriesSoldStock[item.category]! + item.soldProducts);
      }else{
        categoriesSoldStock[item.category] = item.soldProducts;
      }
      
    }
     // Convert the map entries into a list
    List<MapEntry<CategoryModel, int>> sortedEntries = categoriesSoldStock.entries.toList();

    // Sort the list by values in descending order
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries[0].key;
  }

  // delete a category by id
  static Future<bool> deleteCategoryById(String id) async {
    try {
      // Step 1: Delete category
      await _deleteCategory(id);
      // Step 2: Delete all products in this category
      await ProductService.deleteProductsRelatedToCategoryId(id);
      return true;
    } catch (e) {
      log("Category Service delete category: $e");
      return false;
    }
  }

  static Future<void> _deleteCategory(String id) async {
    await db.collection(CollectionConfig.categories).doc(id).delete();
  }

  static Future<bool> updateCategory(CategoryModel category) async {
    try {
      await db
          .collection(CollectionConfig.categories)
          .doc(category.id)
          .update(category.toMap());
      print("Category updated");
      return true;
    } catch (e) {
      log("Category Service: $e");
      return false;
    }

  }
}
