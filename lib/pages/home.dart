import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  final List<Widget> screens = [
    const Text('Profile'),
    const Text('Search'),
    const Text('Home'),
    const Text('Favorites'),
    const Text('Cart'),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Text('Home');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _updateScreen(2, const Text('Home'));
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
                    _createItemBar(Icons.search, 1, 'Search'),
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
