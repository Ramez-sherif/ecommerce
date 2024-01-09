// ignore_for_file: non_constant_identifier_names, avoid_print
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/category.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:ecommerce/services/favorite.dart';
import 'package:ecommerce/services/orders.dart';
import 'package:ecommerce/services/review.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductService {
  static var db = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance;

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
      // print("Successfully fetched products");
      return products_list;
    }).onError((error, stackTrace) {
      print("Error deleting document: $error");
      return products_list;
    });
    return products_list;
  }

  static Future setProduct(ProductModel product, File file) async {
    var documentReference = db.collection(CollectionConfig.products).doc();
    var productId = documentReference.id;

    await documentReference
        .set(product.toMap())
        .then((value) => print("Product Added with ID: $productId"))
        .onError((error, stackTrace) => print("Failed to add product: $error"));

    String imageUrl = await updloadProductImageToStorage(file);
    await updateProductImage(productId, imageUrl);
  }

  static Future updateProduct(Map<String, dynamic> product, String id) async {
    await db
        .collection(CollectionConfig.products)
        .doc(id)
        .set(product, SetOptions(merge: true))
        .then((value) => print("Product Updated"))
        .onError(
            (error, stackTrace) => log("Failed to Update product: $error"));
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

  static Future deleteProductById(String id) async {
    try {
      await db.collection(CollectionConfig.products).doc(id).delete();
      return true;
    } catch (e) {
      log("Product Service: $e");
      return false;
    }
  }

  static Future deleteProductsRelatedToCategoryId(String categoryId) async {
    QuerySnapshot productsQuery = await db
        .collection(CollectionConfig.products)
        .where('category_id', isEqualTo: categoryId)
        .get();

    for (QueryDocumentSnapshot productDoc in productsQuery.docs) {
      // Delete product document
      await deleteProductInAllCollection(productDoc.id);
    }
  }

  static Future deleteProductInAllCollection(String id) async {
    await deleteProductById(id);

    // Delete order items related to this product
    await OrdersService.deleteOrderItemsByProductId(id);

    // Delete reviews related to this product
    await ReviewService.deleteReviewsByProductId(id);

    // Delete favorite items related to this product
    await FavoriteService.deleteFavoriteByProductId(id);

    // Delete cart items related to this product
    await FavoriteService.deleteFavoriteByProductId(id);
  }

  static Future<String> updloadProductImageToStorage(File file) async {
    var reference = storage.ref().child("prdoucts/");
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    log(url);
    return url;
  }

  static Future updateProductImage(String productId, String imageUrl) async {
    await db.collection(CollectionConfig.products).doc(productId).update(
      {"image_URL": imageUrl},
    );
  }

  static Future updateProductAndImage(ProductModel product, File file) async {
    await updateProduct(product.toMap(), product.id);
    String imageUrl = await updloadProductImageToStorage(file);
    await updateProductImage(product.id, imageUrl);
  }

  static Future createProduct(ProductModel product) async {
    try {
      await db
          .collection(CollectionConfig.products)
          .doc(product.id)
          .set(product.toMap());
      return true;
    } catch (e) {
      log("Product Service: $e");
      return false;
    }
  }
}
