import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // Sample order data
Future getAllOrders() async {
    if (context.read<ProfileProvider>().allOrders.isEmpty) {
      String userId = context.read<UserProvider>().user.uid;
      await context.read<ProfileProvider>().setAllOrders(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text('Order List'),
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder(
          future: getAllOrders(), // Your asynchronous function call
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for the Future
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Display an error message if the Future fails
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<OrdersModel> allOrders = context.watch<ProfileProvider>().allOrders;

              // Display the data using ListView.builder once the Future completes
              return RefreshIndicator(
                onRefresh: () async {
                   await context.read<ProfileProvider>().setAllOrders(context.read<UserProvider>().user.uid);
                   },
                child: ListView.builder(
                  itemCount: allOrders.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 13,horizontal: 5),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                          color: Theme.of(context).colorScheme.primary),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('go to products details'),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://img.freepik.com/premium-vector/people-delivery-products_318923-61.jpg"),
                          ),
                         
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order ID: ${allOrders[index].orderId}'),
                              Text(
                                  "Date: ${allOrders[index].date.day}/${allOrders[index].date.month}/${allOrders[index].date.year}"),
                                  Text("Time:${allOrders[index].date.hour}:${allOrders[index].date.minute}")
                            ],
                          ),
                          trailing: _buildStatusIndicator(2),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }, // FutureBuilder ends here
        )
        // Column(
        //   children: [
        //     // _buildFilterDropdown(),
        //     // Divider(),
        //     _buildOrderList(),
        //   ],
        // ),
        );
  }


  Widget _buildStatusIndicator(int status) {
    Color color;
    String statusText;

    switch (status) {
      case 1:
        color = Colors.blue;
        statusText = 'Shipped';
        break;
      case 2:
        color = Colors.green;
        statusText = 'Delivered';
        break;
      case 3:
        color = Colors.red;
        statusText = 'Incomplete';
        break;
      default:
        color = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(8), // Adjust the border radius as needed
      ),
      padding: EdgeInsets.all(8), // Adjust the padding as needed
      child: Text(
        statusText,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

}

enum OrderStatus { shipped, delivered, incomplete, all }

class Order {
  final int orderId;
  final String productName;
  final String date;
  final OrderStatus status;

  Order(this.orderId, this.productName, this.date, this.status);

  // Assuming you have image paths like 'assets/ProductA.png'
  String get productImage => 'Product${productName.replaceAll(' ', '')}';
}

String statusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.shipped:
      return 'Shipped';
    case OrderStatus.delivered:
      return 'Delivered';
    case OrderStatus.incomplete:
      return 'Incomplete';
    default:
      return 'All';
  }
}
