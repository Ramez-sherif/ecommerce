import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/status.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChangeOrderStatusModal extends StatelessWidget {
  final List<StatusModel> allStatuses;
  final OrdersModel order;

  const ChangeOrderStatusModal({
    super.key,
    required this.allStatuses,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...allStatuses
            .map(
              (status) => ListTile(
                title: Text(
                  status.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onTap: () async {
                  // show circular progress indicator
                  showDialog(
                    context: context,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  );

                  await context.read<AdminProvider>().updateOrderStatus(
                        orderId: order.orderId,
                        statusId: status.id,
                      );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            )
            .toList(),
      ],
    );
  }
}
