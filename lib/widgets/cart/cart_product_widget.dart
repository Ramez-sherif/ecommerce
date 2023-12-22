import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/widgets/cart/quantity_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CartProductWidget extends StatefulWidget {
  CartProductWidget({
    super.key,
    required this.productModel,
    required this.quantity,
  });

  final ProductModel productModel;
  int quantity;
  @override
  State<CartProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<CartProductWidget> {
  void incrementQuantity() {
    setState(() {
      widget.quantity++;
      changeQuantity();
    });
  }

  void decrementQuantity() {
    if (widget.quantity > 0) {
      setState(() {
        widget.quantity--;
        changeQuantity();
      });
    }
  }

  void changeQuantity() {
    String userId = context.read<UserProvider>().user.uid;
    context.read<HomeProvider>().updateProductQuantity(
          widget.productModel,
          userId,
          widget.quantity,
        );
  }

  CachedNetworkImage getProductImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: getProductImage(
                widget.productModel.image_URL,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 3,
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
                            icon: Icons.remove,
                          ),
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
                            icon: Icons.add,
                          )
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
    );
  }
}
