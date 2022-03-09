import 'dart:io' show File;
import 'package:chat_app/firebase/utils.dart';
import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:path/path.dart' show join;
import 'package:http/http.dart' as http;

Future<File> fileFromImageUrl() async {
  final response = await http.get(
    Uri.parse(
        "https://raw.githubusercontent.com/Varshil-Shah/chat-app/main/assets/images/circular-avatar.png"),
  );
  final documentDirectory = await getTemporaryDirectory();
  final file = File(join(documentDirectory.path, 'circular-avatar.png'));
  file.writeAsBytesSync(response.bodyBytes);
  return file;
}

String maskEmail(String email) {
  final splits = email.split("@");

  final username = splits[0];
  splits[0] = username.replaceRange(2, null, "*" * (username.length - 2));

  final domainParts = splits[1].split('.');

  final secondLevelDomain = domainParts[0];
  domainParts[0] = secondLevelDomain.replaceRange(
      1, null, '*' * (secondLevelDomain.length - 1));

  splits[1] = domainParts.join(".");

  return splits.join("@");
}

int compareMessagesByCreatedAt(Message a, Message b) {
  return (b.createdAt).toDate().difference(a.createdAt.toDate()).inMilliseconds;
}

int compareMapsByCreatedAt(Map<String, dynamic> a, Map<String, dynamic> b) {
  return (b['createdAt'] as Timestamp)
      .toDate()
      .difference((a['createdAt'] as Timestamp).toDate())
      .inMilliseconds;
}

String time(Timestamp lastMessageTime) {
  final dateTime = lastMessageTime.toDate();
  late String messageCreatedTime;
  if (dateTime.hour > 12) {
    messageCreatedTime = "${dateTime.hour - 12}:${dateTime.minute} pm";
    return messageCreatedTime;
  }
  messageCreatedTime = "${dateTime.hour}:${dateTime.minute} am";
  return messageCreatedTime;
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

String? date(Timestamp lastMessageTime) {
  final dateTime = lastMessageTime.toDate();
  if (calculateDifference(dateTime) == 0) {
    return "Today";
  } else if (calculateDifference(dateTime) == -1) {
    return "Yesterday";
  } else {
    final date =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}";
    return date;
  }
}
