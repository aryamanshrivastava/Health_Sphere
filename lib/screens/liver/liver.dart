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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    sendData(1, imageUrl);
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
        // print('Response: ${response.body}');
        // if (response.body == '1') {
        //   Navigator.pushNamed(context, '/liver_result_positive');
        // } else {
        //   Navigator.pushNamed(context, '/liver_result_negative');
        // }
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
      CircularProgressIndicator();
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
                    Text("Upload from Device", style: TextStyle(fontSize: 20)),
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
        backgroundColor: Color(0xFFEF3d49),
        title: const Text(
            'Manual Entry',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
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
                      Text(
                        "Liver",
                        style: TextStyle(
                            color: Color(0xFFEF3D49),
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.10),
                      ),
                      SizedBox(height: h * 0.03),
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
                          ] ,
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
          ] ,
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
