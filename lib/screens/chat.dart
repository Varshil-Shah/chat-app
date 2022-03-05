import 'package:chat_app/constants.dart';
import 'package:chat_app/repository/data-repo.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  static const routeName = '/chat';

  final String receiverId;
  final String imageUrl;
  final String username;
  final dataRepo = DataRepository();

  Chat({
    Key? key,
    required this.receiverId,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 25,
              ),
            ),
            const SizedBox(width: 10),
            Text(username),
          ],
        ),
      ),
    );
  }
}
