import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class StorageHelper extends GetxController {
  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localfile async {
    final path = await _localPath;

    return File('$path/location_data.txt');
  }

  Future<void> deleteFileData() async {
    final file = await _localfile;

    await file.writeAsString('');
  }

  Future<void> write(String text) async {
    final file = await _localfile;
    final sink = file.openWrite(mode: FileMode.append);
    sink.write(text);
    await sink.close();
  }

  Future<List<String>> read() async {
    List<String> text = [];
    try {
      final file = await _localfile;
      text = await file.readAsLines();
    } catch (e) {
      print('could not read file');
    }

    return text;
  }
}
