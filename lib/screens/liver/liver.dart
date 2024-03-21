// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'manual_entry_liver.dart';

class Liver extends StatefulWidget {
  const Liver({super.key});

  @override
  State<Liver> createState() => _LiverState();
}

class _LiverState extends State<Liver> {
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
          title: Text("Choose an option", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
        backgroundColor: Color(0xff050B29),
        appBar: AppBar(
          backgroundColor: Color(0xffB9FFB7),
          title: Text('Liver', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.03),
            child: Column(
              children: [
                 Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showOptionsDialog();
                    },
                    child: Container(
                      width: w * 0.43,
                      height: h * 0.25,
                      decoration: BoxDecoration(
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
                          SizedBox(height: h * 0.01),
                          Text('UPLOAD REPORT',
                              style: TextStyle(
                                  fontSize: h * 0.025,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ManualEntryLiver();
                      }));
                    },
                    child: Container(
                      width: w * 0.43,
                      height: h * 0.25,
                      decoration: BoxDecoration(
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
                          SizedBox(height: h * 0.01),
                          Text('MANUAL ENTRY',
                              style: TextStyle(
                                  fontSize: h * 0.025,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ],
            )));
  }
}
 