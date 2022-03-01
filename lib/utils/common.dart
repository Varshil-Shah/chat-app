import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
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
