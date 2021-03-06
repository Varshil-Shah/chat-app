import 'package:flutter/material.dart';

import 'package:chat_app/widgets/common/background.dart';
import 'package:chat_app/widgets/auth-screen/login-inputs.dart';
import 'package:chat_app/screens/sign-up.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  static const routeName = "/login";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Background(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "LOGIN",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            Image.asset(
              "assets/images/authentication.png",
              width: size.width,
            ),
            const LoginInputs(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(SignUp.routeName),
                child: const Text(
                  "Don't have an account? signup",
                  style: TextStyle(fontSize: 17.0),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
