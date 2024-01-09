import 'package:ecommerce/pages/initial.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/providers/theme.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/colud_messaging.dart';
import 'package:ecommerce/themes/dark_theme.dart';
import 'package:ecommerce/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await CloudMessaging().initNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce App',
      themeMode: context.watch<ThemeProvider>().themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const InitialPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
