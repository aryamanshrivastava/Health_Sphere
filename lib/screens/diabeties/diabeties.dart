// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helath_sphere/screens/diabeties/manual_entry_diabeties.dart';
import 'package:image_picker/image_picker.dart';

class Diabeties extends StatefulWidget {
  const Diabeties({super.key});

  @override
  State<Diabeties> createState() => _DiabetiesState();
}

class _DiabetiesState extends State<Diabeties> {
  ImagePicker imagePicker = ImagePicker();
  File? image;
  Future<void> pickImage(ImageSource source) async {
    final XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      setState(() {
        image = File(file.path);
      });
    }
  }

  void showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title:
                    Text("Upload from Gallery", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                title: Text("Use Camera", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange.shade500,
          title:
              Text('Diabeties', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.03),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showOptionsDialog();
                    },
                    child: Container(
                      width: w * 0.4,
                      height: h * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: w * 0.2,
                            height: h * 0.1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/upload.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.03),
                          Text('UPLOAD REPORT',
                              style: TextStyle(
                                  fontSize: h * 0.025,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.07),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ManualEntryDiabetes();
                      }));
                    },
                    child: Container(
                      width: w * 0.4,
                      height: h * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: w * 0.2,
                            height: h * 0.1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/manual.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.03),
                          Text('MANUAL ENTRY',
                              style: TextStyle(
                                  fontSize: h * 0.025,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
