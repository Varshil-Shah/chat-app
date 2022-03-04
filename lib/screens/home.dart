import 'package:chat_app/constants.dart';
import 'package:chat_app/repository/data-repo.dart';
import 'package:chat_app/widgets/common/input-field.dart';
import 'package:chat_app/widgets/home/user-widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _searchTextController = TextEditingController();
  final dataRepo = DataRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        titleSpacing: -5,
        backgroundColor: Colors.transparent,
        title: InputField(
          controller: _searchTextController,
          hintText: "Search user",
          icon: Icons.search,
          boxConstraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
          suffixIconButton: IconButton(
            icon: const Icon(Icons.close, color: mainColor),
            onPressed: () {},
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: dataRepo.getUsersList(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final document = snapshot.data.docs;
          return ListView.separated(
            itemBuilder: (ctx, i) => UserWidget(
              username: document[i]['username'],
              imageUrl: document[i]['imageUrl'],
              time: (document[i]['createdAt'] as Timestamp).toDate(),
              receiverId: document[i].id,
            ),
            separatorBuilder: (ctx, i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: Colors.grey[400],
              ),
            ),
            itemCount: document.length,
          );
        },
      ),
    );
  }
}
