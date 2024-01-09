import 'dart:developer';

import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _selectedIconCode = 1;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category.name;
    _descriptionController.text = widget.category.description;
    _selectedIconCode = widget.category.iconCode;
  }

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
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Edit Category'),
                contentPadding: const EdgeInsets.all(16.0),
                backgroundColor: Theme.of(context).colorScheme.surface,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    // IconButton(
                    //   icon: Icon(
                    //     IconData(
                    //       _selectedIconCode,
                    //       fontFamily: 'MaterialIcons',
                    //     ),
                    //     size: 40,
                    //   ),
                    //   onPressed: () async {
                    //     await _showIconPickerDialog(context);
                    //   },
                    // ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (context.mounted) {
                        CategoryModel category = CategoryModel(
                          id: widget.category.id,
                          name: _nameController.text,
                          description: _descriptionController.text,
                          iconCode: _selectedIconCode,
                        );

                        await context
                            .read<AdminProvider>()
                            .updateCategory(category);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        } else {
                          log('context not mounted');
                        }
                      } else {
                        log('context not mounted');
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // ignore: unused_element
  Future<void> _showIconPickerDialog(BuildContext context) async {
    IconData? icon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.material],
      // backgroundColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.white,
      closeChild: Text(
        'Close',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );

    // check if icon is not null
    if (context.mounted) {
      if (icon != null) {
        setState(() {
          _selectedIconCode = icon.codePoint;
          // ignore: avoid_print
          print("icon changed to $_selectedIconCode");
        });
      }
    }
  }
}
