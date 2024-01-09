import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final String id;
  final String name;

  StatusModel({
    required this.name,
    required this.id,
  });

  factory StatusModel.fromFireStore(
    QueryDocumentSnapshot<Map<String, dynamic>> data,
  ) {
    return StatusModel(
      id: data.id,
      name: data["name"],
    );
  }
}
