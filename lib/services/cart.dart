import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:ecommerce/services/product.dart';

class CartService {
  static var db = FirebaseFirestore.instance;

  static double getTotalPrice(CartModel model) {
    double totalPrice = 0.0;
    for (var entry in model.products.entries) {
      totalPrice = totalPrice + (entry.key.price * entry.value);
    }
    return totalPrice;
  }

  //working well
  //should return cartModel with
  static Future updateProductQuantity(
      String productId, String userId, int newQuantity) async {
    var querySnapshot = await db
        .collection(CollectionConfig.cartItems)
        .where("product_id",
            isEqualTo: productId) //check for the product in cart_items
        .where("user_id",
            isEqualTo: userId) //check for the user id in cart_items
        .limit(1) //get only the first occurance
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var firstDocument = querySnapshot.docs.first;
      var documentRefrence = firstDocument.reference; //refrence the document

      await documentRefrence.update({
        "quantity": newQuantity
      }); //update the quantity of the product to the new quantity
    } else {
      print("Product or cart Not Found");
    }
  }

  static Future updateCart(CartModel model) async {
    for (var cart_item in model.products.entries) {
      await updateProductQuantity(
          cart_item.key.id, model.userId, cart_item.value);
    }
    
  }

  //working good
  static Future addProductToCart(
      String productId, String userId, int quantity) async {
    //get User By Id
    //User user = User(id: userId);
    await db
        .collection(CollectionConfig.cartItems)
        .doc()
        .set({'user_id': userId, 'product_id': productId, 'quantity': quantity})
        .then((value) => print("Done"))
        .onError((e, _) => print("Error writing document: $e"));
  }

  static Future removeProductFromCart(
      ProductModel product, String userId) async {
    var querySnapshot = await db
        .collection(CollectionConfig.cartItems)
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

  //working good
  static Future<CartModel> getCart(String userId) async {
    //get User By Id
    //User user = User(id: userId);
    List<ProductModel> allProducts = await ProductService.getAllProducts();
    final Map<ProductModel, int> products = {};

    await db
        .collection(CollectionConfig.cartItems)
        .where("user_id", isEqualTo: userId)
        .get()
        .then((querySnapShot) {
      for (var docSnapShot in querySnapShot.docs) {
        products[allProducts.firstWhere(
                (element) => element.id == docSnapShot["product_id"])] =
            docSnapShot["quantity"];
      }
    }).onError((error, stackTrace) {
      print("Error getting document: $error");
    });
    print(products.toString());
    //return cartModel with products and user id in it
    //update it after merging with user class model
    CartModel cartModel = CartModel(userId: userId, products: products);

    return cartModel;
  }

  static Future deleteCart(CartModel cart) async {
    for (var product in cart.products.entries) {
      var querySnapshot = await db
          .collection(CollectionConfig.cartItems)
          .where("product_id", isEqualTo: product.key.id)
          .where("user_id", isEqualTo: cart.userId)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var firstDocument = querySnapshot.docs.first;
        var documentRefrence = firstDocument.reference; //refrence the document

        await documentRefrence
            .delete(); //update the quantity of the product to the new quantity
      } else {
        print(
            "Unknown exeption: Couldn't delete cart, cart or item couldnt be found");
      }
    }
  }
}
