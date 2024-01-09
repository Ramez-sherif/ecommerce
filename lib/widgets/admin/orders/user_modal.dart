import 'package:ecommerce/models/user.dart';
import 'package:flutter/material.dart';

class UserDetailsModal extends StatelessWidget {
  final UserModel user;

  const UserDetailsModal({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color themeColor = Theme.of(context).colorScheme.onPrimary;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email: ${user.email}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            thickness: 2,
            color: themeColor,
          ),
          Text(
            'Username: ${user.username}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          Divider(
            thickness: 2,
            color: themeColor,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Number: ${user.number}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          Divider(
            thickness: 2,
            color: themeColor,
          ),
          const SizedBox(height: 8),
          Text(
            'Location: ${user.location}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
        ],
      ),
    );
  }
}
