import 'package:chat_app/constants.dart';
import 'package:chat_app/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String sender;
  final Timestamp timestamp;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.timestamp,
    required this.isMe,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          key: key,
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : purpleMaterialColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
              bottomLeft: !isMe
                  ? const Radius.circular(0.0)
                  : const Radius.circular(20.0),
              bottomRight: isMe
                  ? const Radius.circular(0.0)
                  : const Radius.circular(20.0),
            ),
          ),
          width: 190.0,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: isMe ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date(timestamp).toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isMe ? Colors.black54 : Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    time(timestamp).toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isMe ? Colors.black54 : Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
