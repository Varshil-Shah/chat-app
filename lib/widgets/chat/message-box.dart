import 'package:chat_app/constants.dart';
import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/repository/data-repo.dart';
import 'package:chat_app/widgets/common/verify-fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBox extends StatefulWidget {
  final String receiverId;
  const MessageBox({Key? key, required this.receiverId}) : super(key: key);

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final auth = Authentication();
  final dataRepo = DataRepository();
  String message = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    if (message.isEmpty) return;
    final createdAtTime = Timestamp.now();
    await dataRepo.addMessage(
      widget.receiverId,
      Message(
        createdAt: createdAtTime,
        message: message,
        senderId: auth.currentUser!.uid,
      ),
    );
    await dataRepo.updateLastMessageAndTime(message, createdAtTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 3, top: 3, left: 15, right: 15),
      margin: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Type message...",
              ),
              style: const TextStyle(fontSize: 18),
              cursorColor: mainColor,
              autocorrect: true,
              minLines: 1,
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  message = value;
                });
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            margin: const EdgeInsets.all(5),
            child: IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: message.isEmpty ? Colors.black26 : Colors.black54,
                size: 32,
              ),
              onPressed: sendMessage,
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }
}
