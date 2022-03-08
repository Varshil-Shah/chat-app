import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import 'package:chat_app/utils/common.dart' show fileFromImageUrl;

class Authentication {
  late UserCredential userCreds;

  late final FirebaseAuth _firebaseAuth;
  late final FirebaseFirestore _firebaseFirestore;

  Authentication({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
  }) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  }

  Future<String?> addUserUsingEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String collection,
    Map<String, dynamic>? values,
    File? image,
  }) async {
    late final AuthenticationResult authenticationResult;
    String? error;
    late String imageUrl;

    authenticationResult = await _createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (authenticationResult.error != null &&
        authenticationResult.error!.isNotEmpty) {
      return authenticationResult.error;
    }

    if (authenticationResult.userCredential == null) return null;

    image ??= await fileFromImageUrl();

    final ref = FirebaseStorage.instance.ref().child("image_path").child(
          authenticationResult.userCredential!.user!.uid +
              path.extension(image.path),
        );
    debugPrint("IMAGE EXTENSION: ${path.extension(image.path)}");
    TaskSnapshot uploadedFile = await ref.putFile(image);

    if (uploadedFile.state == TaskState.success) {
      imageUrl = await ref.getDownloadURL();
    }

    final data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['imageUrl'] = imageUrl;
    data['resendEmailCount'] = 0;
    data['nextResendEmailTime'] = null;
    data['lastMessage'] = "No message found yet";
    data['lastMessageTime'] = null;
    if (values != null) data.addAll(values);

    _firebaseFirestore
        .collection(collection)
        .doc(authenticationResult.userCredential!.user!.uid)
        .set({...data}).catchError((e) {
      debugPrint("ERRROR IN addUserUsingEmailAndPassword - ${e.toString()}");
      error = e.toString();
    });

    userCreds = authenticationResult.userCredential!;
    return error;
  }

  Future<AuthenticationResult> _createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential? userCredential;
    String? error;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      } else {
        error = e.message;
      }
    } catch (e) {
      error = e.toString();
    }
    return AuthenticationResult(
      userCredential: userCredential,
      error: error,
    );
  }

  Future<AuthenticationResult> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential? userCreds;
    String? error;
    try {
      userCreds = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (err) {
      if (err.code == "user-not-found") {
        error = "No user found with this email";
      } else if (err.code == "wrong-password") {
        error = "wrong password provided for the email";
      } else {
        error = err.message;
      }
    }
    return AuthenticationResult(userCredential: userCreds, error: error);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification(User? user) async {
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> verifyCurrentUser() async {
    if (!isEmailVerified) {
      User? user = _firebaseAuth.currentUser;
      user!.reload();
      await sendEmailVerification(user);
    }
  }

  bool get isEmailVerified {
    final user = _firebaseAuth.currentUser;
    user!.reload();
    return user.emailVerified;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> setUserCredentials(String key, dynamic value) =>
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .update({key: value});

  Future<dynamic> getUserCredentials(String key) async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get();
    return doc[key];
  }

  bool isUserLoggedIn() => _firebaseAuth.currentUser != null;

  Future<int> getResendEmailCount() async =>
      (await getUserCredentials('resendEmailCount')) as int;

  Future<void> setResendEmailCount(int count) =>
      setUserCredentials('resendEmailCount', count);

  Future<Timestamp?> getNextResendEmailTime() async =>
      await getUserCredentials('nextResendEmailTime') as Timestamp?;

  Future<void> setNextResendEmailTime(Timestamp? time) =>
      setUserCredentials('nextResendEmailTime', time);

  Future<void> incrementResendEmailCount() async =>
      await setResendEmailCount(await getResendEmailCount() + 1);
}

class AuthenticationResult {
  UserCredential? userCredential;
  String? error;

  AuthenticationResult({required this.userCredential, this.error});
}
