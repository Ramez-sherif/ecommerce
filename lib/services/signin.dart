// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, non_constant_identifier_names

import 'dart:developer';
import 'package:ecommerce/models/response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

      // Obtain the auth details from the selected account

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

  // static User? getCurrentUser() {
  //   try {
  //     final User? firebaseUser = FirebaseAuth.instance.currentUser;
  //     return firebaseUser;
  //   } catch (e) {
  //     log('Error getting current user: $e');
  //     return null;
  //   }
  // }
}
