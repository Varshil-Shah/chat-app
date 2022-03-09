import 'dart:async';

import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/firebase/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/model/message.dart';

class DataRepository {
  final auth = Authentication();

  Stream<QuerySnapshot> getUsersList() {
    final usersCollection = FirebaseFirestore.instance
        .collection("users")
        .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots();
    return usersCollection;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserData(
      String uid) async {
    final userCollection =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return userCollection;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(String id) {
    return FirebaseFirestore.instance.collection("users").doc(id).get();
  }

  Future<void> sendMessagePath(
    String senderId,
    String receiverId,
    String messageId,
    Timestamp createdAt,
    WriteBatch batch,
  ) async {
    final messageDocumentRef = FirebaseFirestore.instance
        .collection("users")
        .doc(senderId)
        .collection("recipients")
        .doc(receiverId)
        .collection("messages")
        .doc(messageId);

    batch.set(messageDocumentRef, {"createdAt": createdAt});
  }

  Future<void> addMessage(String receiverId, Message message) {
    final WriteBatch batch = FirebaseFirestore.instance.batch();

    final messageRef = FirebaseFirestore.instance.collection("messages").doc();

    batch.set(messageRef, message.toJson());

    // for receiver
    sendMessagePath(
      receiverId,
      auth.currentUser!.uid,
      messageRef.id,
      message.createdAt,
      batch,
    );

    // for sender
    sendMessagePath(
      auth.currentUser!.uid,
      receiverId,
      messageRef.id,
      message.createdAt,
      batch,
    );

    return batch.commit();
  }

  Stream<JsonQuerySnapshot> fetchAllMessageIdsAsStream(String receiverId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("recipients")
        .doc(receiverId)
        .collection("messages")
        .snapshots();
  }

  Future<List<JsonQuerySnapshot>> fetchMessagesFromList(
      List<Map<String, dynamic>> documentIds) {
    final messages = <Future<JsonQuerySnapshot>>[];

    for (var i = 0; i < documentIds.length; i += 10) {
      final rangeOfSomeDocIds = documentIds
          .getRange(
              i, (i + 10) < documentIds.length ? i + 10 : documentIds.length)
          .map((e) => e['id'])
          .toList();

      messages.add(FirebaseFirestore.instance
          .collection("messages")
          .where(FieldPath.documentId, whereIn: rangeOfSomeDocIds)
          .get());
    }

    return Future.wait(messages);
  }

  Future<void> updateLastMessageAndTime(String message, Timestamp time) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({
      "lastMessage": message,
      "lastMessageTime": time,
    });
  }
}
