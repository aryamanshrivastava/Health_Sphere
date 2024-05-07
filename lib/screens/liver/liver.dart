// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'manual_entry_liver.dart';
import 'package:health_sphere/screens/result.dart';

class Liver extends StatefulWidget {
  const Liver({super.key});

  @override
  State<Liver> createState() => _LiverState();
}

class _LiverState extends State<Liver> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker imagePicker = ImagePicker();
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
      showFinalDialog(imageUrl, 'O');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void showFinalDialog(String imageUrl, String uploadType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Image uploaded successfully,\nWait for the results!",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffEF3D49),
                        foregroundColor: Color(0xffFFFFFF),
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffEF3D49),
                      foregroundColor: Color(0xffFFFFFF),
                      minimumSize: Size(100, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    Navigator.pop(context);
                    sendData(1, uploadType, imageUrl);
                  },
                  child: Text("Proceed"),
                ),
              ],
            ));
      },
    );
  }

  void sendData(int btnId, String uploadType, String imageUrl) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEF3D49)),
          ),
        );
      },
    );
    if (imageUrl.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload an image')));
      return;
    }

    String prediction = "";
    int status = -1;

    Map<String, dynamic> data = {
      'disease_value': btnId,
      'upload_type': uploadType,
      'image_url': imageUrl,
    };
    print('$data');
    try {
      final response = await http.post(
        Uri.parse('http://192.168.211.34:5000/predict'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print('Request successful: ${response.body}');
        final jsonOutput = json.decode(response.body);
        setState(() {
          prediction = jsonOutput['prediction'];
          status = jsonOutput['status'];

          if (status == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiseaseResult(
                          diseasePrediction: prediction,
                          diseaseStatus: status,
                        )));
          } else if (status == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiseaseResult(
                          diseasePrediction: prediction,
                          diseaseStatus: status,
                        )));
          }
        });
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
          title: Text("Choose an option", style: TextStyle(fontSize: 25)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                splashColor: Color(0xFFEF3D49),
                title: Text("Upload from device",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                splashColor: Color(0xFFEF3D49),
                title: Text("Use camera",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
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
          backgroundColor: Color(0xFFEF3d49),
          title: const Text(
            'Liver',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: isImageLoaded
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                       valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEF3D49))
                    ),
                    SizedBox(height: h * 0.01,),
                    Text('Uploading Image...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.06, vertical: h * 0.03),
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.01),
                      Text(
                        "Got your liver function test report. Here choose any option to get the results.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: h * 0.025, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 0.75,
                              blurRadius: 2.5,
                              blurStyle: BlurStyle.inner,
                              offset: Offset(-1, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(h * 0.03),
                          color: Color(0xFFEF3D49),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            optionCard(h, w, 'Upload\nReport',
                                'assets/upload.png', showOptionsDialog),
                            SizedBox(width: w * 0.07),
                            optionCard(
                                h, w, 'Manual\nEntry', 'assets/manual.png', () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ManualEntryLiver();
                              }));
                            }),
                          ],
                        ),
                      )
                    ],
                  )),
        ));
  }

  Widget optionCard(
      double h, double w, String text, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w * 0.35,
        height: h * 0.24,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFef3d49),
              spreadRadius: 0.75,
              blurRadius: 2.5,
              blurStyle: BlurStyle.inner,
              offset: Offset(-1, 0),
            ),
          ],
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(h * 0.02),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: h * 0.025, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
