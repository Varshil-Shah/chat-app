import 'dart:io' show File;
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

int compareCreatedAts(dynamic a, dynamic b) {
  final first = a['createdAt'] as Timestamp;
  final second = b['createdAt'] as Timestamp;
  return first.compareTo(second);
}
