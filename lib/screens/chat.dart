import 'package:flutter/material.dart';
import 'package:chat_app/repository/data-repo.dart';
import 'package:chat_app/widgets/chat/new-message.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          titleSpacing: -8,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          backgroundColor: Colors.grey.withOpacity(0.1),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 23,
              ),
              const SizedBox(width: 10),
              Text(
                username,
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          NewMessage(
            receiverId: receiverId,
          )
        ],
      ),
    );
  }
}
