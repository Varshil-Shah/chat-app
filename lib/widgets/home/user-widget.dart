import 'package:chat_app/repository/data-repo.dart';
import 'package:chat_app/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/chat.dart';

class UserWidget extends StatelessWidget {
  final dataRepo = DataRepository();
  final String username;
  final String imageUrl;
  final String receiverId;
  final String lastMessage;
  Timestamp? lastMessageTime;

  UserWidget({
    Key? key,
    required this.username,
    required this.imageUrl,
    required this.receiverId,
    required this.lastMessage,
    this.lastMessageTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        dense: true,
        leading: ClipOval(
          child: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            loadingBuilder: (BuildContext ctx, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              );
            },
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(bottom: 3),
          child: Text(
            username,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              height: 1,
              color: Colors.black54,
            ),
          ),
        ),
        subtitle: Text(
          lastMessage,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lastMessageTime != null
                    ? date(lastMessageTime!).toString()
                    : '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  height: 0.5,
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  lastMessageTime != null
                      ? time(lastMessageTime!).toString()
                      : '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    height: 0.5,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => Chat(
                imageUrl: imageUrl,
                username: username,
                receiverId: receiverId,
              ),
            ),
          );
        },
      ),
    );
  }
}
