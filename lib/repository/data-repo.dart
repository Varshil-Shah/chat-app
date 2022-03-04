import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataRepository {
  Stream<QuerySnapshot> getUsersList() {
    final usersCollection = FirebaseFirestore.instance
        .collection("users")
        .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots();
    return usersCollection;
  }
}
