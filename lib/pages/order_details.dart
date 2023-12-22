import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.allProducts});
  final Map<ProductModel, int> allProducts;
  
  @override
  State<OrderDetailsPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: widget.allProducts.length,
        itemBuilder: (BuildContext context, int index) {
          ProductModel product = widget.allProducts.keys.elementAt(index);
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Theme.of(context).colorScheme.primary),
            child: ListTile(
              leading: Image.network(
                product.image_URL,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(product.name),
              subtitle: Text('Price: \$${product.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Quantity: ${widget.allProducts[product].toString()}"),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Total Price: \$${CartService.getTotalPrice(widget.allProducts).toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
