import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';

class ResendEmailButton extends StatefulWidget {
  final void Function() resendEmail;
  const ResendEmailButton({
    Key? key,
    required this.resendEmail,
  }) : super(key: key);

  @override
  _ResendEmailButtonState createState() => _ResendEmailButtonState();
}

class _ResendEmailButtonState extends State<ResendEmailButton> {
  bool isActive = false;
  Timer? timer;
  int counter = 60;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (counter <= 0) {
        timer!.cancel();
        setState(() {
          isActive = true;
        });
        counter = 60;
      } else {
        setState(() {
          counter--;
        });
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      width: size.width * 0.9,
      child: ElevatedButton(
        onPressed: isActive
            ? () {
                widget.resendEmail();
                setState(() {
                  isActive = !isActive;
                });
                startTimer();
              }
            : null,
        child: Text(
          isActive
              ? "RESEND EMAIL"
              : "00 : " + counter.toString().padLeft(2, '0'),
          style: const TextStyle(color: Colors.white, fontSize: 18),
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
