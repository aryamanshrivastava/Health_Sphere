// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'manual_entry_diabeties.dart';

class Diabeties extends StatefulWidget {
  const Diabeties({super.key});

  @override
  State<Diabeties> createState() => _DiabetiesState();
}

class _DiabetiesState extends State<Diabeties> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ImagePicker imagePicker = ImagePicker();
  final String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.jpeg';
  String imageUrl = '';
  File? image;
  bool isImageLoaded = false;
  Future<void> pickImage(ImageSource source) async {
    final XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      setState(() {
        image = File(file.path);
        isImageLoaded = true;
      });
      uploadImage(file.path);
    }
  }

  Future<void> uploadImage(String filePath) async {
    Reference reference =
        FirebaseStorage.instance.ref('images/$uniqueFileName');
    try {
      await reference.putFile(
          File(filePath), SettableMetadata(contentType: 'image/jpeg'));
      imageUrl = await reference.getDownloadURL();
      setState(() {
        isImageLoaded = false;
      });
      showFinalDialog(imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void showFinalDialog(String imageUrl) {
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
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    sendData(2, imageUrl);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return Scaffold(backgroundColor: Colors.yellow);
                    // }));
                  },
                  child: Text("Proceed"),
                ),
              ],
            ));
      },
    );
  }

  void sendData(int btnId, String imageUrl) async {
    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload an image')));
      return;
    }
    Map<String, dynamic> data = {
      'disease_value': btnId,
      'image_url': imageUrl,
    };
    print('$data');
    try {
      final response = await http.post(
        Uri.parse('http://10.100.167.73:5000/predict'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        // print('Data sent successfully');
        // print('Response: ${response.body}');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        firestore.collection('users').doc(currentUser.uid).get().then((value) {
          if (value.exists) {
            return firestore
                .collection('users')
                .doc(currentUser.uid)
                .update(data);
          } else {
            print('Document does not exist');
            return null;
          }
        });
      } else {
        // No user is logged in, handle accordingly
        print('No user currently logged in');
        return null;
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
                  title: Text("Upload from Device",
                      style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  }),
              ListTile(
                  title: Text("Use Camera", style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  }),
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
            // backgroundColor: Colors.orange.shade500,
            // title:
            //     Text('Diabeties', style: TextStyle(fontWeight: FontWeight.bold)),
            // centerTitle: true,
            ),
        body: Center(
          child: isImageLoaded
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Uploading Image...'),
                  ],
                ))
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.06, vertical: h * 0.03),
                  child: Column(
                    children: [
                      SizedBox(
                        height: h * 0.075,
                      ),
                      Text(
                        "Diabetes",
                        style: TextStyle(
                            color: Color(0xFFEF3D49),
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.10),
                      ),
                      SizedBox(height: h * 0.03),
                      Text(
                        "Got your diabetes test report. Here choose any option to get the results.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: h * 0.025, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            optionCard(
                                h, w, 'UPLOAD REPORT', 'assets/upload.png', () {
                              showOptionsDialog();
                            }),
                            SizedBox(width: w * 0.07),
                            optionCard(
                                h, w, 'MANULA ENTRY', 'assets/manual.png', () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ManualEntryDiabetes();
                              }));
                            }),
                          ],
                        ),
                      ),
                    ],
                  )),
        ));
  }

  Widget optionCard(
      double h, double w, String text, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w * 0.4,
        height: h * 0.25,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
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
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: h * 0.03),
            Text(text,
                style: TextStyle(
                    fontSize: h * 0.025, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}