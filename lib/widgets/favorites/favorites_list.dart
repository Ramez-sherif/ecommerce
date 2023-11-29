import 'package:ecommerce/pages/item_details_page.dart';
import 'package:flutter/material.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // padding: const EdgeInsets.symmetric(horizontal: 5),
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: List.generate(
            5,
            (index) => _buildProductItem(context),
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context) {
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: ItemDetailsPage(),
              ),
            ),
          );
        },
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.0, // Adjust the aspect ratio as needed
                  child: Image.asset(
                    'assets/product.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text(
                'Product Name \n\$1500',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
