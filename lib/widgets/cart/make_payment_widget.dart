import 'package:flutter/material.dart';

class MakePaymentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Navigate to the previous page
                Navigator.pushReplacementNamed(context, '/page1');
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Navigate to the next page
                Navigator.pushReplacementNamed(context, '/page2');
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                // Navigate to another page
                Navigator.pushReplacementNamed(context, '/page3');
              },
            ),
          ),
          SizedBox(width: 20), // Add spacing between buttons
          ElevatedButton(
            onPressed: () {
              // Perform payment action
              // This could be a function to handle payment logic
            },
            child: Text('Make Payment'),
          ),
        ],
      ),
    );
  }
}
