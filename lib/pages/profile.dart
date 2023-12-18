import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/services/profile.dart';
import 'package:flutter/material.dart';
import 'orders.dart';
// ignore_for_file: file_names, camel_case_types, avoid_print, non_constant_identifier_names

import 'package:ecommerce/models/response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ecommerce/services/signin.dart'; // Import the SignInService
import 'dart:developer'; // Import the dart:developer library
import 'orders.dart';

final SignInService signInService = SignInService();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newValueController = TextEditingController();
  String _phoneNumber = SignInService.getCurrentUser()?.phoneNumber ?? '90';
  String _location = "abasseya";

  bool _passwordError = false;

  @override
  Widget build(BuildContext context) {
    // Get the current user from SignInService
    User? currentUser = SignInService.getCurrentUser();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Personal Info"),
                _buildProfileItem("Username", currentUser?.displayName ?? ""),
                _buildProfileItem("Email", currentUser?.email ?? ""),
                _buildProfileItemWithEditButtonPhone("Phone Number",_phoneNumber),
                _buildProfileItemWithEditButtonLoc("Location", _location),
                _buildSectionDivider(),
                _buildSectionTitle("Orders Tracking"),
                _buildFullWidthButton("Your Orders", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderPage()),
                  );
                }),
                _buildSectionDivider(),
                _buildPasswordSection(),

                // Logout button
                ElevatedButton(
                  onPressed: () {
                    _handleLogout();
                  },
                  child: Text("Logout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color.fromARGB(255, 83, 31, 107),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItemWithEditButtonLoc(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  value = _location;
                  _showEditDialogLoc(value);
                },
                child: Text("Edit"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItemWithEditButtonPhone(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  value = _phoneNumber;
                  _showEditDialog(value);
                },
                child: Text("Edit"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialogLoc(String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit location"),
          content: TextField(
            controller: _newValueController,
            decoration: InputDecoration(
              hintText: "Enter new location",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  _location = _newValueController.text;
                  value = _location;
                  print(value);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Phone Number"),
          content: TextField(
            controller: _newValueController,
            decoration: InputDecoration(
              hintText: "Enter new phone number",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  //save _newValueController.text in the var:number in the DB , 
                  //if there's no var called number create one for this document
                  _phoneNumber = _newValueController.text;
                  value = _phoneNumber;
                  print(value);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionDivider() {
    return Divider(
      color: Colors.grey,
      thickness: 1,
      height: 16,
    );
  }

  Widget _buildFullWidthButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return states.contains(MaterialState.pressed)
                  ? Color.fromARGB(255, 83, 31, 107)
                  : Color.fromARGB(255, 240, 215, 254);
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return states.contains(MaterialState.pressed)
                  ? Color.fromARGB(255, 240, 215, 254)
                  : Color.fromARGB(255, 83, 31, 107);
            },
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Change Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color.fromARGB(255, 83, 31, 107),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _currentPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Current Password",
            errorText: _passwordError ? "Incorrect password" : null,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "New Password",
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            _changePassword();
          },
          child: Text("Change Password"),
        ),
      ],
    );
  }

  void _changePassword() {
    // Add logic to check if the current password is correct
    bool isCurrentPasswordCorrect = true; // Replace with your authentication logic

    if (isCurrentPasswordCorrect && _newPasswordController.text.isNotEmpty) {
      // Password change successful
      setState(() {
        _passwordError = false;
        _currentPasswordController.text = "";
        _newPasswordController.text = "";
      });

      // Add logic to update the password in the backend
    } else {
      // Incorrect current password or new password not provided
      setState(() {
        _passwordError = true;
      });
    }
  }

  // Logout function
  void _handleLogout() async {
    await SignInService.signOut();
    // Add additional logic after logout if needed
      Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()), // Replace 'LoginPage' with the actual login page class
  );
  }
}

