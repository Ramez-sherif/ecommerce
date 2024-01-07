// ignore_for_file: use_build_context_synchronously

import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/receipt.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Checkout',
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // _buildHeader('Shipping Address', 'Edit'),
                      // _buildInfoRow(shippingAddress),
                      // const SizedBox(height: 16.0),
                      _buildSpacer(), // Spacer for the shipping section
                      // _buildHeader('Payment Method', ''),
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height:
                            cardHeight, // Set the desired height for the ListView
                        child: ListView.builder(
                          itemCount:
                              1, // Set the number of payment cards as needed
                          itemBuilder: (context, index) {
                            // Replace the hardcoded data with your payment card data
                            return _buildPaymentCard(
                              'Credit Card',
                              Icons.credit_card,
                              0,
                              creditNumber,
                            );
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: _buildTotalPrice(totalPrice),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: _buildCheckoutButton(), // Checkout button at the bottom
              ),
              const SizedBox(
                  height: 16.0), // Optional spacer for better visual separation
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildHeader(String title, String action) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         title,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 18.0,
  //         ),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           // Handle the edit or add action
  //           // ignore: avoid_print
  //           print('$action button pressed');
  //         },
  //         child: Text(
  //           action,
  //           style: const TextStyle(
  //             color: Colors.green, // Set the text color to grey
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildInfoRow(String info) {
  //   List<String> addressLines = info.split(', ');

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: addressLines
  //         .map((line) => Text(
  //               line,
  //               style: const TextStyle(
  //                 color: Colors.grey,
  //                 fontSize: 16.0,
  //               ),
  //             ))
  //         .toList(),
  //   );
  // }

  Widget _buildPaymentCard(String title, IconData icon, int index,
      [String number = '']) {
    Color cardColor = Colors.green; // Default color

    if (index == -1) {
      // Cash
      cardColor = Colors.green; // Grey color for cash
    } else if (index == 0) {
      // Credit Card
      cardColor = Colors.green; // Light blue-grey color for credit card
    }

    return SizedBox(
      height: cardHeight, // Set the desired height for each card
      child: Card(
        elevation: 2.0,
        color:
            cardColor, // Set the background color based on the payment method
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context)
                .colorScheme
                .secondary, // White circle for the icon
            child: Icon(icon, color: Colors.white), // Green icon
          ),
          title: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: Text(
            number,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          trailing: Radio<int>(
            value: index,
            groupValue: selectedCard,
            onChanged: (int? value) {
              setState(() {
                selectedCard = value!;
              });
            },
            activeColor:
                Colors.white, // Green color for the active radio button
          ),
        ),
      ),
    );
  }

  Widget _buildTotalPrice(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Price',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        Text(
          '\$$price',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return GestureDetector(
      onTap: makeOrder,
      child: const SizedBox(
        width: double.infinity, // Make the button take the full width
        child: Card(
          color: Colors.green, // Use a dark color for the card background
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
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
      ),
    );
  }

  Future<void> makeOrder() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
    String uid = context.read<UserProvider>().user.uid;
    await PaymentService.makePayment(uid);
    await context.read<HomeProvider>().setHomeAllProducts();
    await context.read<HomeProvider>().setCartProducts(uid);
    await context.read<ProfileProvider>().setUserProfile(uid);
    await context.read<ProfileProvider>().setAllOrders(uid);
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReceiptScreen()),
    );
  }

  Widget _buildSpacer() {
    return const SizedBox(height: 8.0);
  }
}
