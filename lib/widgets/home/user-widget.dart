import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String username;
  final String imageUrl;
  final DateTime time;
  final String receiverId;
  String? lastMessage;

  UserWidget({
    Key? key,
    required this.username,
    required this.imageUrl,
    required this.time,
    required this.receiverId,
    this.lastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 25,
      ),
      title: Text(
        username,
        style: const TextStyle(
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
              fontStyle: FontStyle.italic,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: const Text(
              "16.54",
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                height: 0.5,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        debugPrint(receiverId);
      },
    );
  }
}
