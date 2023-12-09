import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/payment.dart';
import 'package:ecommerce/widgets/cart/dismissable_product_widget.dart';
import 'package:ecommerce/widgets/cart/payment_box_widget.dart';
import 'package:flutter/material.dart';

List<MockProductModel> products = [];

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key) {
    products = [];

    MockProductModel p1 = MockProductModel(
        id: "1",
        productName: "Apple",
        imageUrl: "Image2.jpeg",
        productPrice: 123,
        productDescription: "Tasty Green Apple");
    MockProductModel p2 = MockProductModel(
        id: "2",
        productName: "Sky",
        imageUrl: "Image1.jpeg",
        productPrice: 123,
        productDescription: "Sky and trees");
    MockProductModel p3 = MockProductModel(
        id: "3",
        productName: "Fireworks",
        imageUrl: "Image3.png",
        productPrice: 123,
        productDescription: "Colorful Fireworks");

    products.add(p1);
    products.add(p2);
    products.add(p3);
  }

  @override
  Widget build(BuildContext context) {
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
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DismissableProductWidget(
                    products: products,
                    index: index,
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
                child: const PaymentBoxWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
