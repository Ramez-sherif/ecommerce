import 'dart:developer';
import 'package:ecommerce/models/response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ecommerce/models/user.dart' as userModel; // Import the user model
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<ResponseModel> signInWithEmail(
    String user_email,
    String user_password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user_email,
        password: user_password,
      );
      return ResponseModel(
        status: true,
        message: "Login Successful",
        data: credential.user,
      );
    } on FirebaseAuthException catch (e) {
      return ResponseModel(
        status: false,
        message: e.code,
      );
    }
  }

  static Future<ResponseModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return ResponseModel(
          status: false,
          message: "Login Cancelled",
        );
      }

      if (await GoogleSignIn().signInSilently() != null) {
        await GoogleSignIn().signOut();
      }

      final GoogleSignInAccount? selectedAccount =
          await GoogleSignIn().signIn();

      if (selectedAccount == null) {
        return ResponseModel(
          status: false,
          message: "Login Cancelled",
        );
      }

      final GoogleSignInAuthentication? googleAuth =
          await selectedAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential user = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      return ResponseModel(
        status: true,
        message: "Login Successful",
        data: user.user,
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        message: "An unexpected error occurred",
      );
    }
  }

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      log('User signed out successfully');
    } catch (e) {
      log('Error signing out: $e');
    }
  }

  static User? getCurrentUser() {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      return firebaseUser;
    } catch (e) {
      log('Error getting current user: $e');
      return null;
    }
  }

  static Future<userModel.User?> getCurrentUserDetails() async {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        return userModel.User.fromFirestore(snapshot);
      } else {
        return null;
      }
    } catch (e) {
      log('Error getting current user details: $e');
      return null;
    }
  }
}
