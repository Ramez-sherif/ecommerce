// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce/models/category.dart';

class ProductModel {
  final String id, name, description, image_URL;
  final double price;
  final int quantity;
  final CategoryModel category;
  final int soldProducts;
  double rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image_URL,
    required this.price,
    required this.rating,
    required this.quantity,
    required this.category,
    required this.soldProducts

  });

  /// Converts a document comes from Firestore databse as [QueryDocumentSnapshot] to a [ProductModel] instance
  factory ProductModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
    List<CategoryModel> categories,
  ) {
    String product_category_id = document['category_id'];

    CategoryModel product_category = categories.firstWhere(
      (element) => element.id == product_category_id,
      orElse: () => CategoryModel(
          id: '', name: 'Unknown Category', description: '', iconCode: 0),
    );

    return ProductModel(
      id: document.id,
      name: document['name'],
      description: document['description'],
      image_URL: document['image_URL'],
      price: document['price'],
      rating: document['rating'],
      quantity: document['quantity'],
      category: product_category,
      soldProducts: document['sold'],

    );
  }

  @override
  String toString() {
    return 'ProductModel(image_URL: $image_URL, rating: $rating, quantity: $quantity, category: ${category.toString()})';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'image_URL': image_URL,
      'rating': rating,
      'quantity': quantity,
      'category_id': category.id,
      'price': price,
      'sold': soldProducts,

    };
  }
}
