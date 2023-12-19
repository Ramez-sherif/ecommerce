
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/services/orders.dart';
import 'package:ecommerce/services/product.dart';

class PaymentService {
  static var db = FirebaseFirestore.instance;
  static Future makePayment(String userId) async {
    List<ProductModel> allProducts = await ProductService.getAllProducts();
    CartModel cart = await CartService.getCart(userId, allProducts);
    //transfer all cart_items into order_items
    await OrdersService.createOrderFromCart(cart);
    
  }
  
}
