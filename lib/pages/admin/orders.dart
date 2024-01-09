import 'package:ecommerce/providers/admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({Key? key}) : super(key: key);

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  Future getAllOrders() async {
    if (context.read<AdminProvider>().allOrders.isEmpty) {
      await context.read<AdminProvider>().getAllOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Orders'),
              ),
              body: buildBody(),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
      },
    );
  }

  Widget buildBody() {
    return ListView.builder(
      itemCount: context.watch<AdminProvider>().allOrders.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            context.watch<AdminProvider>().allOrders[index].order.user.username,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            context.watch<AdminProvider>().allOrders[index].status.name,
            style: const TextStyle(fontSize: 16),
          ),
          trailing: Text(
            context
                .watch<AdminProvider>()
                .allOrders[index]
                .totalPrice
                .toString(),
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}
