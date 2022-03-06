import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 3, top: 3, left: 15, right: 15),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 226, 224, 224),
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
              onPressed: textController.text.isEmpty ? null : () {},
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }
}
