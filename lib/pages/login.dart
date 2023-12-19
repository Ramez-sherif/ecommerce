// ignore_for_file: use_build_context_synchronously
import 'package:ecommerce/models/response.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/signup.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/signin.dart';
import 'package:ecommerce/services/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController userEmail = TextEditingController();
    final TextEditingController userPassword = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Theme.of(context).colorScheme.background, //!Login page color
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Egyzona',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to Egyzona',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                emailBox(userEmail),
                const SizedBox(height: 10),
                passwordBox(userPassword),
                const SizedBox(height: 20),
                emailLoginButton(userEmail, userPassword, context),
                const SizedBox(height: 20),
                signupButton(context),
                const SizedBox(height: 20),
                const Text('Or sign in with social account'),
                const SizedBox(height: 20),
                googleLogin(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell googleLogin(BuildContext context) {
    return InkWell(
      onTap: () async {
        ResponseModel response = await SignInService.signInWithGoogle();

        if (response.status) {
          // Login successful
          User user = response.data;
          context.read<UserProvider>().setUser(user);
          await UserService.setUser(
            response.data as User,
          );

          try {
            String role = await UserService.getUserRole(user.uid);

            if (role == 'admin') {
              // Navigate to the admin page
              // Add your code here to navigate to the admin page
            } else {
              // Navigate to the home page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            }
          } catch (e) {
            // ignore: avoid_print
            print("Error getting user role: $e");
            // Handle the error, you may want to log it or show an appropriate message
          }
        } else {
          // Show an error dialog
          AwesomeDialog(
            context: context,
            animType: AnimType.rightSlide,
            dialogType: DialogType.error,
            title: 'Error',
            desc: response.message,
          ).show();
        }
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: Image.asset('assets/google.png'),
      ),
    );
  }

  Container signupButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container emailLoginButton(
    TextEditingController userEmail,
    TextEditingController userPassword,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          bool validation = validate(
            userEmail.text,
            userPassword.text,
            context,
          );
          if (!validation) {
            return;
          }
          ResponseModel response = await SignInService.signInWithEmail(
            userEmail.text,
            userPassword.text,
          );

          if (response.status) {
            User user = response.data;
            context.read<UserProvider>().setUser(user);
            String role = await UserService.getUserRole(user.uid);
            // ignore: avoid_print
            print("role: $role");

            if (role == 'admin') {
              // go to admin page
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            }
          } else {
            AwesomeDialog(
              context: context,
              animType: AnimType.rightSlide,
              dialogType: DialogType.error,
              title: 'Error',
              desc: response.message,
            ).show();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container passwordBox(TextEditingController userPassword) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: userPassword,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // make shadow
          filled: true,
          fillColor: Theme.of(context)
              .colorScheme
              .secondary, //!222222222222222222222222
          // add prefix icon
          prefixIcon: const Icon(Icons.lock),
          // add shadow
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Container emailBox(TextEditingController userEmail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: userEmail,
        decoration: InputDecoration(
          hintText: 'Username , Email & Phone Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // make shadow
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          // add prefix icon
          prefixIcon: const Icon(Icons.person),
          // add shadow
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  bool validate(String userEmail, String userPassword, BuildContext context) {
    if (userEmail.isEmpty || userPassword.isEmpty) {
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Error',
        desc: 'Please enter email and password',
      ).show();
      return false;
    }
    return true;
  }
}
