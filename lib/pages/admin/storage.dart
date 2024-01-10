import 'package:ecommerce/pages/admin/categories.dart';
import 'package:ecommerce/pages/admin/customer_support_page.dart';
import 'package:ecommerce/pages/admin/notifications_to_all.dart';
import 'package:ecommerce/pages/admin/orders.dart';
import 'package:ecommerce/pages/admin/products.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminStoragePage extends StatefulWidget {
  const AdminStoragePage({super.key});

  @override
  State<AdminStoragePage> createState() => _AdminStoragePageState();
}

class _AdminStoragePageState extends State<AdminStoragePage> {
  Future getAllOrders() async {
    if (mounted) {
      if (context.read<AdminProvider>().pageOrders.isEmpty) {
        await context.read<AdminProvider>().getAllOrders();
      }
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
            return buildBody(context);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
      },
    );
  }

  SingleChildScrollView buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildItem(context, 'Products', const AdminProductsPage()),
          buildItem(context, 'Categories', const AdminCategoriesPage()),
          buildItem(context, 'Orders', const AdminOrdersPage()),
          buildItem(
              context, 'Send Notification', const SendNotificationsToAllPage()),
              buildItem(
              context, 'User Customer Support',  const CustomerSupportPage()),
        ],
      ),
    );
  }

  Container buildItem(BuildContext context, String title, Widget page) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
