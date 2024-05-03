// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../screens/home.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedGender = 'Male';
  List<String> genderOptions = ['Male', 'Female', 'Other'];
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffef3d49),
        title: Text('Sign Up',
            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.03),
          child: SingleChildScrollView(child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter the following details to create an account.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
              ),
              Image.asset(
                'assets/document.png',
                width: w * 0.5,
                height: h * 0.30,
              ),
              SizedBox(
                height: h * 0.03,
              ),
              buildTextFormField(
                  labelText: 'Name',
                  controller: nameController,
                  keyboard: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    final nameRegExp = RegExp(r'^[A-Za-z ]+$');
                    if (!nameRegExp.hasMatch(value)) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  }),
              sizedBox(h),
              buildTextFormField(
                  labelText: 'Email',
                  controller: emailController,
                  keyboard: TextInputType.emailAddress,
                  validator: (value) {
                    final emailRegExp =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegExp.hasMatch(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }),
              sizedBox(h),
              buildTextFormField(
                  labelText: 'Age',
                  controller: ageController,
                  keyboard: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  }),
              sizedBox(h),
              // gender dropdown
              DropdownButtonFormField(
                focusColor: Colors.white,
                dropdownColor: Colors.white,  
                value: selectedGender,
                hint: Text('Select Gender'),
                onChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue!;
                  });
                },
                items: genderOptions.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
              sizedBox(h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(w * 0.9, h * 0.06),
                  backgroundColor: Color(0xFFEF3D49),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  //send data to the firebase
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Something went wrong. Please try again later.'),
                        ),
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Center(
                          child: SpinKitThreeInOut(
                            color: Color(0xffC471ED),
                            size: 50.0,
                          ),
                        );
                      },
                    );
                    Future.delayed(Duration(milliseconds: 100), () async {
                      final CollectionReference collection =
                          FirebaseFirestore.instance.collection('users');
                      await collection.doc(uid).set({
                        'uid': uid,
                        'phone': FirebaseAuth.instance.currentUser!.phoneNumber,
                        'name': nameController.text,
                        'email': emailController.text,
                        'age': ageController.text,
                        'gender':selectedGender,
                      }, SetOptions(merge: true)).then((_) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$error'),
                          ),
                        );
                      });
                    });
                  }
                },
                child: Text('Submit', style: TextStyle(fontSize: 22)),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildTextFormField({
    required String labelText,
    required TextInputType keyboard,
    required String? Function(String?) validator,
    required TextEditingController controller,
  }) {
    return TextFormField(
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black38),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        controller: controller,
        validator: validator);
  }

  Widget sizedBox(double height) {
    return SizedBox(height: height * 0.02);
  }
}
