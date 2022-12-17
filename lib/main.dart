import 'package:flutter/material.dart';
import 'dart:io' as Io;
import 'dart:core';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'save.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Io.File _image;
  var pickedFile;
  //var done;
  late Widget image;
  var _base64;
  final picker = ImagePicker();
  TextEditingController secret = TextEditingController();
  Future getImage(int a) async {
    if (a == 1) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      if (pickedFile != null) {
        _image = Io.File(pickedFile.path);
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future success() async {
    Fluttertoast.showToast(
        msg: "Successfully Encoded the Image!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 3,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0);
    print("ABOUT TO");
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SavePage(imgbyte: _base64)));
  }

  Future _uploadE() async {
    Response response;
    var dio = Dio();
    if (_image == null) {
      print("No file chosen yet!");
    } else {
      final bytes = Io.File(pickedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      response = await dio.post('URL/encode',
          data: {'text': secret.text, 'img': img64}); //replace the URL
      if (response.statusCode == 200) {
        _base64 = response.data.toString();
        success();
      } else {
        print("Some Error Occurred!");
      }
    }
  }

  Future _uploadD() async {
    Response response;
    var dio = Dio();
    if (_image == null) {
      print("No file chosen yet!");
    } else {
      final bytes = Io.File(pickedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      response = await dio
          .post('URL/decode', data: {'img': img64}); //replace the URL
      if (response.statusCode == 200) {
        _base64 = response.data.toString();
        success();
      } else {
        print("Some Error Occurred!");
        //for production view
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    print("Pressing encode~~");
                    // ignore: unnecessary_statements
                    _uploadE();
                  },
                  child: const Text('Encode'),
                ),
              ),
              Container(
                margin: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _uploadD();
                  },
                  child: const Text('Decode'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: 
                // try adding container for conditions
                  // child: _image == null
                  //     ? const Text(
                  //         'No image selected.',
                  //       )
                  //     : Image.file(
                  //         _image,
                  //         height: 250.0,
                  //         width: 250.0,
                  //       ),
                  
                    Image.file(
                      _image,
                      height: 250.0,
                      width: 250.0,
                    )
                ),
              
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  child: TextField(
                    controller: secret,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Secret message',
                      hintText: 'I love Cracker Suman',
                    ),
                  ),
                ),
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
                    getImage(2);
                  },
                  child: const Text('Choose from Gallery'),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getImage(1);
        },
        icon: const Icon(Icons.camera),
        label: const Text("Capture"),
      ),
    );
  }
}
