// import 'package:flutter/material.dart';

// class ProductsGrid extends StatelessWidget {
//   const ProductsGrid({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GridView.count(
//         crossAxisCount: 2,
//         physics: const BouncingScrollPhysics(),
//         children: List.generate(
//           10,
//           (index) => _buildProductItem(),
//         ),
//       ),
//     );
//   }

//   // ...

//   Widget _buildProductItem() {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 1,
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 child: IconButton(
//                   onPressed: () {},
//                   icon: const Icon(
//                     Icons.favorite,
//                     color: Colors.red,
//                   ),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: Container(
//               child: FittedBox(
//                 fit: BoxFit.cover,
//                 child: Image.network(
//                   'https://m.media-amazon.com/images/I/715fCdexyJL.__AC_SX300_SY300_QL70_ML2_.jpg',
//                 ),
//               ),
//             ),
//           ),
//           const Text(
//             'Product Name \n\$1500',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: non_constant_identifier_names

import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/item_details_page.dart';
import 'package:flutter/material.dart';

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;
  const ProductsGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          physics: const BouncingScrollPhysics(),
          children: [
            ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductItem(context, products[index]);
              },
            ),
          ]),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Expanded(
  //     child: ListView.builder(
  //       itemCount: products.length,
  //       padding: const EdgeInsets.symmetric(horizontal: 5),
  //       physics: const BouncingScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         return _buildProductItem(context, products[index]);
  //       },
  //     ),
  //   );
  // }

  Widget _buildProductItem(BuildContext context, ProductModel product) {
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
          padding: const EdgeInsets.all(5),
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
                  child: Image.network(
                    product.image_URL,
                    fit: BoxFit.cover,
                    // width: 50,
                    // height: 50,
                  ),
                ),
              ),
              Text(
                '${product.name} \n\$${product.price}',
                style: const TextStyle(
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
