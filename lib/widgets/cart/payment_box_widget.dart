import 'package:ecommerce/widgets/cart/make_payment_widget.dart';
import 'package:ecommerce/widgets/cart/rectClipper.dart';
import 'package:flutter/material.dart';

class PaymentBoxWidget extends StatelessWidget{
  const PaymentBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return   Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipPath(
                  clipper: BottomRectangleClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    height: 300, // Adjust the height of the bottom rectangle
                    width: MediaQuery.of(context).size.width - 30,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Del. Amount:",
                                    style: TextStyle(fontSize: 18)),
                                Text("400\$", style: TextStyle(fontSize: 18))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Amount:",
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                ),
                                Text("400\$", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
                              ],
                            ),
                            MakePaymentWidget()
                          ],
                        ),
                    ),
                    ),
                  ),
              ),
            ),
          );
  }

}