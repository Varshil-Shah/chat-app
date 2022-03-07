import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late final String? id;
  final String message;
  final Timestamp createdAt;
  final String senderId;

  Message({
    this.id,
    required this.createdAt,
    required this.message,
    required this.senderId,
  });

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    final message = Message.fromJson(snapshot.data() as Map<String, dynamic>);
    message.id = snapshot.id;
    return message;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      createdAt: json['createdAt'],
      senderId: json['senderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
      'createdAt': createdAt,
      'senderId': senderId,
    };
  }
}
