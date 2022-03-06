import 'package:chat_app/firebase/authentication.dart';
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

  Future<DocumentSnapshot<Map<String, dynamic>>> getParticularField(String id) {
    return FirebaseFirestore.instance.collection("users").doc(id).get();
  }

  Future<void> sendMessagePath(
    String senderId,
    String receiverId,
    String documentId,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(senderId)
        .collection("recipients")
        .doc(receiverId)
        .collection("messages")
        .doc(documentId)
        .set({
      "createdAt": Timestamp.now(),
    });
  }

  Future<void> sendNewMessage(String receiverId, Message newMessage) async {
    final document =
        await FirebaseFirestore.instance.collection("messages").add({
      "createdAt": newMessage.createdAt,
      "message": newMessage.message,
      "senderId": newMessage.senderId,
    });

    // for receiver
    await sendMessagePath(
      receiverId,
      auth.currentUser!.uid,
      document.id,
    );

    // for sender
    await sendMessagePath(
      auth.currentUser!.uid,
      receiverId,
      document.id,
    );
  }
}
