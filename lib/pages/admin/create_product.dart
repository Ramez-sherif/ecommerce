import 'dart:io';

import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/widgets/admin/shared_number_form_field.dart';
import 'package:ecommerce/widgets/admin/shared_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class AdminCreateProductPage extends StatefulWidget {
  List<CategoryModel> categoriesList;
  AdminCreateProductPage({super.key, required this.categoriesList});

  @override
  State<AdminCreateProductPage> createState() => _AdminCreateProductPageState();
}

class _AdminCreateProductPageState extends State<AdminCreateProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String _selectedCategory = '';
  final ImagePicker _imagePicker = ImagePicker();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categoriesList[0].id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SharedTextFormField(
                  controller: _nameController,
                  label: 'Name',
                ),
                const SizedBox(height: 20),
                SharedTextFormField(
                  controller: _descriptionController,
                  label: 'Description',
                ),
                const SizedBox(height: 20),
                SharedNumericTextFormField(
                  controller: _priceController,
                  label: 'Price',
                ),
                const SizedBox(height: 20),
                SharedNumericTextFormField(
                  controller: _quantityController,
                  label: 'Quantity',
                ),
                const SizedBox(height: 20),
                buildSelectCategory(),
                const SizedBox(height: 20),
                uploadImage(),
                const SizedBox(height: 10),
                Text(
                  _pickedImage == null ? 'No image selected' : 'Image selected',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectCategory() {
    return DropdownButtonFormField(
      value: _selectedCategory,
      items: widget.categoriesList
          .map(
            (category) => DropdownMenuItem(
              value: category.id,
              child: categoryItem(category),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget uploadImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 8,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      child: InkWell(
        onTap: () {
          _showImageSourceDialog();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_file,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 10),
            Text(
              'Upload Image',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose photo source'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(source: source);
    if (image == null) {
      return;
    }
    setState(() {
      _pickedImage = File(image.path);
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
    print(_pickedImage!.path);
  }

  Widget categoryItem(CategoryModel category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(category.name),
        const SizedBox(width: 10),
        Icon(
          IconData(
            category.iconCode,
            fontFamily: 'MaterialIcons',
          ),
        )
      ],
    );
  }
}
