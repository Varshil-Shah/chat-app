import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.validator,
    required this.onSaved,
    required this.hintText,
    required this.icon,
    this.suffix,
    this.labelStyle,
    this.style,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.onFocus = false,
    this.readOnly = false,
  }) : super(key: key);

  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String? value) onSaved;
  final bool readOnly;
  final TextEditingController controller;
  final TextStyle? style;
  final String? Function(String? value) validator;
  final bool onFocus;
  final Widget? suffix;
  final String hintText;
  final TextStyle? labelStyle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: purpleMaterialColor[200],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          suffix: suffix,
          isDense: true,
          hintText: "Enter email address",
          icon: Icon(
            icon,
            color: mainColor,
            size: 26,
          ),
        ),
        autocorrect: true,
        keyboardType: textInputType,
        obscureText: obscureText,
        onSaved: onSaved,
        readOnly: readOnly,
        controller: controller,
        style: style,
        validator: validator,
        autofocus: onFocus,
      ),
    );
  }
}
