import 'package:flutter/material.dart';

class ProductQuantityWidget extends StatefulWidget {
  const ProductQuantityWidget(
      {super.key,
      required this.incrementCounter,
      required this.decrementCounter,
      required this.counter});
  final int counter;
  final Function incrementCounter;
  final Function decrementCounter;
  @override
  State<ProductQuantityWidget> createState() => _ProductQuantityWidgetState();
}

class _ProductQuantityWidgetState extends State<ProductQuantityWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          iconSize: 35,
          onPressed: () {
            widget.decrementCounter();
          },
          icon: const Icon(Icons.remove),
        ),
        Text(widget.counter.toString().padLeft(2, "0"),
            style: const TextStyle(
              fontSize: 70.0,
              fontWeight: FontWeight.bold,
            )),
        IconButton(
          iconSize: 35,
          onPressed: () {
            widget.incrementCounter();
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
