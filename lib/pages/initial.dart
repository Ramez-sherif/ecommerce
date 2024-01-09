import 'dart:developer';

import 'package:ecommerce/pages/admin/home.dart';
import 'package:ecommerce/pages/favorites.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/fcm.dart';
import 'package:ecommerce/services/local_database/fav.dart';
import 'package:ecommerce/services/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  bool isLoggedIn = false;
  bool isNet = true;

  Future checkLogin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      isLoggedIn = false;
      log('User is currently signed out!');
    } else {
      log('User is signed in!');
      isLoggedIn = true;
      if (await checkInternetConnectivity() == false) {
        isNet = false;
        context.read<UserProvider>().user = user;
        return;
      }
      await context.read<UserProvider>().setUser(user);
      await FCMService.setFCMToken(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.green),
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
            // ignore: avoid_print
            print('isLoggedIn: $isLoggedIn');
            if (isLoggedIn) {
              if (isNet == false) {
                return FavoritesPage();
              } else {
                if (context.watch<UserProvider>().user_role == 'admin') {
                  return const AdminHomePage();
                } else {
                  return HomePage();
                }
              }
            } else {
              return const LoginPage();
            }
          }
        }
      },
    );
  }
}
