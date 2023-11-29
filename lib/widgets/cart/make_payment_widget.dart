import 'package:ecommerce/pages/payment.dart';
import 'package:flutter/material.dart';

class MakePaymentWidget extends StatelessWidget {
  const MakePaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(90, 247, 247, 247),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(40),
          right: Radius.circular(40),
        ),
        border: Border.all(
          color: const Color.fromARGB(100, 11, 11, 11),
          width: 2.0,
        ),
      ),
      child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PaymentPage()));
          },
          splashColor: Colors.black.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Make Payment",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Container(
                height: 80, // Adjust the height as needed
                width: 130, // Adjust the width as needed
                decoration: const BoxDecoration(
                  color: Color.fromARGB(200, 3, 3, 3),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(
                        30.0), // Adjust the radius for left side
                    right: Radius.circular(
                        30.0), // Adjust the radius for right side
                  ),
                ),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.arrow_forward_ios,
                          color: Color.fromARGB(100, 255, 255, 255)),
                      Icon(Icons.arrow_forward_ios,
                          color: Color.fromARGB(150, 255, 255, 255)),
                      Icon(Icons.arrow_forward_ios,
                          color: Color.fromARGB(255, 255, 255, 255))
                    ]),
              ),
            ],
          )),
    );
  }
}
