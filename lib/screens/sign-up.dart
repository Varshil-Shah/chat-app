import 'dart:io';
import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/widgets/common/verify-fields.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/common/input-image.dart';
import 'package:chat_app/widgets/auth-screen/signup-inputs.dart';
import 'package:chat_app/widgets/common/background.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const routeName = "/sign-up";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File? _imageFile;
  bool _isLoading = false;

  void storeImage(File? imageFile) {
    _imageFile = imageFile;
  }

  void _submitForm({
    required String username,
    required String email,
    required String password,
  }) async {
    setState(() {
      _isLoading = true;
    });
    await Firebase.initializeApp();
    final auth = Authentication();

    final error = await auth.addUserUsingEmailAndPassword(
      email: email,
      password: password,
      username: username,
      collection: "users",
      image: _imageFile,
    );
    setState(() {
      _isLoading = false;
    });
    if (error != null && error.isNotEmpty) {
      debugPrint("IMAGE FILE: $_imageFile");
      VerifyInputs.showSnackbar(error, context);
      return;
    }
    VerifyInputs.showSnackbar("SIGN UP SUCCESSFUL", context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "SIGN UP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              InputImage(onStoreImage: storeImage),
              const SizedBox(height: 30.0),
              SignupInputs(submitForm: _submitForm, isLoading: _isLoading),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
