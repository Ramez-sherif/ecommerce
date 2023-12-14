import 'package:ecommerce/pages/all_products.dart';
import 'package:ecommerce/pages/cart_view.dart';
import 'package:ecommerce/pages/favorites.dart';
import 'package:ecommerce/pages/profile.dart';
import 'package:ecommerce/pages/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int currentTab = 2;
  final List<Widget> screens = [
    const ProfilePage(),
    const SettingsPage(),
    const AllProductsPage(),
    FavoritesPage(),
    CartPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const AllProductsPage();

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  SafeArea buildUI() {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _updateScreen(2, const AllProductsPage());
          },
          child: Icon(
            Icons.home,
            color: _getColor(2),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _createItemBar(Icons.person, 0, 'Profile'),
                    _createItemBar(Icons.settings, 1, 'Settings'),
                  ],
                ),
                Row(
                  children: [
                    _createItemBar(Icons.favorite, 3, 'Favorites'),
                    _createItemBar(Icons.shopping_cart, 4, 'Cart'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createItemBar(IconData icon, int index, String text) {
    return MaterialButton(
      splashColor: Colors.transparent,
      minWidth: 40,
      onPressed: () {
        _updateScreen(index, screens[index]);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _getColor(index)),
          Text(
            text,
            style: TextStyle(
              color: _getColor(index),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    return currentTab == index ? Colors.green : Colors.grey;
  }

  void _updateScreen(int index, Widget screen) {
    setState(() {
      currentScreen = screen;
      currentTab = index;
    });
  }
}
