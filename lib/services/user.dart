import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static var db = FirebaseFirestore.instance;

  /// This method is used to set the user role in the database when the user signs up.
  ///
  /// It takes the user object as [User] and the role as parameters.
  ///
  static Future setUserRole(User user, String role) async {
    await db.collection('users').doc(user.uid).get().then((value) => {
          if (value.exists)
            {
              // user already exists
              // do nothing
            }
          else
            {
              db.collection('users').doc(user.uid).set({
                'role': role,
              })
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
}
