import 'dart:async';

import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/utils/common.dart';
import 'package:chat_app/widgets/auth-screen/resend-email-button.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/screens/home.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  static const routeName = "/verify-email";

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = Authentication();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    sendAndVerifyEmail();
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
    final user = auth.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        timer.cancel();
        Navigator.of(context).pushReplacementNamed(Home.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    text: "Almost there! We've sent a verification email to \n",
                  ),
                  WidgetSpan(
                    child: Container(
                      margin: const EdgeInsets.only(top: 5.0, bottom: 12.0),
                      child: Text(
                        maskEmail(auth.currentUser!.email ?? "Email not found"),
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ResendEmailButton(resendEmail: sendAndVerifyEmail),
        ],
      ),
    );
  }
}
