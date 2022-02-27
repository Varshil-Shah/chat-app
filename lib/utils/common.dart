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
