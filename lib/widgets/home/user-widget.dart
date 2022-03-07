import 'package:chat_app/repository/data-repo.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/chat.dart';

class UserWidget extends StatelessWidget {
  final dataRepo = DataRepository();
  final String username;
  final String imageUrl;
  final String receiverId;
  String? lastMessage;

  UserWidget({
    Key? key,
    required this.username,
    required this.imageUrl,
    required this.receiverId,
    this.lastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        margin: const EdgeInsets.only(bottom: 2),
        child: Text(
          username,
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
      ),
      subtitle: Text(
        "",
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: const Text(
              "16.54",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 0.5,
              ),
            ),
          ),
        ],
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
    );
  }
}
