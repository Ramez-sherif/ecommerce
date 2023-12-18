import 'package:ecommerce/providers/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneProfileWidget extends StatefulWidget {
  const PhoneProfileWidget({super.key});

  @override
  State<PhoneProfileWidget> createState() => _PhoneProfileWidgettState();
}

class _PhoneProfileWidgettState extends State<PhoneProfileWidget> {
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text =
        context.read<ProfileProvider>().userProfile!.phoneNumber!;
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  updatePhoneNumber() {
    // for close keyboard
    FocusScope.of(context).unfocus();

    
    if (phoneController.text.isNotEmpty && isNumeric(phoneController.text)) {
      context.read<ProfileProvider>().updatePhoneNumber(phoneController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number updated'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number'),
        ),
      );
    }
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintText: 'Phone Number',
      hintStyle: TextStyle(color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(15),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: inputDecoration,
              controller: phoneController,
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: updatePhoneNumber,
              icon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}
