import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/widgets/cart/dismissable_product_widget.dart';
import 'package:ecommerce/widgets/cart/payment_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalPrice = 0;

  Future getCart() async {
    String userId = context.read<UserProvider>().user.uid;

    if (context.read<HomeProvider>().cartProducts == null) {
      await context.read<HomeProvider>().setCartProducts(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text("Cart"),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                String userId = context.read<UserProvider>().user.uid;
                await context.read<HomeProvider>().setCartProducts(userId);
              },
              child: ListView.builder(
                reverse: true,
                itemCount: context
                        .watch<HomeProvider>()
                        .cartProducts!
                        .products
                        .length +
                    1,
                itemBuilder: (context, index) {
                  print(
                      "index: $index, length: ${context.watch<HomeProvider>().cartProducts!.products.length}");
                  if (context
                      .watch<HomeProvider>()
                      .cartProducts!
                      .products
                      .isEmpty) {
                    return const Text("");
                  }
                  if (index == 0) {
                    return PaymentBoxWidget(
                      cart: context.watch<HomeProvider>().cartProducts!,
                      price: totalPrice,
                    );
                  }
                  final entry = context
                      .watch<HomeProvider>()
                      .cartProducts!
                      .products
                      .entries
                      .toList()[index - 1];

                  final key = entry.key;
                  final value = entry.value;
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: DismissableProductWidget(
                      product: key,
                      quantity: value,
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
