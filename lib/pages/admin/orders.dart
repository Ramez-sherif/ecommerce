import 'package:ecommerce/pages/order_details.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:ecommerce/widgets/admin/orders/change_order_status_modal.dart';
import 'package:ecommerce/widgets/admin/orders/filter_orders_modal.dart';
import 'package:ecommerce/widgets/admin/orders/sort_orders_modal.dart';
import 'package:ecommerce/widgets/admin/orders/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({Key? key}) : super(key: key);

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  Future getAllOrders() async {
    if (mounted) {
      if (context.read<AdminProvider>().allStatus.isEmpty) {
        await context.read<AdminProvider>().getAllStatus();
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
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<AdminProvider>().getAllOrders();
      },
      child: Column(
        children: [
          buildFilterAndSort(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: context.watch<AdminProvider>().pageOrders.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  context
                      .watch<AdminProvider>()
                      .pageOrders[index]
                      .order
                      .user
                      .username,
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  context.watch<AdminProvider>().pageOrders[index].status.name,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Text(
                  context
                      .watch<AdminProvider>()
                      .pageOrders[index]
                      .totalPrice
                      .toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                leading: IconButton(
                  icon: PopupMenuButton<int>(
                    onSelected: (item) => handleClick(item, index),
                    itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text('order details'),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text('User details'),
                      ),
                      const PopupMenuItem<int>(
                        value: 2,
                        child: Text('Change Order Status'),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Row buildFilterAndSort() {
    return Row(
      // 2 buttons for filtering orders by status
      // and sorting orders by price
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).colorScheme.primary,
              builder: (context) {
                return FilterOrdersModal(
                  allStatuses: context.read<AdminProvider>().allStatus,
                );
              },
            );
          },
          child: Text(
            'Filter by status',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).colorScheme.primary,
              builder: (context) {
                return const SortOrdersModal();
              },
            );
          },
          child: Text(
            'Sort by price',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }

  void handleClick(int item, index) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(
                allProducts: context
                    .read<AdminProvider>()
                    .pageOrders[index]
                    .order
                    .products),
          ),
        );
        break;
      case 1:
        showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).colorScheme.primary,
          builder: (context) => UserDetailsModal(
            user: context.read<AdminProvider>().pageOrders[index].order.user,
          ),
        );
        break;

      case 2:
        showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).colorScheme.primary,
          builder: (context) => ChangeOrderStatusModal(
            order: context.read<AdminProvider>().pageOrders[index].order,
            allStatuses: context.read<AdminProvider>().allStatus,
          ),
        );
        break;
    }
  }
}