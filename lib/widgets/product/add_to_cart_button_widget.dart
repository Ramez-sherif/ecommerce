import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartButtonWidget extends StatefulWidget {
  final int counter;
  final ProductModel product;

  const AddToCartButtonWidget({
    super.key,
    required this.counter,
    required this.product,
  });

  @override
  State<AddToCartButtonWidget> createState() => _AddToCartButtonWidgetState();
}

class _AddToCartButtonWidgetState extends State<AddToCartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<HomeProvider>().addProductToCart(
              widget.product,
              context.read<UserProvider>().user.uid,
              widget.counter,
            );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.product.name} added to cart'),
          ),
        );
      },
      icon: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 41, 154, 55),
        ),
        padding: const EdgeInsets.all(10.0),
        child: const Icon(Icons.shopping_basket_sharp, color: Colors.black),
      ),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            "Add to cart",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            "\$${widget.counter * widget.product.price}",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        alignment: Alignment.topLeft,
        backgroundColor: Colors.black,
      ),
    );
  }
}
