import 'dart:async';

import 'package:chat_app/firebase/authentication.dart';
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
  bool isButtonActive = false;
  bool isNextResendEmailTimerActive = false;
  int counter = kResendButtonCooldownTime;
  String buttonText = "Resend Email";

  @override
  void initState() {
    super.initState();
    () async {
      // checking if their any time exist in database
      await checkNextResendEmailTime();
      // if not exist, show the timer
      if (!isNextResendEmailTimerActive) {
        startTimer();
      }
    }();
  }

  Future<Duration?> checkNextResendEmailTime() async {
    // Check if nextResendEmailTime is set in DB
    final nextResendEmailTime = (await auth.getNextResendEmailTime())?.toDate();

    // This means, timer is still active in database
    if (nextResendEmailTime != null) {
      // fetching remaining time
      final remainingCooldownTime =
          nextResendEmailTime.difference(DateTime.now());

      // If timer in database hasn't completed, return remaining time
      if (!remainingCooldownTime.isNegative) {
        setState(() {
          isNextResendEmailTimerActive = true;
          buttonText = "Time remaining ${remainingCooldownTime.inMinutes}"
              " minute${remainingCooldownTime.inMinutes == 1 ? '' : 's'}";
        });
        return remainingCooldownTime;
      }

      // If timer in database has completed, restore resend count in database
      auth.setResendEmailCount(0);
    }
    return null;
  }

  void startTimer() {
    /*
    If I would have set counter again to 60 in `if (counter == 0)`s setState, 
    it would have ran for infinite loop because the WidgetsBinding's addPostFrameCallback 
    would not run as counter's value won't be 0
    so resetting the value outside the time was a good work around.
    */
    counter = kResendButtonCooldownTime;
    timer = Timer.periodic(const Duration(seconds: 1), (time) async {
      // this means, counter has completed its task
      if (counter == 0) {
        timer.cancel();
        // If the resendEmailCount hasn't reached till maxEmailCount,
        // make the resend email button active
        if (await auth.getResendEmailCount() < kMaxEmailResendCount) {
          setState(() {
            isButtonActive = true;
            buttonText = "Resend Email";
          });
        }
      } else {
        setState(() {
          --counter;
          buttonText = "Resend email in ${counter}s";
        });
      }
    });
  }

  void _onPressed() async {
    // check if button has been pressed `kMaxExmailResendCount - 1` times
    if (await auth.getResendEmailCount() == kMaxEmailResendCount - 1) {
      // set timer of 1 hr
      final timeAfter1Hr = Timestamp.fromDate(
        DateTime.now().add(const Duration(hours: 1)),
      );
      auth.setNextResendEmailTime(timeAfter1Hr);
    }

    // increment button click on the database
    auth.incrementResendEmailCount();

    widget.resendEmail();
    setState(() {
      isButtonActive = false;
      buttonText = "Resend email in ${kResendButtonCooldownTime}s";
    });

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      () async {
        if (await auth.getResendEmailCount() == kMaxEmailResendCount &&
            counter == 0) {
          auth.setResendEmailCount(100);
          final Duration? cooldownTime = (await auth.getNextResendEmailTime())
              ?.toDate()
              .difference(DateTime.now());
          setState(() {
            isNextResendEmailTimerActive = true;
            buttonText =
                "Time remaining ${cooldownTime!.inMinutes} minute${cooldownTime.inMinutes == 1 ? '' : 's'}";
          });
        }
      }();
    });

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      width: size.width * 0.9,
      child: ElevatedButton(
        onPressed: isButtonActive ? _onPressed : null,
        child: Text(
          buttonText,
          style: TextStyle(
            color: isButtonActive ? Colors.white : Colors.black54,
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
