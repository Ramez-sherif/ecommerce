import 'package:ecommerce/models/user.dart';

class Review {
  double rating;
  String comment;
  String userid;
  Review({required this.rating, required this.userid, required this.comment});
}
