import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/services/collections_config.dart';

class ReviewService {
  static var db = FirebaseFirestore.instance;
  static Future addReview(int rate, String userId, String prodcutId) async {
    print("in review service");
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

    List<dynamic> getAllReviews(String productId) {
      List<dynamic> reviews = List.empty();
      db
          .collection("reviews")
          .where("prodcutId", isEqualTo: productId)
          .get()
          .then((value) {
        for (var x in value.docs) {
          reviews.add(x.data());
        }
      });
      return reviews;
    }
  }
}
