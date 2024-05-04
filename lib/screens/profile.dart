// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unnecessary_string_interpolations, use_key_in_widget_constructors, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_sphere/auth/phone.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User? currentUser;
  late String uid;
  String userName = "";
  String userEmail = "";
  String userPhoneNumber = "";
  String userAge = "";
  String userGender = "";

  @override
  void initState() {
    super.initState();
    currentUser = auth.currentUser;
    if (currentUser != null) {
      uid = currentUser!.uid;
      fetchUserData(uid).then((DocumentSnapshot userData) {
        if (userData.exists && userData.data() != null) {
          // Access user data from the snapshot and update the UI
          setState(() {
            // Example of accessing user name and updating UI
            userName = userData['name'];
            userEmail = userData['email'];
            userPhoneNumber = userData['phone'];
            userGender = userData['gender'];
            userAge = userData['age'];
          });
        }
      });
    } else {
      CircularProgressIndicator();
    }
  }

  Future<DocumentSnapshot> fetchUserData(String uid) async {
    try {
      // Get reference to the user document using the provided UID
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Fetch the user document
      DocumentSnapshot userSnapshot = await userRef.get();

      return userSnapshot;
    } catch (error) {
      // Handle any errors that occur
      return Future.error(error.toString());
    }
  }

  Future<void> _logout(BuildContext context) async {
      await auth.signOut();
      // Navigate to login screen or home screen
      // For example:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PhoneAuth()
        )
    );
  }

  String _getUserImage(String gender) {
    if(gender == "Male" || gender == "male")
      return 'assets/man.png';
    else if(gender == "Female" || gender == "female")
      return 'assets/woman.png';
    else
      return 'assets/profile.png';
  }

  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
            body:SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.03),
                  Center(
                    child: Text(
                      "This section contains your personal information.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.04),
                  Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage(_getUserImage(userGender)),
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
                                  '$userName', 
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
                                  '$userEmail', 
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
                              '$userPhoneNumber', 
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
                                  '$userAge years', 
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                SizedBox(width: w * 0.36),
                                Text(
                                  '$userGender', 
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
                        SizedBox(height: h * 0.05),
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
                            onPressed: () => _logout(context),
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