import 'dart:async';

import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/widgets/auth-screen/resend-email-button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/screens/home.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  static const routeName = "/verify-email";

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = Authentication();
  User? user;
  late Timer timer;

  @override
  void initState() {
    sendAndVerifyEmail();
    super.initState();
  }

  void sendAndVerifyEmail() {
    auth.verifyCurrentUser().then((value) {
      timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (auth.isEmailVerified) {
          timer.cancel();
          Navigator.of(context).pushNamedAndRemoveUntil(
            Home.routeName,
            (Route<dynamic> route) => false,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    if (user != null) {
      user = auth.currentUser;
      await user!.reload();
      if (user!.emailVerified) {
        timer.cancel();
        Navigator.of(context).pushReplacementNamed(Home.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/email-verification.png",
            width: size.width,
          ),
          const Text(
            "Please check your email ",
            style: TextStyle(fontSize: 20, color: Colors.black87),
          ),
          const SizedBox(height: 5),
          Text(
            args['email'] as String,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const Text(
              "We have sent a confirmation message",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "🔔",
            style: TextStyle(fontSize: 40.0),
          ),
          const SizedBox(height: 10),
          ResendEmailButton(resendEmail: sendAndVerifyEmail),
        ],
      ),
    );
  }
}
