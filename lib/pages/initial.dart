import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  late Future<bool> _loginCheck;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loginCheck = _checkLogin();
  }

  Future<bool> _checkLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        context.read<UserProvider>().setUser(user);
        isLoggedIn = true;
      }
    });
    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loginCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            print('isLoggedIn: $isLoggedIn');
            if (isLoggedIn) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          }
        }
      },
    );
  }
}
