import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/collections_config.dart';

class FavoriteService {
  static var db = FirebaseFirestore.instance;
  Future<void> addToFavorites(String userId, ProductModel product) async {
    await db
        .collection("user_favorites")
        .doc()
        .set({"user_ID": userId, "product_Id": product.id})
        .then((value) => print("Done"))
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<void> removeProductFromFavorite(
      ProductModel product, String userId) async {
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

  Future<List<ProductModel>> getFavorites(
      String userId, List<ProductModel> allProducts) async {
    List<ProductModel> favorite = List.empty();
    var querySnapshot = await db
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
    catchError:
    (e) {
      print("Error getting documents: $e");
    };
    print(favorite);
    return favorite;
  }
}
