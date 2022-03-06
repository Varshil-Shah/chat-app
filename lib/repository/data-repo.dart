import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/model/message.dart';

class DataRepository {
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

  Future<DocumentSnapshot<Map<String, dynamic>>> getParticularField(String id) {
    return FirebaseFirestore.instance.collection("users").doc(id).get();
  }

  Future<void> sendNewMessage(String receiverId, Message newMessage) async {
    /*
      Steps:
      1. get receiver user id
      2. create message collection, create new document and store its id,
      3. take new msg id and store them in both the users recipients.
    */
    final documentId =
        await FirebaseFirestore.instance.collection("messages").add({
      "createdAt": newMessage.createdAt,
      "message": newMessage.message,
      "senderId": newMessage.senderId,
    });
    debugPrint("DOCUMENT: ${newMessage.senderId}");
  }
}
