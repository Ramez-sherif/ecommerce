import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/widgets/product/add_to_cart_button_widget.dart';
import 'package:ecommerce/widgets/product/product_details_widget.dart';
import 'package:ecommerce/widgets/product/product_quantity_widget.dart';
import 'package:flutter/material.dart';

class ItemDetailsPage extends StatefulWidget {
  final ProductModel product;
  const ItemDetailsPage({super.key, required this.product});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

int myCounter = 1;

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  bool isFavorite = false;
  List<String> favoriteItems = [];

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        favoriteItems
            .add("New Item"); // Change this line to add your desired item
      } else {
        favoriteItems
            .remove("New Item"); // Change this line to remove your desired item
      }
    });
  }

  void incrementCounter() {
    setState(() {
      myCounter++;
    });
  }

  void decrementCounter() {
    setState(() {
      if (myCounter > 1) {
        myCounter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductDetailsWidget(
                  isFavorite: isFavorite,
                  toggleFavorite: toggleFavorite,
                  product: widget.product,
                ),
                const SizedBox(height: 16.0),
                ProductQuantityWidget(
                  incrementCounter: incrementCounter,
                  decrementCounter: decrementCounter,
                  counter: myCounter,
                ),
                const SizedBox(height: 10.0),
                AddToCartButtonWidget(
                  counter: myCounter,
                  product: widget.product,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
