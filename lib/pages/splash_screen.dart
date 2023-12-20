import 'package:ecommerce/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:splash_view/splash_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashView(
      backgroundColor: Theme.of(context).colorScheme.background,
      logo: Column(
        children: [
          Image.asset('assets/splash.png', height: 250.0),
          const SizedBox(height: 8.0),
          const Text(
            'Egyzona',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 4),
      loadingIndicator: const RefreshProgressIndicator(),
      done: Done(
        const LoginPage(),
        animationDuration: const Duration(seconds: 4),
        curve: Curves.bounceOut,
      ),
    );
  }
}
