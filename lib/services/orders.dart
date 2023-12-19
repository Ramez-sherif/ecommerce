import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:ecommerce/services/product.dart';

class OrdersService {
  static var db = FirebaseFirestore.instance;
  static Future createOrderFromCart(CartModel cart) async {
    Map<ProductModel, int> cartProducts = cart.products;
    String userId = cart.userId;
    for (var cartProduct in cartProducts.entries) {
      await addOrder(cartProduct.key.id, userId, cartProduct.value);
      await CartService.removeProductFromCart(cartProduct.key.id, userId);
    }
    
  }

  static Future addOrder(String productId, String userId, int quantity) async {
    await db.collection(CollectionConfig.orderItems).doc().set({
      "user_id": userId,
      "product_id": productId,
      "quantity": quantity,
      "status": 1
    });
    var productDocument =
        await db.collection(CollectionConfig.products).doc(productId).get();
    int newQuantity = productDocument["quantity"] - quantity;
    ProductService.updateProduct({"quantity": newQuantity});
    if (newQuantity < 20) {
      //notify admins
    }
  }
}


