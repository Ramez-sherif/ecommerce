import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider package for state management
import 'package:ecommerce/models/product.dart'; // Product model
import 'package:ecommerce/models/review.dart'; // Review model
import 'package:ecommerce/models/user.dart'; // User model
import 'package:ecommerce/providers/home.dart'; // Provider for home-related state
import 'package:ecommerce/providers/user.dart'; // Provider for user-related state
import 'package:ecommerce/services/review.dart'; // Service handling reviews
import 'package:ecommerce/services/user.dart'; // Service handling user-related functionalities
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Flutter rating bar widget

// StatefulWidget for managing state in the product review page
class ProductReviewPage extends StatefulWidget {
  final ProductModel product; // Product to review

  // Constructor for the ProductReviewPage widget
  const ProductReviewPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

// State class associated with the ProductReviewPage widget
class _ProductReviewPageState extends State<ProductReviewPage> {
  final TextEditingController _ratingController =
      TextEditingController(); // Controller for rating input
  final TextEditingController _commentController =
      TextEditingController(); // Controller for comment input
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Form key to validate the form
  double selectedRating = 3; // Initialize with a default value for the rating

  @override
  Widget build(BuildContext context) {
    // Retrieve the user ID using Provider
    String userId = context.read<UserProvider>().user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Reviews'), // App bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                    labelText: 'Enter your comment'), // Input field for comment
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your comment'; // Validation error message
                  }
                  return null; // Return null for no validation error
                },
              ),

              const SizedBox(height: 10),
              const Text(
                'Choose your rating:', // Label for the rating selection
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Rating bar widget for selecting the rating
              RatingBar.builder(
                initialRating: selectedRating,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, index) {
                  switch (index) {
                    // Icons representing different rating levels
                    // Each icon represents a different level of satisfaction
                    // Icons change color based on the selected rating
                    case 0:
                      return const Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return const Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return const Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return const Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                    default:
                      return Container();
                  }
                },
                // Callback when the rating is updated
                onRatingUpdate: (rating) {
                  setState(() {
                    selectedRating = rating;
                  });
                },
              ),
              const SizedBox(height: 8),
              // Submit button for submitting the review
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String comment =
                        _commentController.text; // Retrieve the entered comment
                    // Add a new review for the product
                    await ReviewService.addReview(
                      selectedRating.toInt(), // Convert selectedRating to int
                      userId, // Current user ID
                      widget.product.id, // ID of the reviewed product
                      comment, // Comment provided by the user
                    );
                    // Calculate new rating for the product based on the added review
                    double newRating = 0;

                    if (widget.product.rating == 0) {
                      newRating = selectedRating.toDouble();
                    } else {
                      newRating = (widget.product.rating + selectedRating) / 2;
                    }
                    // Update the product's rating using ReviewService
                    await ReviewService.updateReview(
                      widget.product.id, // ID of the reviewed product
                      newRating, // Updated rating value
                    );
                    // Update the rating of the product in the HomeProvider
                    if (context.mounted) {
                      context
                          .read<HomeProvider>()
                          .allProducts
                          .where((element) {
                            return element.id == widget.product.id;
                          })
                          .first
                          .rating = newRating;
                    }

                    _ratingController.clear(); // Clear the rating controller
                    if (context.mounted) {
                      Navigator.pop(context); // Close the current page
                      Navigator.pop(context);
                    }
                  }
                }, // Button text
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green), // Change button background color to green
                ),
                child: const Text('Submit Rating'),
              ),

              // FutureBuilder to display reviews for the product
              FutureBuilder<List<Review>>(
                future: ReviewService.getAllReviews(
                    widget.product.id), // Fetch all reviews for the product
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Display loading indicator while waiting for data
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Error: ${snapshot.error}')); // Display error message if there's an error
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // If there are reviews available, display them in a ListView
                    List<Review> reviews = snapshot.data as List<Review>;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          Review review = reviews[index];
                          // Display details of each review (username, comment, and rating)
                          return FutureBuilder<UserModel>(
                            future: UserService.getUserDetails(review
                                .userid), // Fetch user details based on user ID in the review
                            builder: (context, userSnapshot) {
                              if (userSnapshot.hasData) {
                                UserModel user = userSnapshot.data!;
                                // Display user details and review information in a ListTile
                                return ListTile(
                                  title: Text('User Name: ${user.username}'),
                                  subtitle: Text('Comment: ${review.comment}'),
                                  trailing:
                                      Text('Rate: ${review.rating.toString()}'),
                                );
                              } else {
                                // If user details are not found, display a placeholder
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
                    return const Center(
                        child: Text(
                            'No reviews available.')); // Display a message when there are no reviews
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
