// ignore_for_file: non_constant_identifier_names

import 'package:ecommerce/models/response.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupService {
  static Future<ResponseModel> signup(
    String user_email,
    String user_password,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user_email,
        password: user_password,
      );

      return ResponseModel(
        status: true,
        message: 'User created successfully',
        data: credential.user,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ResponseModel(
          status: false,
          message: 'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        return ResponseModel(
          status: false,
          message: 'The account already exists for that email.',
        );
      } else {
        return ResponseModel(
          status: false,
          message: e.message ?? 'Something went wrong',
        );
      }
    }
  }
}
