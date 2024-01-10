import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AllProductsTopBarWidget extends StatefulWidget {
  final Function(String query) onQueryChanged;
  final TextEditingController searchController;

  const AllProductsTopBarWidget(
      {Key? key, required this.onQueryChanged, required this.searchController})
      : super(key: key);

  @override
  State<AllProductsTopBarWidget> createState() =>
      _AllProductsTopBarWidgetState();
}

class _AllProductsTopBarWidgetState extends State<AllProductsTopBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 6, child: _searchBar()),
          // const SizedBox(width: 8),
          // Expanded(flex: 1, child: _notificationButton()),
        ],
      ),
    );
  }

  void resetSearch() {
    widget.onQueryChanged('');
    widget.searchController.clear();
    FocusScope.of(context).unfocus();
  }

  Widget _searchBar() {
    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: Theme.of(context).colorScheme.primary,
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
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(15),
      ),
    );
    return TextField(
      decoration: inputDecoration,
      onChanged: widget.onQueryChanged,
      controller: widget.searchController,
    );
  }

  // ignore: unused_element
  Widget _notificationButton() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
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
