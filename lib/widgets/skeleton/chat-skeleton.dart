import 'package:flutter/material.dart';

class ChatSkeleton extends StatelessWidget {
  final bool isMe;
  final String? text;
  const ChatSkeleton({
    Key? key,
    required this.isMe,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
          width: size.width * 0.3,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        Container(
          height: 22,
          width: size.width * 0.8,
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.3),
          ),
          child: text != null ? Text(text!) : const SizedBox.shrink(),
        ),
        Container(
          height: 22,
          width: size.width * 0.8,
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
