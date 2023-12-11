import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  bool loading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('================User is currently signed out!========');
        setState(() {
          loading = false;
          isLoggedIn = false;
        });
      } else {
        // TODO: set user data in provider
        print('================User is signed in!================');
        print(user.uid);
        setState(() {
          loading = false;
          isLoggedIn = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : isLoggedIn
            ? const HomePage()
            : const LoginPage();
  }
}
