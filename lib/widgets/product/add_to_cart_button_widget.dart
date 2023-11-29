import 'package:flutter/material.dart';

class AddToCartButtonWidget extends StatefulWidget {
  const AddToCartButtonWidget({super.key,required this.counter});
final int counter;
  @override
  State<AddToCartButtonWidget> createState() => _AddToCartButtonWidgetState();
}

class _AddToCartButtonWidgetState extends State<AddToCartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add to cart functionality
      },
      icon: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(
              255, 41, 154, 55), // Change the color of the circle as needed
        ),
        padding: const EdgeInsets.all(10.0), // Adjust padding as needed
        child: const Icon(Icons.shopping_basket_sharp,
            color: Colors.black // Change the color of the icon as needed
            ),
      ),
      label:  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Add to cart", style: TextStyle(fontSize: 18,color: Colors.white)),
          const SizedBox(width: 160),
          Text("\$${widget.counter * 50}", style: const TextStyle(fontSize: 18,color: Colors.white))
        ],
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(50.0), // Set border radius as needed
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 10.0), // Adjust overall button padding
        alignment: Alignment.topLeft,
        backgroundColor:
            Colors.black, // Aligns the icon and label to the center
      ),
    );
  }
}
