import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends  State<MyApp>{
@override
  void initState() {
   FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('================User is currently signed out!');
    } else {
      print('================User is signed in!');
      print (user.uid);
    }
  });
    super.initState();
  }

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home:FirebaseAuth.instance.currentUser == null? SplashScreen():HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
  
}
  

