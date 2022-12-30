import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class SavePage extends StatefulWidget {
  final String imgbyte;
  SavePage({Key? key, required this.imgbyte});
  @override
  _SavePage createState() => _SavePage();
}

class _SavePage extends State<SavePage> {
  Future<List<Directory>?> _getExternalStoragePath() {
    return getExternalStorageDirectories(type: StorageDirectory.documents);
    // return getExternalStorageDirectories();
  }

  //String _fileFullPath;

  Future _writeExternalStorage(Uint8List bytes) async {
    final dirList = await _getExternalStoragePath();
    final path = dirList![0].path;
    final file = File('$path/abc.png');
    // TODO: implement file import

    file.writeAsBytes(bytes).then((File file) {});
  }

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = const Base64Codec().decode(widget.imgbyte);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SteganoGraphy"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.all(12.0),
                height: 450.0,
                width: 350.0,
                child: Image.memory(bytes),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.black,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _writeExternalStorage(bytes);
                  },
                  child: const Text('Save Image'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
