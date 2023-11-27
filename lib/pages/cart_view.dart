import 'package:ecommerce/widgets/cart/product_widget.dart';
import 'package:flutter/material.dart';

List<dynamic> products = [];

class cartView extends StatelessWidget {
  const cartView({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic p1 =
        (description: "Book1", imagePath: "Image1.jpeg", price: 123);
    dynamic p2 =
        (description: "Book2", imagePath: "Image2.jpeg", price: 123);
    dynamic p3 =
        (description: "Book3", imagePath: "Image3.png", price: 123);
        products.add(p1);
        products.add(p2);
        products.add(p3);
    return Scaffold(
        appBar: AppBar(title: const Center(child: Text("Cart", textAlign: TextAlign.center)),
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(products[index].description),
              direction: DismissDirection.horizontal,
              background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20.0),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
              onDismissed: (direction) {
                    //delete from database
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${products[index].description} dismissed')),
                    );
                  },
              child: ProductWidget(imagePath: products[index].imagePath, description: products[index].description, price: products[index].price));
          }));
  }
}
