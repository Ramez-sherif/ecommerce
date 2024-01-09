import 'package:ecommerce/providers/admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortOrdersModal extends StatelessWidget {
  const SortOrdersModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            'Ascending',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onTap: () {
            context.read<AdminProvider>().sortOrdersByPrice(isAscending: true);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(
            'Descending',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onTap: () {
            context.read<AdminProvider>().sortOrdersByPrice(isAscending: false);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
