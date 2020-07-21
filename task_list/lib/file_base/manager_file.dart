import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> _getFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/data.json');
}

Future<File> saveData(_toList) async {
  final json = jsonEncode(_toList);

  final file = await _getFile();
  return file.writeAsString(json);
}

Future<String> readData() async {
  try {
    final file = await _getFile();
    print(file.path);
    return file.readAsString();
  } catch (e) {
    return null;
  }
}
