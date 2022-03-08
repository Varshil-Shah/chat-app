import 'package:flutter/material.dart';

import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/repository/data-repo.dart';
import 'package:chat_app/screens/login.dart';

import 'package:chat_app/widgets/home/user-widget.dart';
import 'package:chat_app/widgets/skeleton/user-skeleton.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = Authentication();
  final dataRepo = DataRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black54,
            size: 26.0,
          ),
          onPressed: () {
            auth.signOut();
            Navigator.of(context).pushReplacementNamed(Login.routeName);
          },
        ),
        title: Text(
          "CONVERSATIONS",
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.black54,
              size: 26.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
        stream: dataRepo.getUsersList(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              itemBuilder: (ctx, i) => const UserSkeleton(),
              separatorBuilder: (ctx, i) => const SizedBox(
                height: 20.0,
              ),
              itemCount: 10,
            );
          }

          final document = snapshot.data.docs;

          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, i) => UserWidget(
              username: document[i]['username'],
              imageUrl: document[i]['imageUrl'],
              receiverId: document[i].id,
              lastMessage: document[i]['lastMessage'],
              lastMessageTime: document[i]['lastMessageTime'],
            ),
            itemCount: document.length,
          );
        },
      ),
    );
  }
}
