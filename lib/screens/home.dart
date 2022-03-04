import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/common/input-field.dart';
import 'package:chat_app/widgets/home/user-widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        titleSpacing: 0,
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
      body: ListView.separated(
        itemBuilder: (ctx, i) => const UserWidget(),
        separatorBuilder: (ctx, i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            color: Colors.grey[400],
          ),
        ),
        itemCount: 10,
      ),
    );
  }
}
