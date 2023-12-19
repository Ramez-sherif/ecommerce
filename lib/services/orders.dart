import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/orders.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:ecommerce/services/product.dart';

class OrdersService {
  static var db = FirebaseFirestore.instance;
  static Future createOrderFromCart(CartModel cart) async {
    Map<ProductModel, int> cartProducts = cart.products;
    String userId = cart.userId;
    String orderId = await createNewOrder(userId);

    for (var cartProduct in cartProducts.entries) {
      await addOrder(cartProduct.key.id, userId, cartProduct.value,orderId);
      await CartService.removeProductFromCart(cartProduct.key.id, userId);
    }
    
  }
  static Future<String> createNewOrder(String userId) async{
    DateTime date = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(date);
    DocumentReference doc = db.collection(CollectionConfig.orders).doc();
    await doc.set({
      "date": timestamp,
      "user_id": userId,
    });
    return doc.id;
  }
  static Future addOrder(String productId, String userId, int quantity,String orderId) async {
    await db.collection(CollectionConfig.orderItems).doc().set({
      "product_id": productId,
      "quantity": quantity,
      "status": 1,
      "order_id": orderId
    });
   await updateStock( productId, quantity);
  }
  static Future updateStock(String productId,int quantity) async{
    var productDocument =
        await db.collection(CollectionConfig.products).doc(productId).get();
    int newQuantity = productDocument["quantity"] - quantity;
    await ProductService.updateProduct({"quantity": newQuantity});
    if (newQuantity < 20) {
      //notify admins
    }
  }
}


