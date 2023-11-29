import 'package:ecommerce/pages/payment.dart';
import 'package:ecommerce/widgets/cart/dismissable_product_widget.dart';
import 'package:ecommerce/widgets/cart/payment_box_widget.dart';
import 'package:flutter/material.dart';

List<dynamic> products = [];

class CartView extends StatelessWidget {
  CartView({Key? key}) : super(key: key) {
    products = [];

    dynamic p1 = {
      'description': "Book1",
      'imagePath': "Image1.jpeg",
      'price': 123,
    };
    dynamic p2 = {
      'description': "Book2",
      'imagePath': "Image2.jpeg",
      'price': 123,
    };
    dynamic p3 = {
      'description': "Book3",
      'imagePath': "Image3.png",
      'price': 123,
    };
    products.add(p1);
    products.add(p2);
    products.add(p3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
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
