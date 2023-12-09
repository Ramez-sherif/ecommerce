import 'package:flutter/material.dart';


class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // Sample order data
  List<Order> orders = [
    Order(1, 'Product A', '2023-01-01', OrderStatus.shipped),
    Order(2, 'Product B', '2023-02-15', OrderStatus.delivered),
    Order(3, 'Product C', '2023-03-20', OrderStatus.incomplete),
  ];

  // Filtered orders based on selected status
  List<Order> filteredOrders = [];

  // Currently selected order status
  OrderStatus selectedStatus = OrderStatus.all;

  @override
  void initState() {
    super.initState();
    // Initially, show all orders
    filteredOrders = List.from(orders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body: Column(
        children: [
          _buildFilterDropdown(),
          Divider(),
          _buildOrderList(),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Filter by Status:'),
          SizedBox(width: 10),
          DropdownButton<OrderStatus>(
            value: selectedStatus,
            items: OrderStatus.values.map((status) {
              return DropdownMenuItem<OrderStatus>(
                value: status,
                child: Text(statusToString(status)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedStatus = value!;
                _updateFilteredOrders();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return _buildOrderItem(order);
        },
      ),
    );
  }

  Widget _buildOrderItem(Order order) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/${order.productImage}.png'),
      ),
      title: Text(order.productName),
      subtitle: Text('Order ID: ${order.orderId} - Date: ${order.date}'),
      trailing: _buildStatusIndicator(order.status),
    );
  }

Widget _buildStatusIndicator(OrderStatus status) {
  Color color;
  String statusText;

  switch (status) {
    case OrderStatus.shipped:
      color = Colors.blue;
      statusText = 'Shipped';
      break;
    case OrderStatus.delivered:
      color = Colors.green;
      statusText = 'Delivered';
      break;
    case OrderStatus.incomplete:
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
      borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
    ),
    padding: EdgeInsets.all(8), // Adjust the padding as needed
    child: Text(
      statusText,
      style: TextStyle(color: Colors.white),
    ),
  );
}


  void _updateFilteredOrders() {
    if (selectedStatus == OrderStatus.all) {
      filteredOrders = List.from(orders);
    } else {
      filteredOrders = orders.where((order) => order.status == selectedStatus).toList();
    }
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
