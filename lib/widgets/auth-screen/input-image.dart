import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class InputImage extends StatefulWidget {
  const InputImage({Key? key}) : super(key: key);

  @override
  _InputImageState createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage("assets/images/circular-avatar.png"),
          backgroundColor: Colors.grey,
        ),
        const SizedBox(height: 15.0),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 7),
          width: size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: mainColor,
          ),
          child: TextButton.icon(
            icon: const Icon(
              Icons.camera,
              color: Colors.white,
            ),
            onPressed: () {},
            label: const Text(
              "Select image",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}
