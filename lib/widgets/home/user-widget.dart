import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const CircleAvatar(
        backgroundImage: AssetImage("assets/images/circular-avatar.png"),
        radius: 30,
      ),
      title: const Text(
        "Varshil Shah",
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "No message found",
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w400,
              height: 0.5,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: const Text(
              "16.38",
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                height: 0.5,
              ),
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
