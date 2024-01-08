import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/services/category.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  List<CategoryModel> allCategories = [];

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
}
