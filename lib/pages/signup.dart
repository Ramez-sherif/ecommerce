// ignore_for_file: prefer_const_constructors

import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  'E-Commerce',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome to our store',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Username , Email & Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // make shadow
                      filled: true,
                      fillColor: Colors.grey[300],
                      // add prefix icon
                      prefixIcon: Icon(Icons.person),
                      // add shadow
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
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
                      prefixIcon: Icon(Icons.lock),
                      // add shadow
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // confirm password
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
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
                      prefixIcon: Icon(Icons.lock),
                      // add shadow
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Or sign up with social account'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/google.png'),
                      backgroundColor: Colors.white,
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/facebook.png'),
                      backgroundColor: Colors.white,
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/apple.png'),
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
