import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductReviewPage extends StatefulWidget {
  final ProductModel product;
  const ProductReviewPage({super.key, required this.product});
  @override
  _ProductReviewPageState createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  final TextEditingController _ratingController = TextEditingController();
  String rating2 = "";
  @override
  Widget build(BuildContext context) {
    String userId = context.read<UserProvider>().user.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _ratingController,
              onChanged: (value) => rating2 = value,
              decoration: const InputDecoration(labelText: 'Your Rating (1-5)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                int rating = int.parse(rating2);
                if (rating > 0 && rating <= 5) {
                  await ReviewService.addReview(
                      rating, userId, widget.product.id);
                  double newRating = (widget.product.rating + rating) / 2;
                  await ReviewService.updateReview(
                      widget.product.id, newRating);
                  context
                      .read<HomeProvider>()
                      .allProducts
                      .where((element) {
                        return element.id == widget.product.id;
                      })
                      .first
                      .rating = newRating;

                  _ratingController.clear();
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid rating'),
                    ),
                  );
                }
              },
              child: const Text('Submit Rating'),
            ),
            // ListView.builder(
            //   itemCount: items.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return ListTile(
            //       title:
            //           Text(items[index]),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
