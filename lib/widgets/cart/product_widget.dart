import 'package:flutter/material.dart';

class ProductWidget extends StatefulWidget {
  final String imagePath;
  final String description;
  final double price;

  const ProductWidget(
      {super.key,
      required this.imagePath,
      required this.description,
      required this.price});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  int quantity = 0;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }
  void decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ),
        
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/${widget.imagePath}",
                  width:100,
                  height: 100,
                ),
               
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.description,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    const SizedBox(height: 25.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),
                        ),
                          Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                           color: const Color.fromARGB(248, 194, 194, 194)
                          ),
                          child: Row(children: <Widget>[
                              GestureDetector(
                                onTap: decrementQuantity,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.green,
                                    size: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(fontSize: 18.0),
                              ),
                              const SizedBox(width: 20.0),
                              GestureDetector(
                                onTap: incrementQuantity,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ])
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
