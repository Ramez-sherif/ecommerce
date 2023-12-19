import 'package:ecommerce/providers/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationProfileWidget extends StatefulWidget {
  const LocationProfileWidget({ Key? key }) : super(key: key);

  @override
  _LocationProfileWidgetState createState() => _LocationProfileWidgetState();
}

class _LocationProfileWidgetState extends State<LocationProfileWidget> {
  TextEditingController LocationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    LocationController.text =
        context.read<ProfileProvider>().userProfile!.location!;
  }
  @override
    void dispose() {
    LocationController.dispose();
    super.dispose();
  }

  updateGeoLocation() {
    // for close keyboard
    FocusScope.of(context).unfocus();
    
    if (LocationController.text.isNotEmpty) {
      context.read<ProfileProvider>().updateGeoLocation(LocationController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location updated'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid location'),
        ),
      );
    }
  }


 Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintText: 'Location',
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
              keyboardType: TextInputType.text,
              decoration: inputDecoration,
              controller: LocationController,
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: updateGeoLocation,
              icon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}