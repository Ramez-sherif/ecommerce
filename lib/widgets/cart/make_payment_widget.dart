import 'package:flutter/material.dart';

class MakePaymentWidget extends StatelessWidget {
  const MakePaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(90, 247, 247, 247),
        borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(30), right: Radius.circular(30)),
        border: Border.all(
          color: const Color.fromARGB(100, 11, 11, 11),
          width: 2.0,
        ),
      ), // Adjus

      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Make Payment",
                  style: TextStyle(fontSize: 18, color: Colors.black)),
              Text("\$ 2342",
                  style: TextStyle(fontSize: 18, color: Colors.black))
            ],
          ))
        ],
      ),
    );
  }
}
