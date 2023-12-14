import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/payment.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/widgets/cart/dismissable_product_widget.dart';
import 'package:ecommerce/widgets/cart/payment_box_widget.dart';
import 'package:flutter/material.dart';

List<ProductModel> products = [];

class CartPage extends StatelessWidget {
  CartPage({super.key});
  double totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    //CartModel cartmodel = await CartService.getCart("1");

    return FutureBuilder<CartModel>(
        future: CartService.getCart("1"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            CartModel model = const CartModel(userId: "1", products: {});
            if (snapshot.data != null) {
              model = snapshot.data!;
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text("Cart"),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.products.length,
                      itemBuilder: (context, index) {
                        final entry = model.products.entries.toList()[index];
                        final key = entry.key;
                        final value = entry.value;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DismissableProductWidget(
                            product: key,
                            quantity: value,
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 100),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentPage(),
                            ),
                          );
                        },
                        child:  PaymentBoxWidget(cart: model,price :totalPrice),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
