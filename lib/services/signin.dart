// ignore_for_file: file_names, camel_case_types, avoid_print, non_constant_identifier_names

import 'package:ecommerce/models/response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInService {
  /// Sign in with email and password
  /// Returns a [ResponseModel] object
  /// If the login is successful, the [ResponseModel] object will contain the [User] object
  /// If the login is unsuccessful, the [ResponseModel] object will contain the error code
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

  /// Sign in with Google account
  ///
  /// Returns a [ResponseModel] object
  ///
  /// If the login is successful, the [ResponseModel] object will contain the [User] object
  ///
  /// If the login is unsuccessful, the [ResponseModel] object will contain the error code
  ///
  /// If the login is cancelled, the [ResponseModel] object will contain the message "Login Cancelled"
  ///
  /// If an unexpected error occurs, the [ResponseModel] object will contain the message "An unexpected error occurred"
  static Future<ResponseModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the login
        return ResponseModel(
          status: false,
          message: "Login Cancelled",
        );
      }

      // Prompt the user to choose an account if there are multiple accounts
      if (await GoogleSignIn().signInSilently() != null) {
        await GoogleSignIn().signOut();
      }

      final GoogleSignInAccount? selectedAccount =
          await GoogleSignIn().signIn();

      if (selectedAccount == null) {
        // User canceled the login
        return ResponseModel(
          status: false,
          message: "Login Cancelled",
        );
      }

      // Obtain the auth details from the selected account
      final GoogleSignInAuthentication? googleAuth =
          await selectedAccount.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential user = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      return ResponseModel(
        status: true,
        message: "Login Successful",
        data: user.user, // Return the User object
      );
    } catch (e) {
      return ResponseModel(
        status: false,
        message: "An unexpected error occurred",
      );
    }
  }
}
