import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';

class VerifyInputs {
  static void showSnackbar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16.0),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static bool _checkUsername(String value, BuildContext context) {
    if (value.isEmpty) {
      showSnackbar("username field can't be empty", context);
      return false;
    } else if (value.length < 8) {
      showSnackbar("minimun 8 characters required in username", context);
      return false;
    }
    return true;
  }

  static bool _checkEmailAddress(String value, BuildContext context) {
    if (value.isEmpty) {
      showSnackbar("email address cannot be empty", context);
      return false;
    }
    if (!RegExp(emailRegex).hasMatch(value)) {
      showSnackbar("please enter a valid email address", context);
      return false;
    }
    return true;
  }

  static bool _checkPassword(String value, BuildContext context) {
    if (value.isEmpty) {
      showSnackbar("password cannot be empty", context);
      return false;
    } else if (value.length < 8) {
      showSnackbar('password must contain - minimum 8 characters', context);
      return false;
    } else if (value.length > 30) {
      showSnackbar('password must contain - maximum 30 characters', context);
      return false;
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      showSnackbar('password must contain - A lowercase letter', context);
      return false;
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      showSnackbar('password must contain - An uppercase letter', context);
      return false;
    } else if (!RegExp(r'[!@#\$&*~.-/:`]').hasMatch(value)) {
      showSnackbar('password must contain - A special character', context);
      return false;
    } else if (!RegExp(r'\d').hasMatch(value)) {
      showSnackbar('password must contain - A number', context);
      return false;
    }
    return true;
  }

  static bool verifyLogin(String email, String password, BuildContext context) {
    if (_checkEmailAddress(email, context)) {
      return _checkPassword(password, context);
    }
    return false;
  }

  static bool verifySignUp(
    String username,
    String emailAddress,
    String password,
    BuildContext context,
  ) {
    if (_checkUsername(username, context)) {
      if (_checkEmailAddress(emailAddress, context)) {
        return _checkPassword(password, context);
      }
    }
    return false;
  }
}
