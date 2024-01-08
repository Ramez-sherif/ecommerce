import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user.dart';

class MessageModel {
  const MessageModel(
      {required this.message, required this.sender, required this.date});
  final String message;
  final UserModel sender;
  final Timestamp date;

    factory MessageModel.fromJson(Map<String, dynamic> json,UserModel user) {
    return MessageModel(
      message: json['text'] ?? '',
      date: json['date'] as Timestamp,
      sender: user
    );
  }
}
