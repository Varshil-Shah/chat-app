import 'package:chat_app/screens/sign-up.dart';
import 'package:flutter/material.dart';

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
      home: const SignUp(),
    );
  }
}
