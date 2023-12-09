import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/payment.dart';
import 'package:ecommerce/widgets/cart/dismissable_product_widget.dart';
import 'package:ecommerce/widgets/cart/payment_box_widget.dart';
import 'package:flutter/material.dart';

List<ProductModel> products = [];

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key) {
    products = [];

    ProductModel p1 = ProductModel(
        id: "1",
        name: "Apple",
        image_URL: "Image2.jpeg",
        price: 123,
        description: "Tasty Green Apple",
        rating: 1,
        quantity: 1,
        category: CategoryModel(id: "1", name: "", description: "description"));
    ProductModel p2 = ProductModel(
        id: "2",
        name: "Sky",
        image_URL: "Image1.jpeg",
        price: 123,
        description: "Sky and trees",
        rating: 5,
        quantity: 1,
        category: CategoryModel(id: "1", name: "", description: "description"));
    ProductModel p3 = ProductModel(
        id: "3",
        name: "Fireworks",
        image_URL: "Image3.png",
        price: 123,
        description: "Colorful Fireworks",
        rating: 5,
        quantity: 1,
        category: CategoryModel(id: "1", name: "", description: "description"));

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
