import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/pages/payment.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/widgets/cart/make_payment_widget.dart';
import 'package:ecommerce/widgets/cart/rect_clipper.dart';
import 'package:flutter/material.dart';

class PaymentBoxWidget extends StatelessWidget {
  const PaymentBoxWidget({super.key, required this.cart, required this.price});
  final double price;
  final CartModel cart;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipPath(
          clipper: BottomRectangleClipper(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.green,
            ),
            width: MediaQuery.of(context).size.width - 30,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("${CartService.getTotalPrice(cart.products)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentPage(),
                        ),
                      );
                    },
                    child: const MakePaymentWidget(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
