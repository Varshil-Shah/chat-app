import 'dart:async';

import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/widgets/common/verify-fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';

class ResendEmailButton extends StatefulWidget {
  final Future<void> Function() resendEmail;
  const ResendEmailButton({
    Key? key,
    required this.resendEmail,
  }) : super(key: key);

  @override
  _ResendEmailButtonState createState() => _ResendEmailButtonState();
}

class _ResendEmailButtonState extends State<ResendEmailButton> {
  final auth = Authentication();
  late Timer timer;
  bool isActive = false;
  int counter = 60;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (counter == 0) {
        timer.cancel();
        setState(() {
          isActive = true;
          counter = 60;
        });
      } else {
        setState(() {
          --counter;
        });
      }
    });
  }

  void _onPressed() async {
    if (await auth.getResendEmailCount() == kMaxEmailResendCount) {
      await auth.setNextResendEmailTime(
          Timestamp.fromDate(DateTime.now().add(const Duration(hours: 1))));
      setState(() {
        isActive = !isActive;
      });
      VerifyInputs.showSnackbar("Please try again after an hour", context);
      return;
    }

    final nextResendEmailTime = (await auth.getNextResendEmailTime()).toDate();
    final now = DateTime.now();
    if (nextResendEmailTime.isAfter(now)) {
      setState(() {
        isActive = !isActive;
      });
      VerifyInputs.showSnackbar(
        "Please try again after ${nextResendEmailTime.difference(now).inMinutes} min",
        context,
      );
      return;
    }

    auth.incrementResendEmailCount();
    widget.resendEmail();
    setState(() {
      isActive = !isActive;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      width: size.width * 0.9,
      child: ElevatedButton(
        onPressed: isActive ? _onPressed : null,
        child: Text(
          isActive
              ? "Resend Email"
              : "Resend Email in " + counter.toString().padLeft(2, '0') + "s",
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black54,
            fontSize: 18,
          ),
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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
