import 'package:ecommerce/providers/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllProductsTopBarWidget extends StatefulWidget {
  const AllProductsTopBarWidget({Key? key}) : super(key: key);

  @override
  State<AllProductsTopBarWidget> createState() =>
      _AllProductsTopBarWidgetState();
}

class _AllProductsTopBarWidgetState extends State<AllProductsTopBarWidget> {
  // ignore: prefer_final_fields
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 6, child: _searchBar()),
          const SizedBox(width: 8),
          Expanded(flex: 1, child: _notificationButton()),
        ],
      ),
    );
  }

  void onQueryChanged(String query) {
    context.read<HomeProvider>().searchProducts(query);
  }

  void resetSearch() {
    onQueryChanged('');
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  Widget _searchBar() {
    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintText: 'Search',
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: IconButton(
        onPressed: resetSearch,
        icon: const Icon(Icons.clear),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(15),
      ),
    );
    return TextField(
      decoration: inputDecoration,
      onChanged: onQueryChanged,
      controller: _searchController,
    );
  }

  Widget _notificationButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey[400]!),
        // borderRadius: BorderRadius.circular(50),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.notifications),
      ),
    );
  }
}
