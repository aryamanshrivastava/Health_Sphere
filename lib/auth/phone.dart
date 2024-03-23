// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import 'otp.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  bool isNotificationEnabled = true;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Form(
        key: formKey,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Welcome to\nHealthSphere',
                  style: TextStyle(
                      fontSize: h * 0.04, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: h * 0.04,
              ),
              Text(
                'Phone',
                style: TextStyle(fontSize: h * 0.02, color: Colors.black),
              ),
              SizedBox(
                height: h * 0.01,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                style: TextStyle(
                    fontSize: h * 0.02,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Enter your phone number',
                  hintStyle: TextStyle(fontSize: h * 0.02),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(h * 0.01),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(h * 0.01),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  final phoneRegExp = RegExp(r'^\+?[1-9]\d{1,14}$');
                  if (!phoneRegExp.hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: h * 0.04,
              ),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          verifyPhone();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(w * 0.9, h * 0.06),
                        backgroundColor: Colors.orange.shade500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(h * 0.01),
                        ),
                      ),
                      child: Text('Continue',
                          style: TextStyle(fontSize: h * 0.02)),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void verifyPhone() async {
    final phone = '+91${phoneController.text.trim()}';
    print(phone);
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
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
      await authService.verifyPhoneNumber(
        phone,
        verificationCompleted,
        verificationFailed,
        codeSent,
        codeAutoRetrievalTimeout,
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      handleError(e);
    }
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithCredential(credential);
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      handleError(e);
    }
  }

  void verificationFailed(FirebaseAuthException e) {
    Navigator.of(context, rootNavigator: true).pop();
    handleError(e);
  }

  void codeSent(String verificationId, int? resendToken) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Otp(verificationId: verificationId),
      ),
    );
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    Navigator.of(context, rootNavigator: true).pop();
    print('Timeout - The verification code was not auto-retrieved');
  }

  void handleError(dynamic error) {
    final snackBar = SnackBar(content: Text('An error occurred: $error'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
