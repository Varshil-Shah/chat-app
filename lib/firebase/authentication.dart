import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Authentication {
  User? user;

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

    image ??= await _fileFromImageUrl();

    final ref = FirebaseStorage.instance
        .ref()
        .child("image_path")
        .child(authenticationResult.userCredential!.user!.uid + '.jpg');
    TaskSnapshot uploadedFile = await ref.putFile(image);

    if (uploadedFile.state == TaskState.success) {
      imageUrl = await ref.getDownloadURL();
    }

    final data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['createdAt'] =
        authenticationResult.userCredential!.user?.metadata.creationTime ??
            FieldValue.serverTimestamp();
    data['imageUrl'] = imageUrl;
    if (values != null) data.addAll(values);

    _firebaseFirestore
        .collection(collection)
        .doc(authenticationResult.userCredential!.user!.uid)
        .set({...data}).catchError((e) {
      debugPrint("ERRROR IN addUserUsingEmailAndPassword - ${e.toString()}");
      error = e.toString();
    });
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
}

Future<File> _fileFromImageUrl() async {
  final response = await http.get(
    Uri.parse(
        "https://raw.githubusercontent.com/Varshil-Shah/chat-app/main/assets/images/circular-avatar.png"),
  );
  final documentDirectory = await getTemporaryDirectory();
  final file = File(join(documentDirectory.path, 'circular-avatar.png'));
  file.writeAsBytesSync(response.bodyBytes);
  return file;
}

class AuthenticationResult {
  UserCredential? userCredential;
  String? error;

  AuthenticationResult({required this.userCredential, this.error});
}
