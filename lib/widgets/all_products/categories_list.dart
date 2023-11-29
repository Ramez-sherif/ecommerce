import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key}) : super(key: key);

  // make a list of categories
  List<Widget> _buildCategories() {
    return [
      _buildCategoryItem(Icons.sports_soccer),
      _buildCategoryItem(Icons.car_rental),
      _buildCategoryItem(Icons.sports_basketball),
      _buildCategoryItem(Icons.sports_football),
      _buildCategoryItem(Icons.sports_baseball),
      _buildCategoryItem(Icons.sports_tennis),
      _buildCategoryItem(Icons.sports_volleyball),
      _buildCategoryItem(Icons.sports_rugby),
      _buildCategoryItem(Icons.sports_motorsports),
      _buildCategoryItem(Icons.sports_handball),
      _buildCategoryItem(Icons.sports_hockey),
      _buildCategoryItem(Icons.sports_cricket),
      _buildCategoryItem(Icons.sports_esports),
      _buildCategoryItem(Icons.sports_golf),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: _buildCategories(),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                icon,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
        ),
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
