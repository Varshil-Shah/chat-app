import 'package:chat_app/constants.dart';
import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/repository/data-repo.dart';
import 'package:chat_app/widgets/common/verify-fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String receiverId;
  const NewMessage({Key? key, required this.receiverId}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final textController = TextEditingController();
  final auth = Authentication();
  final dataRepo = DataRepository();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    if (textController.text.isEmpty) {
      VerifyInputs.showSnackbar("please enter a message", context);
      return;
    }
    final message = textController.text;
    textController.text = '';
    await dataRepo.sendNewMessage(
      widget.receiverId,
      Message(
        createdAt: Timestamp.now(),
        message: message,
        senderId: auth.currentUser!.uid,
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 3, top: 3, left: 15, right: 15),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 236, 235, 235),
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
              controller: textController,
              autocorrect: true,
              minLines: 1,
              maxLines: 3,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.black54,
                size: 28,
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
