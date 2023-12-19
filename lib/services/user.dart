import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static var db = FirebaseFirestore.instance;

  /// This method is used to set the user role in the database when the user signs up.
  ///
  /// It takes the user object as [User] and the role as parameters.
  ///
  static Future setUser(User user) async {
    UserModel newUser = UserModel.createEmptyUser(user.uid, user.email!);

    await db.collection('users').doc(user.uid).get().then((value) => {
          if (!value.exists)
            {
              db.collection('users').doc(user.uid).set(
                    newUser.toMap(),
                  )
            }
        });
  }

  /// This method is used to get the user role from the database.
  ///
  /// It takes the user id as [String] and returns the role as [String].
  ///
  static Future<String> getUserRole(String uid) async {
    var data = await db.collection('users').doc(uid).get();
    return data['role'];
  }

  static Future<UserModel> getUserDetails(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      return UserModel.fromFirestore(snapshot);
    } catch (e) {
      log('Error getting current user details: $e');
      return UserModel.createEmptyUser('', '');
    }
  }
}
