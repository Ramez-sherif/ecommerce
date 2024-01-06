import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/services/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

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
              buildTextForm(_nameController, 'Name'),
              const SizedBox(height: 20),
              buildTextForm(_descriptionController, 'Description'),
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

  TextFormField buildTextForm(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        hintText: 'Enter $label',
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        return null;
      },
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
      // print(_selectedIcon!.icon.toString());
      // return;

      
      CategoryModel category = CategoryModel(
        id: '',
        name: _nameController.text,
        description: _descriptionController.text,
        iconName: _selectedIcon!.icon.toString(),
      );

      bool result = await CategoryService.createCategory(category);
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