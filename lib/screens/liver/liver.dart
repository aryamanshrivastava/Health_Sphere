// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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
    showFinalDialog();
  }

  void showFinalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Image Uploaded Successfully,\nWait for the results!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
            content: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    sendData(1, image!.readAsBytesSync());
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Scaffold();
                    }));
                  },
                  child: Text("Proceed"),
                ),
              ],
            ));
      },
    );
  }

  void sendData(int btnId, Uint8List imageBytes) async {
    // Define the URL where you want to send the data
    const url = 'https://example.com/sendData';

    // Convert the image bytes to base64
    String base64Image = base64Encode(imageBytes);
    // Prepare the JSON payload
    Map<String, dynamic> data = {
      'btnId': btnId,
      'image': base64Image,
    };
    print('$data');

    // Convert the data to JSON format
    String jsonData = jsonEncode(data);
    try {
      // Send a POST request with JSON data
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );
      // Check the response status
      if (response.statusCode == 200) {
        print('Data sent successfully');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data: $e');
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
                    Text("Upload from Files", style: TextStyle(fontSize: 20)),
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
          title: Text('Liver', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        return ManualEntryLiver();
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
