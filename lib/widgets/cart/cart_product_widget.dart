import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/widgets/cart/quantity_icon_widget.dart';
import 'package:flutter/material.dart';

class CartProductWidget extends StatefulWidget {
  CartProductWidget(
      {super.key, required this.productModel, required this.quantity});
      
  final ProductModel productModel;
  int quantity;
  @override
  State<CartProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<CartProductWidget> {
  void incrementQuantity() {
    setState(() {
      widget.quantity++;
    });
  }

  void decrementQuantity() {
    if (widget.quantity > 0) {
      setState(() {
        widget.quantity--;
        CartService.updateProductQuantity(
            widget.productModel.id, "1", widget.quantity);
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
                child: Image.network(
                  widget.productModel.image_URL,
                  width: 100,
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
                      widget.productModel.name,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    const SizedBox(height: 25.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.productModel.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(248, 194, 194, 194)),
                          child: Row(
                            children: <Widget>[
                              QuantityIcon(
                                  onChangedQuantity: decrementQuantity,
                                  iconColor: Colors.green,
                                  backgroundColor: Colors.white,
                                  icon: Icons.remove),
                              const SizedBox(width: 20.0),
                              Text(
                                widget.quantity.toString(),
                                style: const TextStyle(fontSize: 18.0),
                              ),
                              const SizedBox(width: 20.0),
                              QuantityIcon(
                                  onChangedQuantity: incrementQuantity,
                                  iconColor: Colors.white,
                                  backgroundColor: Colors.green,
                                  icon: Icons.add)
                            ],
                          ),
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
