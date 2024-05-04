// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      // Navigate to login screen or home screen
      // For example:
      // Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
            body:SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.01),
                  Center(
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox( 
                        width: w * 0.5,
                        height: h * 0.3,
                        child: Image.asset(
                        'assets/logo_1.png',
                        ),
                      )
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                          children: [
                          Container(
                                  width: 25, 
                                  height: 25, 
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: AssetImage('assets/profile.png'), // Path to your image
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            SizedBox(width: w*0.02),
                            Text(
                              "Name", 
                              style: TextStyle(
                                color: Color(0xffef3d49),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )]
                          ),
                          Row(
                            children: [
                              SizedBox(width: w * 0.08),
                              Text(
                                  "Aryaman Shrivastava", 
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: h * 0.02),
                            Row(
                              children: [
                                Container(
                                      width: 25, 
                                      height: 25, 
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          image: AssetImage('assets/email.png'), // Path to your image
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                SizedBox(width: w*0.02),
                                Text(
                                  "Email address", 
                                  style: TextStyle(
                                    color: Color(0xffef3d49),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: w * 0.08),
                                Text(
                                  "aryamans135@yahoo.com", 
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: h * 0.02),
                            Row(
                              children: [
                                Container(
                                  width: 25, 
                                  height: 25, 
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle ,
                                    image: DecorationImage(
                                      image: AssetImage('assets/phone-call.png'), // Path to your image
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            SizedBox(width: w*0.02),
                            Text(
                              "Phone Number", 
                              style: TextStyle(
                                color: Color(0xffef3d49),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: w * 0.08),
                            Text(
                              "+91-7067250520", 
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 0.02),
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                      width: 25, 
                                      height: 25, 
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          image: AssetImage('assets/old-age.png'), // Path to your image
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: w*0.02),
                                    Text(
                                      "Age", 
                                      style: TextStyle(
                                        color: Color(0xffef3d49),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(
                                      width: w*0.4,
                                    ),
                                    Container(
                                      width: 25, // Adjust the width as needed
                                      height: 25, // Adjust the height as needed
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle ,
                                        image: DecorationImage(
                                          image: AssetImage('assets/gender.png'), // Path to your image
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: w*0.02),
                                    Text(
                                      "Gender", 
                                      style: TextStyle(
                                        color: Color(0xffef3d49),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: w * 0.08),
                                Text(
                                  "22", 
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                SizedBox(width: w * 0.5),
                                Text(
                                  "Male", 
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: h * 0.02),
                          ],
                        ),
                        SizedBox(height: h * 0.09),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {

                              },
                              icon: Icon(Icons.edit),
                              label: Text(
                                "Edit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                            ),
                            style: ElevatedButton.styleFrom(
                              iconColor: Colors.white, // Background color
                              backgroundColor: Colors.black, // Text color
                              minimumSize: Size(w * 0.40, h * 0.06),
                              shape: RoundedRectangleBorder( // Button border radius
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 3,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _logout();
                            },
                            icon: Icon(Icons.logout_rounded),
                            label: Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              iconColor: Colors.white, // Background color
                              backgroundColor: Colors.black, // Text color
                              minimumSize: Size(w * 0.40, h * 0.06),
                              shape: RoundedRectangleBorder( // Button border radius
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
              ),
            )
          )
        );
  }
}