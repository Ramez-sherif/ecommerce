// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AdminStoragePage extends StatefulWidget {
  const AdminStoragePage({super.key});

  @override
  State<AdminStoragePage> createState() => _AdminStoragePageState();
}

class _AdminStoragePageState extends State<AdminStoragePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Products',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
