import 'package:ecommerce/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:splash_view/splash_view.dart';
import 'payment.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashView(
      
      backgroundColor: const Color.fromARGB(255, 231, 231, 231),
      logo: Column(
        children: [
          Image.asset('assets/splash.png', height: 250.0), // Adjust height as needed
          SizedBox(height: 8.0),
          Column(
            children: [
              Text(
                'dream it.',
                style: TextStyle(color: Colors.black, fontSize: 24.0),
              ),
              Text(
                'tab it.',
                style: TextStyle(color: Colors.green, fontSize: 24.0),
              ),
              RichText(
                text: TextSpan(
                  text: 'splash into your ultimate ',
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                  children: [
                    TextSpan(
                      text: 'orders!',
                      style: TextStyle(color: Colors.green, fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
       
      duration: Duration(seconds: 10),
      loadingIndicator: RefreshProgressIndicator(),
      done: Done(
        HomePage(), 
         animationDuration: Duration(seconds: 2),
        curve: Curves.bounceOut,
        ),
    );
  }
}