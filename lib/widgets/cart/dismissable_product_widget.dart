import "package:ecommerce/models/product.dart";
import "package:ecommerce/providers/home.dart";
import "package:ecommerce/providers/user.dart";
import "package:ecommerce/widgets/cart/cart_product_widget.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} deleted'),
                ),
              );
              String userId = context.read<UserProvider>().user.uid;
              await context
                  .read<HomeProvider>()
                  .removeProductFromCart(product, userId);
            },
            child: CartProductWidget(
              productModel: product,
              quantity: quantity,
            ),
          ),
        ],
      ),
    );
  }
}
