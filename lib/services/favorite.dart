// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:ecommerce/sqldb.dart';

class FavoriteService {
  static var db = FirebaseFirestore.instance;
  SqlDb sqlDb = SqlDb();

  static Future<void> addToFavorites(
      String userId, ProductModel product) async {
       
    await db
        .collection(CollectionConfig.userFavorite)
        .where("user_id", isEqualTo: userId)
        .where("product_id", isEqualTo: product.id)
        .limit(1)
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty) {
           print("adding product to favs");
          db
              .collection(CollectionConfig.userFavorite)
              .doc()
              .set({"user_id": userId, "product_id": product.id})
              .then((value) => print("Done adding to favorites"))
              .onError((e, _) => print("Error writing document: $e"));
        } else {
          print("Product already in favorites");
        }
      },
    );
  }

  Future<void> insertToLocalFavorites(String userId, String productId) async {
    List<Map> exists = await sqlDb.readData(
        "Select * from favorites Where userId = '${userId}' AND productId = '${productId}' LIMIT 1");
    if (exists.isEmpty) {
      int response = await sqlDb.insertData(
          'INSERT INTO favorites (userId, productId) VALUES("${userId}", "${productId}")');
      print(response);
      print("addddddddddddddddddddddddddddeddddddddddddddddddd");
    } else {
      print("Already Exists");
    }
  }

  Future<void> deleteFromLocalFavorites(String userId, String productId) async {
    List<Map> exists = await sqlDb.readData(
        "Select * from favorites Where userId = '${userId}' AND productId = '${productId}' LIMIT 1");
    if (exists.isNotEmpty) {
      print("fav Delelted");
      int response = await sqlDb.deleteData(
          "DELETE FROM favorites WHERE userId = '$userId' AND productId = '$productId' ");
      print(response);
    } else {
      print("Row Doesnt Exist");
    }
  }

  static Future<void> removeProductFromFavorite(
    ProductModel product,
    String userId,
  ) async {
    var querySnapshot = await db
        .collection("user_favorites")
        .where("user_id", isEqualTo: userId)
        .where("product_id", isEqualTo: product.id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var firstDocument = querySnapshot.docs.first;
      var documentRefrence = firstDocument.reference; //refrence the document

      await documentRefrence
          .delete(); //update the quantity of the product to the new quantity
    } else {
      print("Error: Product couldn't be deleted");
    }
  }

  static Future<List<ProductModel>> getFavorites(
    String userId,
    List<ProductModel> allProducts,
  ) async {
    List<ProductModel> favorite = [];

    await db
        .collection(CollectionConfig.userFavorite)
        .where("user_id", isEqualTo: userId)
        .get()
        .then(
      (value) {
        for (var doc in value.docs) {
          var product = allProducts
              .firstWhere((element) => element.id == doc.data()["product_id"]);
          favorite.add(product);
        }
      },
    );
    return favorite;
  }

  static Future deleteFavoriteByProductId(String id) async {
    await db
        .collection(CollectionConfig.userFavorite)
        .where("product_id", isEqualTo: id)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
  }
}
