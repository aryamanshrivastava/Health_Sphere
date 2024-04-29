// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously, avoid_print
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../screens/home.dart';
import '../provider/provider.dart';
import '../userdata/userdata.dart';

class Otp extends StatefulWidget {
  final String verificationId;
  const Otp({
    super.key,
    required this.verificationId,
  });

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String? otp;
  String? verificationId;
  int resendTime = 60;
  late Timer countdownTimer;
  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId;
    startTimer();
  }

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTime > 0) {
        setState(() {
          resendTime--;
        });
      } else {
        countdownTimer.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }

  String stringFormatting(n) => n.toString().padLeft(2, '0');
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          // title: Text(
          //   'Enter OTP',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
        ),
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please Enter the One Time Password Received on your Phone',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: h * 0.02,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/password.png',
                  width: w * 0.5,
                  height: h * 0.2,
                ),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              SizedBox(
                height: h * 0.03,
              ),
              Center(
                child: Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                      width: w * 0.11,
                      height: h * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(h * 0.01),
                      ),
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.w600)),
                  onCompleted: (value) {
                    setState(() {
                      otp = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    submitOtp();
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
                      style:
                          TextStyle(fontSize: h * 0.02, color: Colors.white)),
                ),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              resendTime > 0
                  ? Center(
                      child: Text(
                          'Resend OTP in ${stringFormatting(resendTime)} seconds(s)',
                          style: TextStyle(
                              fontSize: h * 0.015, color: Colors.black)),
                    )
                  : Center(
                      child: TextButton(
                        onPressed: () async {
                          String phoneNumber =
                              FirebaseAuth.instance.currentUser!.phoneNumber!;
                          await Provider.of<AuthService>(context, listen: false)
                              .resendOtp(phoneNumber, (verificationId,
                                  [forceResendingToken]) {
                            setState(() {
                              this.verificationId = verificationId;
                              resendTime = 60;
                              startTimer();
                            });
                          });
                        },
                        child: Text('Resend OTP',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: h * 0.02,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitOtp() async {
    if (otp != null && otp!.length == 6) {
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
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp!,
      );
      try {
        final user = await Provider.of<AuthService>(context, listen: false)
            .signInWithCredential(credential);
        if (user != null) {
          String uid = user.uid;
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          if (userDoc.exists) {
            String? name = userDoc.data()?['name'];
            if (name != null && name.isNotEmpty && uid.isNotEmpty) {
              Future.delayed(Duration(seconds: 1), () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              });
            }
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const UserData()),
              (Route<dynamic> route) => false,
            );
            // Navigator.of(context).pushReplacementNamed('/userdata');
          }
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          final snackBar = SnackBar(content: Text('Failed to get user data.'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (error) {
        Navigator.of(context, rootNavigator: true).pop();
        final snackBar = SnackBar(content: Text('An error occurred: $error'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final snackBar = SnackBar(content: Text('Please enter a valid OTP.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
