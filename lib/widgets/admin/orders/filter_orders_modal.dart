import 'package:ecommerce/models/status.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterOrdersModal extends StatelessWidget {
  final List<StatusModel> allStatuses;

  const FilterOrdersModal({Key? key, required this.allStatuses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            'Reset',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onTap: () {
            context.read<AdminProvider>().resetOrders();
            Navigator.pop(context);
          },
        ),
        ...allStatuses
            .map(
              (status) => ListTile(
                title: Text(
                  status.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onTap: () {
                  context
                      .read<AdminProvider>()
                      .filterOrdersByStatus(statusId: status.id);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ],
    );
  }
}
