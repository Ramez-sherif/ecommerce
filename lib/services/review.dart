import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/review.dart';
import 'package:ecommerce/services/collections_config.dart';

class ReviewService {
  static var db = FirebaseFirestore.instance;
  static Future addReview(int rate, String userId, String prodcutId) async {
    await db.collection(CollectionConfig.reviews).doc().set({
      "rate": rate,
      "userId": userId,
      "prodcut_id": prodcutId,
    });
  }

  static Future updateReview(String productId, double newRate) async {
    await db.collection(CollectionConfig.products).doc(productId).set({
      "rating": newRate,
    }, SetOptions(merge: true));
  }

  static Future<List<Review>> getAllReviews(String productId) async {
    List<Review> reviews = [];

    await db
        .collection(CollectionConfig.reviews)
        .where("prodcut_id", isEqualTo: productId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        Review review = Review(
            userid: doc.data()["userId"],
            rating: doc.data()["rate"].toDouble());
        reviews.add(review);
      }
    });

    return reviews;
  }
}
