import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/common/input-button.dart';
import 'package:chat_app/widgets/common/input-field.dart';
import 'package:chat_app/widgets/common/verify-fields.dart';
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
  bool isPasswordVisible = false;

  void showSnackbar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  void checkUsername(String value) {
    if (value.isEmpty) {
      return showSnackbar("username field can't be empty");
    }
    if (value.length < 8) {
      return showSnackbar("minimun 6 characters required in username");
    }
    checkEmailAddress(_emailController.text);
  }

  void checkEmailAddress(String value) {
    if (value.isEmpty) return showSnackbar("email address cannot be empty");
    if (!RegExp(emailRegex).hasMatch(value)) {
      return showSnackbar("please enter a valid email address");
    }
    checkPassword(_passwordController.text);
  }

  void checkPassword(String value) {
    if (value.isEmpty) return showSnackbar("password cannot be empty");

    if (value.length < 8) {
      return showSnackbar('password must contain - minimum 8 characters');
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return showSnackbar('password must contain - A lowercase letter');
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return showSnackbar('password must contain - An uppercase letter');
    }
    if (!RegExp(r'[!@#\$&*~.-/:`]').hasMatch(value)) {
      return showSnackbar('password must contain - A special character');
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return showSnackbar('password must contain - A number');
    }
  }

  void _submitForm() {
    if (!VerifyInputs.verifySignUp(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
      context,
    )) return;
    debugPrint("SIGN UP CREDENTIALS ARE CORRECT");
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
        InputButton(onPressed: _submitForm, text: "SIGN UP"),
      ],
    );
  }
}
