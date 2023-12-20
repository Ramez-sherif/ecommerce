import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:ecommerce/services/product.dart';

class OrdersService {
  static var db = FirebaseFirestore.instance;
  static Future createOrderFromCart(CartModel cart) async {
    Map<ProductModel, int> cartProducts = cart.products;
    String userId = cart.userId;
    String orderId = await createNewOrder(userId, "Ongoing");

    for (var cartProduct in cartProducts.entries) {
      await addOrder(cartProduct.key.id, userId, cartProduct.value, orderId);
      await CartService.removeProductFromCart(cartProduct.key.id, userId);
    }
  }

  static Future<String> createNewOrder(String userId, String status) async {
    DateTime date = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(date);
    DocumentReference doc = db.collection(CollectionConfig.orders).doc();
    await doc.set({
      "date": timestamp,
      "user_id": userId,
      "statusId": await getStatusIdByName(status),
    });
    return doc.id;
  }

  static Future addOrder(
      String productId, String userId, int quantity, String orderId) async {
    await db.collection(CollectionConfig.orderItems).doc().set(
        {"product_id": productId, "quantity": quantity, "order_id": orderId});
    await updateStock(productId, quantity);
  }

  static Future updateStock(String productId, int quantity) async {
    var productDocument =
        await db.collection(CollectionConfig.products).doc(productId).get();

    int newQuantity = productDocument["quantity"] - quantity;

    await ProductService.updateProduct({"quantity": newQuantity}, productId);
    if (newQuantity < 20) {
      //notify admins
    }
  }

  static Future<List<OrdersModel>> getAllOrders(
      String userId, UserModel user) async {
    List<OrdersModel> allOrders = [];
    List<ProductModel> allProducts = await ProductService.getAllProducts();

    await db
        .collection(CollectionConfig.orders)
        .where("user_id", isEqualTo: userId)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        Timestamp time = doc["date"];
        DateTime date = time.toDate();
        var currentOrder = OrdersModel(
            user: user,
            products: await getProductsInOrder(doc.id, allProducts),
            date: date,
            orderId: doc.id,
            status: int.parse(doc["status_id"]));
        allOrders.add(currentOrder);
      }
    });
    print(allOrders.toString());
    return allOrders;
  }

  static Future<Map<ProductModel, int>> getProductsInOrder(
      String orderId, List<ProductModel> allProducts) async {
    Map<ProductModel, int> orderProducts = {};
    await db
        .collection(CollectionConfig.orderItems)
        .where("order_id", isEqualTo: orderId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        orderProducts[allProducts.firstWhere(
          (element) => element.id == doc["product_id"],
        )] = doc["quantity"];
      }
    });
    return orderProducts;
  }

  static Future<String> getStatusIdByName(String status) async {
    var doc = await db
        .collection(CollectionConfig.status)
        .where("name", isEqualTo: status)
        .get();
    return doc.docs[0].id;
  }
}
