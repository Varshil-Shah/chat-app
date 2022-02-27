import 'package:flutter/material.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/sign-up.dart';
import 'package:chat_app/screens/verify-email.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(146, 31, 243, 1),
      ),
      home: const VerifyEmail(),
      routes: {
        SignUp.routeName: (ctx) => const SignUp(),
        Login.routeName: (ctx) => const Login(),
        VerifyEmail.routeName: (ctx) => const VerifyEmail(),
      },
    );
  }
}
