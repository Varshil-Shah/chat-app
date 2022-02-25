import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class InputButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const InputButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      width: size.width * 0.9,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          primary: mainColor,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        ),
      ),
    );
  }
}
