import 'package:ecommerce/pages/admin/notifications_to_all.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  SafeArea buildBody(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Admin Home Page'),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () async {
                  await context.read<UserProvider>().removeUser();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SendNotificationsToAllPage(),
                    ),
                  );
                },
                child: const Text(
                  'Send notifications to all users',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
