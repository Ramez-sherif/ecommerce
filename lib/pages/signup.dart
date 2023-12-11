// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerce/models/response.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/initial.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/services/signup.dart';
import 'package:ecommerce/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController userEmail = TextEditingController();
    final TextEditingController userPassword = TextEditingController();

    GlobalKey<FormState> formState = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: formState,
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
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userEmail,
                      decoration: InputDecoration(
                        hintText: 'Email ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // make shadow
                        filled: true,
                        fillColor: Colors.grey[300],
                        // add prefix icon
                        prefixIcon: const Icon(Icons.person),
                        // add shadow
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
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
                        fillColor: Colors.grey[300],
                        // add prefix icon
                        prefixIcon: const Icon(Icons.lock),
                        // add shadow
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // make shadow
                        filled: true,
                        fillColor: Colors.grey[300],
                        // add prefix icon
                        prefixIcon: const Icon(Icons.lock),
                        // add shadow
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          // if the form is valid
                          ResponseModel response = await SignupService.signup(
                            userEmail.text,
                            userPassword.text,
                          );

                          if (response.status) {
                            // if the signup is successful
                            // set the user role
                            await UserService.setUserRole(
                              response.data as User,
                              'user',
                            );
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.success,
                              title: 'Success',
                              desc: response.message,
                              btnOkOnPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const InitialPage(),
                                  ),
                                );
                              },
                            ).show();
                          } else {
                            // if the signup is not successful
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.error,
                              title: 'Error',
                              desc: response.message,
                            ).show();
                          }
                        } else {
                          // if the form is not valid
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.rightSlide,
                            dialogType: DialogType.error,
                            title: 'Error',
                            desc: 'Please enter valid data',
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
                        'Signup',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
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
                        'Already have an account? Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
