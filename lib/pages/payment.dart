import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Sample data for shipping address, payment methods, and total price
  String shippingAddress = '123 Main St, City, Country';
  String creditNumber = 'xxxx-xxxx-xxxx-1234';
  int numberOfCards = 2;
  double totalPrice = 321.00;
  double cardHeight = 100.00; 

  int selectedCard = 0; // Index of the selected card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // To avoid the automatic back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text('Checkout'),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Handle shopping cart button press
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
    _buildHeader('Shipping Address', 'Edit'),
    _buildInfoRow(shippingAddress),
    SizedBox(height: 16.0),
    _buildSpacer(), // Spacer for the shipping section
    _buildHeader('Payment Method', 'Add New Card'),
    Container(
      height: 2*cardHeight, // Set the desired height for the ListView
      child: ListView.builder(
        itemCount: 7, // Set the number of payment cards as needed
        itemBuilder: (context, index) { 
          // Replace the hardcoded data with your payment card data
          return _buildPaymentCard('Credit Card', Icons.credit_card, 0, creditNumber);
          //card number will change for eachentry
        },
      ),
    ),
                  // SizedBox(height: 16.0),
                 // Spacer between cards and total/checkout section
                  _buildPaymentCard('Cash', Icons.money_off, -1),
                    _buildSpacer(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
            child: _buildTotalPrice(totalPrice),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: _buildCheckoutButton(), // Checkout button at the bottom
          ),
          SizedBox(height: 16.0), // Optional spacer for better visual separation
        ],
      ),
    );
  }

  Widget _buildHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle the edit or add action
            print('$action button pressed');
          },
          child: Text(
            action,
            style: TextStyle(
              color: Colors.grey, // Set the text color to grey
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String info) {
    List<String> addressLines = info.split(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: addressLines.map((line) => Text(
        line,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
      )).toList(),
    );
  }
Widget _buildPaymentCard(String title, IconData icon, int index, [String number = '']) {
  Color cardColor = Colors.grey[200]!; // Default color

  if (index == -1) {
    // Cash
   cardColor = Colors.grey[200]!; // Grey color for cash
  } else if (index == 0) {
    // Credit Card
    cardColor = Color.fromARGB(255, 235, 247, 255); // Light blue-grey color for credit card
  }

  return Container(
    height: cardHeight, // Set the desired height for each card
    child: Card(
      elevation: 2.0,
      color: cardColor, // Set the background color based on the payment method
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white, // White circle for the icon
          child: Icon(icon, color: Colors.green), // Green icon
        ),
        title: Text(title),
        subtitle: Text(number),
        trailing: Radio<int>(
          value: index,
          groupValue: selectedCard,
          onChanged: (int? value) {
            setState(() {
              selectedCard = value!;
            });
          },
          activeColor: Colors.green, // Green color for the active radio button
        ),
      ),
    ),
  );
}


  Widget _buildTotalPrice(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Price',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        Text(
          '\$$price',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      width: double.infinity, // Make the button take the full width
      child: Card(
        color: Colors.blueGrey, // Use a dark color for the card background
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Checkout',
              style: TextStyle(
                color: Colors.white, // White text color
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpacer() {
    return SizedBox(height: 8.0);
  }
}


