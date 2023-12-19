// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/category.dart';
import 'package:ecommerce/services/collections_config.dart';

class ProductService {
  static var db = FirebaseFirestore.instance;

  /// Get all products from firestore database
  static Future<List<ProductModel>> getAllProducts() async {
    List<CategoryModel> categories = await CategoryService.getAllCategories();
    List<ProductModel> products_list = [];

    await db
        .collection(CollectionConfig.products)
        .get()
        .then((collection_snapshot) {
      for (var doc in collection_snapshot.docs) {
        products_list.add(ProductModel.fromFirestore(doc, categories));
      }
      print("Successfully fetched products");
      return products_list;
    }).onError((error, stackTrace) {
      print("Error deleting document: $error");
      return products_list;
    });
    return products_list;
  }

  static Future setProduct(ProductModel product) async {
    await db
        .collection(CollectionConfig.products)
        .doc()
        .set(product.toMap())
        .then((value) => print("Product Added"))
        .onError((error, stackTrace) => print("Failed to add product: $error"));
  }

  static Future updateProduct(Map<String,dynamic> product) async {
    await db
        .collection(CollectionConfig.products)
        .doc()
        .update(product)
        .then((value) => print("Product Updated"))
        .onError(
            (error, stackTrace) => print("Failed to Update product: $error"));
  }

  static Future<List<ProductModel>> getProductsByCategory(
      String categoryId) async {
    List<CategoryModel> categories = await CategoryService.getAllCategories();
    List<ProductModel> products = [];
    await db
        .collection(CollectionConfig.products)
        .where("category_id", isEqualTo: categoryId)
        .get()
        .then((value) {
      for (var docSnapShot in value.docs) {
        products.add(ProductModel.fromFirestore(docSnapShot, categories));
      }
    });
    return products;
  }
}
