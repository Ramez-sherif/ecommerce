import 'package:flutter/material.dart';
import 'orders.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _passwordError = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Personal Info"),
                _buildProfileItem("Username", "JohnDoe"),
                _buildProfileItem("Email", "johndoe@example.com"),
                _buildProfileItemWithEditButton("Phone Number", "123-456-7890"),
                _buildProfileItemWithEditButton(
                    "Location", "**** **** **** 1234 - New York"),
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
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.green,
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

  Widget _buildProfileItemWithEditButton(String label, String value) {
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
                  // Add functionality to edit the item
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

  Widget _buildSectionDivider() {
    return Divider(
      color: Theme.of(context).colorScheme.secondary,
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
            fontSize: 25,
            color: Colors.green,
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
    bool isCurrentPasswordCorrect =
        true; // Replace with your authentication logic

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
}
