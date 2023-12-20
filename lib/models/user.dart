import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/order.dart';

class UserModel {
  final String uid;
  final String email;
  String username;
  String number;
  String location;
  final String role;

  UserModel({
    required this.email,
    required this.uid,
    required this.username,
    required this.number,
    required this.location,
    required this.role,
  });

  String? get phoneNumber => number;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
      'username': username,
      'number': number,
      'location': location,
      'role': role,
    };
  }

  factory UserModel.createEmptyUser(String uid, String email) {
    return UserModel(
      uid: uid,
      email: email,
      username: email.split('@')[0],
      number: '',
      location: '',
      role: 'user',
    );
  }
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;

   



    return UserModel(
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      number: data['number'],
      location: data['location'],
      role: data['role'],
    );
  }
}
