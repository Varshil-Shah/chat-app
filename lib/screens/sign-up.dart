import 'package:chat_app/widgets/auth-screen/input-image.dart';
import 'package:chat_app/widgets/auth-screen/signup-inputs.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/auth-screen/background.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "SIGN UP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              InputImage(),
              SizedBox(height: 30.0),
              SignupInputs(),
            ],
          ),
        ),
      ),
    );
  }
}
