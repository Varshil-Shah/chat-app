import 'dart:async';

import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/utils/common.dart';
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

  Future<void> sendAndVerifyEmail() async {
    await auth.verifyCurrentUser();
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (auth.isEmailVerified) {
        timer.cancel();
        Navigator.of(context).pushNamedAndRemoveUntil(
          Home.routeName,
          (Route<dynamic> route) => false,
        );
      }
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
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
            "Verify your email",
            style: TextStyle(
              fontSize: 26,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          "Almost there! We've sent a verification email to \n",
                    ),
                    WidgetSpan(
                      child: Container(
                        margin: const EdgeInsets.only(top: 5.0, bottom: 12.0),
                        child: Text(
                          maskEmail(args['email'] as String),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(
                      text:
                          ".\nYou need to verify your email address to log into Chat App.",
                    )
                  ]),
            ),
          ),
          const SizedBox(height: 10),
          ResendEmailButton(resendEmail: sendAndVerifyEmail),
        ],
      ),
    );
  }
}
