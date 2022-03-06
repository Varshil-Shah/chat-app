import 'package:flutter/material.dart';

class UserSkeleton extends StatelessWidget {
  const UserSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.withOpacity(0.4),
        radius: 26,
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 20,
          width: size.width * 0.3,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
      ),
      subtitle: Container(
        height: 18,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
    );
  }
}
