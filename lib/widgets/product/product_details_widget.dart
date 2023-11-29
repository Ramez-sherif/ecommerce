import 'package:flutter/material.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget(
      {super.key, required this.isFavorite, required this.toggleFavorite});

  final bool isFavorite;
  final Function toggleFavorite;
  State<ProductDetailsWidget> createState() => _productDetailsWidgetState();
}

class _productDetailsWidgetState extends State<ProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.isFavorite ? Colors.red : null,
                ),
                iconSize: 40.0,
                onPressed: () {
                  widget.toggleFavorite();
                }),
            const Text('Item Name',
                style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold)),
            const Row(
              children: [
                Icon(Icons.star, color: Colors.yellow,size: 40,),
                SizedBox(width: 4.0),
                Text('4.5', style: TextStyle(fontSize: 20.0)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Center(
            child: Image.asset(
          "assets/flower.jpg",
          width: 300,
          height: 350,
          fit: BoxFit.cover,
        )),
        const SizedBox(height: 25.0),
        const Text(
          'Item Description hbefbbhibd dhsbbysdgyb fsbdybysbfy...',
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
