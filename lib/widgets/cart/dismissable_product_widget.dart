import "package:ecommerce/widgets/cart/product_widget.dart";
import "package:flutter/material.dart";

class DismissableProductWidget extends StatelessWidget {
  const DismissableProductWidget(
      {super.key, required this.products, required this.index});
  final List<dynamic> products;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: Key(products[index]['description']),
          direction: DismissDirection.horizontal,
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 9),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 254, 193, 189), Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
            child: const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 255, 0, 0),
            ),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(vertical: 9),
            padding: const EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 254, 193, 189), Colors.white],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft)),
            child: const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 255, 0, 0),
            ),
          ),
          onDismissed: (direction) {
            //delete from database
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${products[index]['description']} dismissed'),
              ),
            );

            products.removeAt(index);
          },
          child: ProductWidget(
            imagePath: products[index]['imagePath'],
            description: products[index]['description'],
            price: products[index]['price'].toDouble(),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
      ],
    );
  }
}
