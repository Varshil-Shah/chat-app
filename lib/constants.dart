import 'package:flutter/material.dart';

const mainColor = Color.fromRGBO(146, 31, 243, 1);

const purpleMaterialColor = MaterialColor(0xFFA633FF, {
  50: Color.fromRGBO(166, 51, 255, .1),
  100: Color.fromRGBO(166, 51, 255, .2),
  200: Color.fromRGBO(166, 51, 255, .3),
  300: Color.fromRGBO(166, 51, 255, .4),
  400: Color.fromRGBO(166, 51, 255, .5),
  500: Color.fromRGBO(166, 51, 255, .6),
  600: Color.fromRGBO(166, 51, 255, .7),
  700: Color.fromRGBO(166, 51, 255, .8),
  800: Color.fromRGBO(166, 51, 255, .9),
  900: Color.fromRGBO(166, 51, 255, 1),
});

const emailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

const kMaxEmailResendCount = 2;
const kResendButtonCooldownTime = 60;
