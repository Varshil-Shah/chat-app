import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final Timestamp createdAt;
  final String senderId;

  Message({
    required this.createdAt,
    required this.message,
    required this.senderId,
  });
}
