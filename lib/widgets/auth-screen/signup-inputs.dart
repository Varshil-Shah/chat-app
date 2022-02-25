import 'package:chat_app/widgets/auth-screen/input-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app/widgets/auth-screen/input-field.dart';
import 'package:flutter/material.dart';

class SignupInputs extends StatefulWidget {
  const SignupInputs({Key? key}) : super(key: key);

  @override
  _SignupInputsState createState() => _SignupInputsState();
}

class _SignupInputsState extends State<SignupInputs> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(
          controller: _usernameController,
          validator: (_) => null,
          onSaved: (_) {},
          hintText: "Enter username",
          icon: Icons.person_outline,
        ),
        InputField(
          controller: _emailController,
          validator: (_) => null,
          onSaved: (_) {},
          hintText: "Enter email address",
          icon: Icons.email_outlined,
        ),
        InputField(
          controller: _passwordController,
          validator: (_) => null,
          onSaved: (_) {},
          hintText: "Enter password",
          icon: Icons.lock_outline,
        ),
        InputButton(onPressed: () {}, text: "SIGN UP"),
      ],
    );
  }
}
