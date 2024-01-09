import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/category.dart';
import 'package:ecommerce/services/product.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  List<CategoryModel> allCategories = [];
  List<ProductModel> allProducts = [];

  Future getAllCategories() async {
    allCategories = await CategoryService.getAllCategories();
    notifyListeners();
  }

  Future createCategory(CategoryModel category) async {
    bool result = await CategoryService.createCategory(category);
    if (result) {
      allCategories.add(category);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future deleteCategoryById(String id) async {
    bool isDeleted = await CategoryService.deleteCategoryById(id);

    if (isDeleted) {
      allCategories.removeWhere((category) => category.id == id);
    }
  }

  Future updateCategory(CategoryModel category) async {
    bool isUpdated = await CategoryService.updateCategory(category);

    if (isUpdated) {
      int index = allCategories.indexWhere((value) => value.id == category.id);
      allCategories[index] = category;
      notifyListeners();
    }
  }

  // Products
  Future getAllProducts() async {
    allProducts = await ProductService.getAllProducts();
    notifyListeners();
  }

  Future deleteProductById(String id) async {
    bool isDeleted = await ProductService.deleteProductById(id);

    if (isDeleted) {
      allProducts.removeWhere((product) => product.id == id);
    }
  }

  Future createProductWithoutImage(ProductModel product) async {
    bool result = await ProductService.createProduct(product);
    if (result) {
      allProducts.add(product);
      notifyListeners();
      return true;
    }
    return false;
  }
}
