import 'package:ecommerce/widgets/cart/make_payment_widget.dart';
import 'package:ecommerce/widgets/cart/product_widget.dart';
import 'package:ecommerce/widgets/cart/rectClipper.dart';
import 'package:flutter/material.dart';

List<dynamic> products = [];

class CartView extends StatelessWidget {
  const CartView({Key? key});

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Cart", textAlign: TextAlign.center)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Dismissible(
                        key: Key(products[index]['description']),
                        direction: DismissDirection.horizontal,
                        background: Container(
                            margin: const EdgeInsets.symmetric(vertical: 9),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20.0),
                         decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.white],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight
                          )
                         ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.symmetric(vertical: 9),
                          padding: const EdgeInsets.only(right: 20.0),
                          decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.white],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft
                          )
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          //delete from database
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${products[index]['description']} dismissed'),
                            ),
                          );
                          
                            products.removeAt(index);
                         
                        },
                        child: ProductWidget(
                          imagePath: products[index]['imagePath'],
                          description: products[index]['description'],
                          price: products[index]['price'].toDouble(),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.transparent
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipPath(
                  clipper: BottomRectangleClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    height: 250, // Adjust the height of the bottom rectangle
                    width: MediaQuery.of(context).size.width - 30,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, top: 20, bottom: 30),
                      child: Column(
                        children: [
                          const SizedBox(height: 40,),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("Del. Amount:"), Text("400\$")],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("Total Amount:"), Text("400\$")],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MakePaymentWidget()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
