import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SharedNumericTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const SharedNumericTextFormField({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
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

        // Check if the input is a valid double
        if (double.tryParse(value) == null) {
          return 'Please enter a valid $label';
        }

        return null;
      },
    );
  }
}
