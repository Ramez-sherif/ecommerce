import 'package:ecommerce/pages/payment.dart';
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
            appBar: AppBar(
              title: const Text("Cart"),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      String userId = context.read<UserProvider>().user.uid;
                      await context
                          .read<HomeProvider>()
                          .setCartProducts(userId);
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: context
                          .watch<HomeProvider>()
                          .cartProducts!
                          .products
                          .length,
                      itemBuilder: (context, index) {
                        final entry = context
                            .watch<HomeProvider>()
                            .cartProducts!
                            .products
                            .entries
                            .toList()[index];
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentPage(),
                        ),
                      );
                    },
                    child: PaymentBoxWidget(
                      cart: context.watch<HomeProvider>().cartProducts!,
                      price: totalPrice,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
