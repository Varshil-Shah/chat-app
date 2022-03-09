import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/firebase/utils.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/utils/common.dart';
import 'package:chat_app/widgets/chat/message-bubble.dart';
import 'package:chat_app/widgets/skeleton/chat-skeleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/repository/data-repo.dart';
import 'package:chat_app/widgets/chat/message-box.dart';

class Chat extends StatefulWidget {
  static const routeName = '/chat';

  final String receiverId;
  final String imageUrl;
  final String username;

  const Chat({
    Key? key,
    required this.receiverId,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _dataRepo = DataRepository();
  final auth = Authentication();
  bool _isInitialLoad = true;

  final Widget loadingSkeleton = Expanded(
    child: ListView.separated(
      itemBuilder: (ctx, i) => ChatSkeleton(isMe: i % 2 == 0),
      separatorBuilder: (ctx, i) => const SizedBox(height: 10),
      itemCount: 10,
    ),
  );

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
            stream: _dataRepo.fetchAllMessageIdsAsStream(widget.receiverId),
            builder:
                (BuildContext ctx, AsyncSnapshot<JsonQuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting &&
                  _isInitialLoad) {
                return loadingSkeleton;
              }

              final List<Map<String, dynamic>> documentIds = [];
              for (final doc in snapshot.data!.docs) {
                documentIds.add({
                  'id': doc.id,
                  'createdAt': doc.data()['createdAt'] as Timestamp
                });
              }

              documentIds.sort(compareMapsByCreatedAt);

              final futures = Future.wait([
                _dataRepo.fetchMessagesFromList(documentIds),
                _dataRepo.getUserDetails(auth.currentUser!.uid)
              ]);
              return FutureBuilder<List<Object>>(
                future: futures,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Object>> snapshots,
                ) {
                  if (snapshots.connectionState == ConnectionState.waiting &&
                      _isInitialLoad) {
                    _isInitialLoad = false;
                    return loadingSkeleton;
                  }

                  final myUsername = (snapshots.data![1]
                      as DocumentSnapshot<Map<String, dynamic>>)['username'];

                  final messagesSnapshots =
                      snapshots.data?[0] as List<JsonQuerySnapshot>;

                  final messages = <Message>[];

                  for (final messagesSnapshot in messagesSnapshots) {
                    for (final message in messagesSnapshot.docs) {
                      messages.add(Message.fromSnapshot(message));
                    }
                  }
                  messages.sort(compareMessagesByCreatedAt);

                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemBuilder: (ctx, i) {
                        final isMe =
                            messages[i].senderId == auth.currentUser!.uid;
                        return MessageBubble(
                          isMe: isMe,
                          message: messages[i].message,
                          timestamp: messages[i].createdAt,
                          sender: isMe ? myUsername : widget.username,
                        );
                      },
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
