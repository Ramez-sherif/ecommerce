// ignore_for_file: non_constant_identifier_names

import 'package:ecommerce/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late User user;
  String user_role = '';

  Future<void> setUser(User user) async {
    this.user = user;
    user_role = await UserService.getUserRole(user.uid);
    notifyListeners();
  }

  Future removeUser() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
