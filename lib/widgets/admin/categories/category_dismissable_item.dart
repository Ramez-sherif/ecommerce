import 'dart:developer';

import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryDismissableItem extends StatefulWidget {
  final CategoryModel category;

  const CategoryDismissableItem({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryDismissableItem> createState() =>
      _CategoryDismissableItemState();
}

class _CategoryDismissableItemState extends State<CategoryDismissableItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.category.id),
      onDismissed: (direction) async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        await context
            .read<AdminProvider>()
            .deleteCategoryById(widget.category.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              content: Text(
                '${widget.category.name} deleted',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              action: SnackBarAction(
                textColor: Theme.of(context).colorScheme.primary,
                label: 'Undo',
                onPressed: () async {
                  if (context.mounted) {
                    bool result = await context
                        .read<AdminProvider>()
                        .createCategory(widget.category);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.category.name} restored',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error restoring ${widget.category.name}',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    log('context not mounted');
                  }
                },
              ),
            ),
          );
        }
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 36,
        ),
      ),
      child: ListTile(
        title: Text(widget.category.name),
        subtitle: Text(widget.category.description),
        leading: Icon(
          IconData(
            widget.category.iconCode,
            fontFamily: 'MaterialIcons',
          ),
          size: 24,
        ),
      ),
    );
  }
}
