// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/status.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:ecommerce/services/fcm.dart';
import 'package:ecommerce/services/product.dart';
import 'package:ecommerce/services/user.dart';

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
      "status_id": await getStatusIdByName(status),
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
    int newSoldProducts = productDocument["sold"] + quantity;
    String productName = productDocument["name"];

    await ProductService.updateProduct(
        {"quantity": newQuantity, "sold": newSoldProducts}, productId);

    log("new quantity $newQuantity");
    log("new sold items $newSoldProducts");
    // send notification to admin if quantity is less than 20
    if (newQuantity < 20) {
      List<String> tokens = await FCMService.getAdminFCMTokens();
      log("admin tokens ${tokens.length}");
      for (var token in tokens) {
        await FCMService.sendNotification(
          token,
          "Low Stock",
          "Product $productName is low on stock",
        );
      }
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
            status: doc["status_id"]);
        allOrders.add(currentOrder);
      }
    });
    // print(allOrders.toString());
    return allOrders;
  }

  static Future<List<OrdersModel>> getAllOrdersForAdmin() async {
    try {
      List<OrdersModel> allOrders = [];
      List<UserModel> allUsers = await UserService.getAllUsers();
      List<ProductModel> allProducts = await ProductService.getAllProducts();

      await db.collection(CollectionConfig.orders).get().then((value) async {
        for (var doc in value.docs) {
          Timestamp time = doc["date"];
          DateTime date = time.toDate();
          var currentOrder = OrdersModel(
            user:
                allUsers.firstWhere((element) => element.uid == doc["user_id"]),
            products: await getProductsInOrder(doc.id, allProducts),
            date: date,
            orderId: doc.id,
            status: doc["status_id"],
          );
          allOrders.add(currentOrder);
        }
      });
      return allOrders;
    } catch (e) {
      log("Error getAllOrdersForAdmin in Order Service : $e");
      return [];
    }
  }

  static Future<OrdersModel?> getMostRecentOrder(UserModel user) async {
    List<ProductModel> allProducts = await ProductService.getAllProducts();

    var querySnapshot = await db
        .collection(CollectionConfig.orders)
        .where("user_id", isEqualTo: user.uid)
        .get();
    // Fetch all orders for the user without sorting by date
    var orders = querySnapshot.docs.map((doc) {
      Timestamp time = doc["date"];
      DateTime date = time.toDate();
      return {
        "id": doc.id,
        "date": date,
        "status": doc["status_id"],
        // Other necessary data
      };
    }).toList();
    orders.sort((a, b) => b["date"].compareTo(a["date"]));
    return OrdersModel(
        user: user,
        products: await getProductsInOrder(orders[0]["id"], allProducts),
        date: orders[0]["date"],
        orderId: orders[0]["id"],
        status: orders[0]["status"]);
  }

  static Future<String?> getMostRecentOrderID(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('user_id', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
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

  static Future deleteOrderItemsByProductId(String productId) async {
    await db
        .collection(CollectionConfig.orderItems)
        .where("product_id", isEqualTo: productId)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        await db.collection(CollectionConfig.orderItems).doc(doc.id).delete();
      }
    });
  }

  static Future<List<StatusModel>> getAllStatus() async {
    List<StatusModel> allStatus = [];
    await db.collection(CollectionConfig.status).get().then((value) {
      for (var doc in value.docs) {
        allStatus.add(StatusModel.fromFireStore(doc));
      }
    });
    return allStatus;
  }

  static Future updateOrderStatus(String orderId, String statusId) async {
    await db
        .collection(CollectionConfig.orders)
        .doc(orderId)
        .update({"status_id": statusId});
  }
}
