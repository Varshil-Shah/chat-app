import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/common/input-button.dart';
import 'package:chat_app/widgets/common/input-field.dart';
import 'package:chat_app/widgets/common/verify-fields.dart';
import 'package:flutter/material.dart';

class SignupInputs extends StatefulWidget {
  final void Function({
    required String email,
    required String password,
    required String username,
  }) submitForm;
  final bool isLoading;

  const SignupInputs({
    Key? key,
    required this.submitForm,
    required this.isLoading,
  }) : super(key: key);

  @override
  _SignupInputsState createState() => _SignupInputsState();
}

class _SignupInputsState extends State<SignupInputs> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordVisible = true;

  void _validateForm() {
    if (!VerifyInputs.verifySignUp(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
      context,
    )) return;
    debugPrint("SIGN UP CREDENTIALS ARE CORRECT");
    widget.submitForm(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(
          controller: _usernameController,
          hintText: "Enter username",
          icon: Icons.person_outline,
        ),
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
        InputButton(
          onPressed: _validateForm,
          text: "SIGN UP",
          isLoading: widget.isLoading,
        ),
      ],
    );
  }
}
