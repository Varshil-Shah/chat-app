import 'package:chat_app/firebase/utils.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/utils/common.dart';
import 'package:chat_app/widgets/skeleton/chat-skeleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/repository/data-repo.dart';
import 'package:chat_app/widgets/chat/new-message.dart';

class Chat extends StatefulWidget {
  static const routeName = '/chat';

  final String receiverId;
  final String imageUrl;
  final String username;

  Chat({
    Key? key,
    required this.receiverId,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final dataRepo = DataRepository();

  @override
  Widget build(BuildContext context) {
    final Widget loadingSkeleton = Expanded(
      child: ListView.separated(
        itemBuilder: (ctx, i) => ChatSkeleton(isMe: i % 2 == 0),
        separatorBuilder: (ctx, i) => const SizedBox(height: 10),
        itemCount: 10,
      ),
    );

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
                backgroundImage: NetworkImage(widget.imageUrl),
                radius: 23,
              ),
              const SizedBox(width: 10),
              Text(
                widget.username,
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<JsonQuerySnapshot>(
            stream: dataRepo.fetchAllMessageIdsAsStream(widget.receiverId),
            builder:
                (BuildContext ctx, AsyncSnapshot<JsonQuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingSkeleton;
              }

              final List<Map<String, dynamic>> documentIds = [];
              for (final doc in snapshot.data!.docs) {
                documentIds.add({
                  'id': doc.id,
                  'createdAt': doc.data()['createdAt'] as Timestamp
                });
              }

              documentIds.sort(compareCreatedAts);

              return FutureBuilder<List<JsonQuerySnapshot>>(
                future: dataRepo.fetchMessagesFromList(documentIds),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<JsonQuerySnapshot>> messagesSnapshot,
                ) {
                  if (messagesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return loadingSkeleton;
                  }
                  final messages = <JsonQueryDocumentSnapshot>[];
                  messagesSnapshot.data?.forEach((element) {
                    messages.addAll(element.docs);
                  });
                  messages.sort(compareCreatedAts);

                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (ctx, i) {
                        return ChatSkeleton(
                          isMe: i % 2 == 0,
                          text: messages[i]["message"],
                        );
                      },
                      separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                      itemCount: messages.length,
                    ),
                  );
                },
              );
            },
          ),
          MessageBox(
            receiverId: widget.receiverId,
          )
        ],
      ),
    );
  }
}
