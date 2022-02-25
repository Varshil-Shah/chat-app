import 'package:chat_app/widgets/auth-screen/signup-inputs.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/auth-screen/background.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/gifs/auth.gif"),
              const SignupInputs(),
            ],
          ),
        ),
      ),
    );
  }
}