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

class _InitialPageState extends State<InitialPage> with WidgetsBindingObserver {
  bool loading = true;
  bool isLoggedIn = false;
  late final UserProvider userProvider;
  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    WidgetsBinding.instance.addObserver(this);

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          loading = false;
          isLoggedIn = false;
        });
      } else {
        userProvider.setUser(user);
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
