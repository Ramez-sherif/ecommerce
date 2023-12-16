import "package:ecommerce/models/category.dart";
import "package:ecommerce/models/product.dart";
import "package:ecommerce/services/cart.dart";
import "package:ecommerce/widgets/cart/cart_product_widget.dart";
import "package:flutter/material.dart";

class DismissableProductWidget extends StatelessWidget {
  const DismissableProductWidget({
    super.key,
    required this.product,
    required this.quantity,
  });
  final ProductModel product;
  final int quantity;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: Key(product.description),
          direction: DismissDirection.horizontal,
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 9),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 254, 193, 189), Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 255, 0, 0),
            ),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(vertical: 9),
            padding: const EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 254, 193, 189), Colors.white],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
            child: const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 255, 0, 0),
            ),
          ),
          onDismissed: (direction) async {
            //delete from database
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.name} deleted'),
              ),
            );
            //uncomment to remove from database
            await CartService.removeProductFromCart(product, "1");
          },
          child: CartProductWidget(
            productModel: ProductModel(
              id: product.id,
              name: product.name,
              image_URL: product.image_URL,
              description: product.description,
              price: product.price.toDouble(),
              rating: product.rating,
              quantity: 20,
              category: CategoryModel(
                id: product.category.id,
                name: product.category.name,
                description: product.category.description,
              ),
            ),
            quantity: quantity,
          ),
        ),
      ],
    );
  }
}
