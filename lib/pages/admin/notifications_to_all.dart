// ignore_for_file: use_build_context_synchronously

import 'package:ecommerce/services/fcm.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SendNotificationsToAllPage extends StatefulWidget {
  const SendNotificationsToAllPage({Key? key}) : super(key: key);

  @override
  State<SendNotificationsToAllPage> createState() =>
      _SendNotificationsToAllPageState();
}

class _SendNotificationsToAllPageState
    extends State<SendNotificationsToAllPage> {
  TextEditingController titleController = TextEditingController();

  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Send Notifications to All'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                  minLines: 1,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                    hintText: 'Body',
                  ),
                  minLines: 1,
                  maxLines: 9,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: sendNotificationToAll,
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16,
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

  void sendNotificationToAll() async {
    // 1. close keyboard
    FocusScope.of(context).unfocus();
    // 2. validate title and body is not empty
    if (!validate()) return;
    // 3. show loading indicator
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // 4. get all fcm tokens
    List<String> tokens = await FCMService.getAllFCMTokens();
    // 5. send notification to all users
    for (var token in tokens) {
      await FCMService.sendNotification(
        token,
        titleController.text,
        bodyController.text,
      );
    }
    // 6. close loading indicator
    Navigator.pop(context);
    // 7. show snackbar
    showSnckbar(context);
  }

  void showSnckbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification sent successfully'),
      ),
    );
  }

  // make method to validate title and body is not empty and return true or false
  bool validate() {
    if (titleController.text.isEmpty || bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter title and body'),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
