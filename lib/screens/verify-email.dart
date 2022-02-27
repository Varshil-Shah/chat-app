import 'package:chat_app/widgets/common/input-button.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  static const routeName = "/verify-email";

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
            "Please check your email ",
            style: TextStyle(fontSize: 20, color: Colors.black87),
          ),
          const SizedBox(height: 5),
          const Text(
            "varshilshah1004@gmail.com",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "We have sent a confirmation message 🔔",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          InputButton(onPressed: () {}, text: "OPEN MAIL", isLoading: false),
        ],
      ),
    );
  }
}
