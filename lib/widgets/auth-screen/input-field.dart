import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.onSubmitted,
    this.onChanged,
    this.suffix,
    this.labelStyle,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.onFocus = false,
    this.readOnly = false,
    this.suffixIconButton,
    this.horizontalMargin = 20.0,
    this.verticalMargin = 10.0,
    this.horizontalPadding = 10.0,
    this.verticalPadding = 3.0,
  }) : super(key: key);

  final TextInputType textInputType;
  final bool obscureText;
  final bool readOnly;
  final TextEditingController controller;
  final bool onFocus;
  final Widget? suffix;
  final String hintText;
  final TextStyle? labelStyle;
  final IconData icon;
  final Widget? suffixIconButton;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  final double horizontalMargin;
  final double verticalMargin;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: purpleMaterialColor[200],
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          suffix: suffix,
          suffixIcon: suffixIconButton,
          isDense: false,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 17.0,
          ),
          icon: Icon(
            icon,
            color: mainColor,
            size: 26,
          ),
          errorMaxLines: 1,
          errorText: null,
          errorStyle: const TextStyle(
            color: Colors.transparent,
            fontSize: 0,
          ),
        ),
        autocorrect: true,
        keyboardType: textInputType,
        obscureText: obscureText,
        readOnly: readOnly,
        controller: controller,
        style: const TextStyle(fontSize: 18.0),
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        autofocus: onFocus,
      ),
    );
  }
}
