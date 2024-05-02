// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/phone.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), checkLoginStatus);
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PhoneAuth()));
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/logo_1.png')),
            SizedBox(height: h * 0.02),
            Text('HealthSphere',
                style: TextStyle(
                    fontSize: h * 0.05,
                    color: Color(0xFFEF3D49),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontStyle: FontStyle.normal,
                  )
            ),
            Text('Stay healthy',
                style: TextStyle(
                    fontSize: h * 0.028,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontStyle: FontStyle.normal
                  )
            ),
          ],
        )));
  }
}
