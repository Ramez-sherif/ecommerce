import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late User user;

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  Future removeUser() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
