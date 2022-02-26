import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/common/verify-fields.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/common/input-field.dart';
import 'package:chat_app/widgets/common/input-button.dart';

class LoginInputs extends StatefulWidget {
  const LoginInputs({Key? key}) : super(key: key);

  @override
  _LoginInputsState createState() => _LoginInputsState();
}

class _LoginInputsState extends State<LoginInputs> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void _submitForm() {
    if (!VerifyInputs.verifyLogin(
      _emailController.text,
      _passwordController.text,
      context,
    )) return;
    debugPrint("LOGIN CREDENTIALS ARE CORRECT");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(
          controller: _emailController,
          hintText: "Enter email address",
          icon: Icons.email_outlined,
        ),
        InputField(
          controller: _passwordController,
          hintText: "Enter password",
          icon: Icons.lock_outline,
          obscureText: isPasswordVisible,
          suffixIconButton: IconButton(
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
            icon: isPasswordVisible
                ? const Icon(Icons.visibility_off_outlined, color: mainColor)
                : const Icon(Icons.visibility_outlined, color: mainColor),
          ),
        ),
        InputButton(onPressed: _submitForm, text: "LOGIN"),
      ],
    );
  }
}
