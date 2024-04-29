// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DiabetesResultNegative extends StatefulWidget {
  const DiabetesResultNegative({super.key});

  @override
  State<DiabetesResultNegative> createState() => _DiabetesResultNegativeState();
}

class _DiabetesResultNegativeState extends State<DiabetesResultNegative> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Diabetes Result Negative',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            //gif
            Image.asset(
              'assets/negative.gif',
              height: screenHeight * 0.3,
              width: screenWidth * 0.6,
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF3D49),
                foregroundColor: Colors.white,
                minimumSize: Size(screenWidth * 0.5, screenHeight * 0.06),
              ),
              onPressed: () {},
              child: Text('Back to Home',
                  style: TextStyle(fontSize: screenHeight * 0.02)),
            ),
          ],
        ),
      ),
    );
  }
}
