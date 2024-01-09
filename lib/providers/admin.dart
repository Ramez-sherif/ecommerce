import 'dart:developer';

import 'package:ecommerce/models/admin_orders.dart';
import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/status.dart';
import 'package:ecommerce/services/category.dart';
import 'package:ecommerce/services/orders.dart';
import 'package:ecommerce/services/product.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  List<CategoryModel> allCategories = [];
  List<ProductModel> allProducts = [];

  List<AdminOrders> allOrders = [];

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

  //
  Future getAllOrders() async {
    try {
      List<OrdersModel> orders = await OrdersService.getAllOrdersForAdmin();
      List<StatusModel> allStatus = await OrdersService.getAllStatus();

      for (var order in orders) {
        double totalPrice = 0;

        for (var product in order.products.keys) {
          totalPrice += product.price * order.products[product]!;
        }
        allOrders.add(
          AdminOrders(
            order: order,
            status:
                allStatus.firstWhere((element) => element.id == order.status),
            totalPrice: totalPrice,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      log("Error in admin provider getAllOrders: $e");
    }
  }
}
