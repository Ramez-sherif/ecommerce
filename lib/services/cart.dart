import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart.dart';
String collectionName = "carts";
class CartService {
  static var db = FirebaseFirestore.instance;

  static Future getCartById(CartModel cart) async {
    // await db.collection("asd").doc(p.id).get();
    await db.collection(collectionName).doc(cart.id).get().then(
      (querySnapshot) {
        print("Successfully completed");
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  static Future addCart(CartModel cart) async {
    await db
        .collection(collectionName)
        .doc()
        .set(cart.toMap())
        .then((value) => print("Done"))
        .onError((e, _) => print("Error writing document: $e"));
  }

  static Future testsUpdate(CartModel cart) async {
    await db.collection(collectionName).doc(cart.id).update(cart.toMap());
  }

  static Future testsDelete(CartModel cart) async {
    await db
        .collection(collectionName)
        .doc(cart.id)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        )
        .onError(
            (error, stackTrace) => print("Error deleting document: $error"));
  }
}
