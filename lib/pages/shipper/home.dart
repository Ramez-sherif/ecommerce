import 'package:flutter/material.dart';

class ShipperHomePage extends StatefulWidget {
  @override
  _ShipperHomePageState createState() => _ShipperHomePageState();
}

class _ShipperHomePageState extends State<ShipperHomePage> {
  List<Order> orders = [
    Order(id: 123456, location: 'giza', amount: 12),
    Order(id: 123456, location: 'abasseya', amount: 5), 
    Order(id: 123456, location: 'thailand', amount: 3), 
  ];

  Order? selectedOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipper Home Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Order ID: ${orders[index].id}'),
                  subtitle: Text('Location: ${orders[index].location}   💵 ${orders[index].amount}'),
                  selected: selectedOrder == orders[index],
                  onTap: () {
                    setState(() {
                      selectedOrder = orders[index];
                    });
                  },
                );
              },
            ),
          ),
          if (selectedOrder != null) ...[
            SizedBox(height: 20),
            Text('Order Details:'),
            Text('Client Name: ${selectedOrder!.clientName}'),
            Text('Client Phone: ${selectedOrder!.clientPhone}'),
            Text('From: ${selectedOrder!.from}'),
            Text('To: ${selectedOrder!.to}'),
            Text('Longitude: ${selectedOrder!.longitude}'),
            Text('Expected Time: ${selectedOrder!.expectedTime}'),
          ],
        ],
      ),
    );
  }
}

class Order {
  final int id;
  final String location;
  final double amount;

  // Add more order details as needed
  String clientName = 'John Doe';
  String clientPhone = '123-456-7890';
  String from = 'Source Location';
  String to = 'Destination Location';
  double longitude = 0.0;
  String expectedTime = '12:00 PM';

  Order({
    required this.id,
    required this.location,
    required this.amount,
  });
}
