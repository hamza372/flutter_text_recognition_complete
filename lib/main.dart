import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String result = '';
  late ImagePicker imagePicker;
  late TextRecognizer textDetector;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    textDetector = GoogleMlKit.vision.textRecognizer();
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    File image = File(pickedFile!.path);
    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  _imgFromGallery() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  doTextRecognition() async {
    final inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognisedText = await textDetector.processImage(inputImage);
    String text = recognisedText.text;
    setState(() {
      result = text;
    });
    for (TextBlock block in recognisedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg2.jpg'), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 100,
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/notebook.png'),
                      fit: BoxFit.cover),
                ),
                height: 280,
                width: 250,
                margin: EdgeInsets.only(top: 70),
                padding: EdgeInsets.only(left: 28, bottom: 5, right: 18),
                child: SingleChildScrollView(
                    child: Text(
                      '$result',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontFamily: 'solway', fontSize: 10),
                    )),
              ),

              Container(
                margin: EdgeInsets.only(top: 20, right: 140),
                child: Stack(children: <Widget>[
                  Stack(children: <Widget>[
                    Center(
                      child: Image.asset(
                        'images/clipboard.png',
                        height: 240,
                        width: 240,
                      ),
                    ),
                  ]),
                  Center(
                    child: FlatButton(
                      onPressed: _imgFromGallery,
                      onLongPress: _imgFromCamera,
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: _image != null
                            ? Image.file(
                          _image!,
                          width: 140,
                          height: 192,
                          fit: BoxFit.fill,
                        )
                            : Container(
                          width: 140,
                          height: 150,
                          child: Icon(
                            Icons.find_in_page,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
