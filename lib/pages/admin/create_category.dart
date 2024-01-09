import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:ecommerce/widgets/admin/shared_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';

class AdminCreateCategoryPage extends StatefulWidget {
  const AdminCreateCategoryPage({super.key});

  @override
  State<AdminCreateCategoryPage> createState() =>
      _AdminCreateCategoryPageState();
}

class _AdminCreateCategoryPageState extends State<AdminCreateCategoryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Icon? _selectedIcon;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SharedTextFormField(controller: _nameController, label: 'Name'),
              const SizedBox(height: 20),
              SharedTextFormField(
                  controller: _descriptionController, label: 'Description'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Icon:',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _selectedIcon != null ? _selectedIcon!.icon : Icons.add,
                      size: 40,
                    ),
                    onPressed: _showIconPickerDialog,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Create Category',
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showIconPickerDialog() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.material],
      backgroundColor: Theme.of(context).colorScheme.primary,
      closeChild: Text(
        'Close',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );

    // check if icon is not null
    if (icon != null) {
      _selectedIcon = Icon(icon);
    }
    setState(() {});
  }

  Future<void> _submitForm() async {
    // close keyboard
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && validateIcon()) {
      // print(_selectedIcon!.icon!.codePoint);
      // return;

      CategoryModel category = CategoryModel(
        id: '',
        name: _nameController.text,
        description: _descriptionController.text,
        iconCode: _selectedIcon!.icon!.codePoint,
      );

      bool result =
          await context.read<AdminProvider>().createCategory(category);
      if (context.mounted) {
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Category created successfully.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
          // clear form
          _nameController.clear();
          _descriptionController.clear();
          _selectedIcon = null;
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to create category.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  bool validateIcon() {
    if (_selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select an icon.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }
}
