import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  const MessageModel(
      {required this.message, required this.sender, required this.date,required this.name});
  final String message;
  final String sender;
  final Timestamp date;
  final String name;

    factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['text'] ?? '',
      date: json['date'] as Timestamp,
      sender: json["sender_id"],
      name: json["username"]
    );
  }
}
