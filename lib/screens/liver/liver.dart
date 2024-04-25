// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String imageUrl = '';
  ImagePicker imagePicker = ImagePicker();
  File? image;
  bool isImageLoaded = false;
  Future<void> pickImage(ImageSource source) async {
    final XFile? file = await imagePicker.pickImage(source: source);
    print('${file?.path}');
    if (file != null) {
      setState(() {
        image = File(file.path);
        isImageLoaded = true;
      });
      String uniqueFileName = 'b.jpeg';
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);
      try {
        await referenceImageToUpload.putFile(
            io.File(file.path), SettableMetadata(contentType: "image/jpeg"));
        imageUrl = await referenceImageToUpload.getDownloadURL();
        setState(() {
          isImageLoaded = false;
        });
        showFinalDialog(imageUrl);
      } catch (error) {
        print('Error uploading image: $error');
      }
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    sendData(1, imageUrl);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Scaffold(backgroundColor: Colors.yellow);
                    }));
                  },
                  child: Text("Proceed"),
                ),
              ],
            ));
      },
    );
  }

  void sendData(int btnId, String imageUrl) async {
    String url = 'http://192.168.56.1:5000/predict';

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
    String jsonData = jsonEncode(data);
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

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );
      if (response.statusCode == 200) {
        print('Data sent successfully');
        print('Response: ${response.body}');
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
        body: Center(
          child: isImageLoaded
              ? CircularProgressIndicator()
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.06, vertical: h * 0.03),
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
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
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
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
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
                  )),
        ));
  }
}
