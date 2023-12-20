// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/review.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/review.dart';
import 'package:ecommerce/services/user.dart';

class ProductReviewPage extends StatefulWidget {
  final ProductModel product;

  const ProductReviewPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
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
                int rating = int.tryParse(rating2) ?? 0;

                if (rating > 0 && rating <= 5) {
                  await ReviewService.addReview(
                    rating,
                    userId,
                    widget.product.id,
                  );
                  double newRating = (widget.product.rating + rating) / 2;
                  await ReviewService.updateReview(
                    widget.product.id,
                    newRating,
                  );
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
                    SnackBar(
                      content: Text(
                        'Please enter a valid rating',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green), // Change button background color to green
              ),
              child: const Text('Submit Rating'),
            ),
            FutureBuilder<List<Review>>(
              future: ReviewService.getAllReviews(widget.product.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<Review> reviews = snapshot.data as List<Review>;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        Review review = reviews[index];
                        return FutureBuilder<UserModel>(
                          future: UserService.getUserDetails(review.userid),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData) {
                              UserModel user = userSnapshot.data!;
                              return ListTile(
                                title: Text('User Name: ${user.username}'),
                                subtitle:
                                    Text('Rate: ${review.rating.toString()}'),
                              );
                            } else {
                              return ListTile(
                                title: const Text('User ID: Not Found'),
                                subtitle:
                                    Text('Rate: ${review.rating.toString()}'),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No reviews available.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
