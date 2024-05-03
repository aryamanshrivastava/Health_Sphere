// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:health_sphere/screens/history.dart';
import 'package:health_sphere/screens/profile.dart';
import 'package:health_sphere/screens/tips.dart';


import '../data/healthtips.dart';
import 'diabetes/diabeties.dart';
import 'liver/liver.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? currentUser;
  late String uid;
  String userName = ""; // Define a variable to hold the user's name

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    if (currentUser != null) {
      uid = currentUser!.uid;
      fetchUserData(uid).then((DocumentSnapshot userData) {
        if (userData.exists && userData.data() != null) {
          // Access user data from the snapshot and update the UI
          setState(() {
            // Example of accessing user name and updating UI
            userName = userData['name'];
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
      print("Error fetching user data: $error");
      return Future.error(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Color(0xFFEF3D49),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: GNav(
              color: Colors.white,
              activeColor: Colors.black,
              backgroundColor: Color(0xFFEF3D49),
              tabBackgroundColor: Colors.white,
              padding: EdgeInsets.all(8),
              onTabChange: _onItemTapped,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: " Home",
                ),
                GButton(
                  icon: Icons.history,
                  text: " History",
                ),
                GButton(
                  icon: Icons.tips_and_updates_outlined,
                  text: " Health Tips",
                ),
                GButton(
                  icon: Icons.person,
                  text: " Profile",
                ),
              ]),
          ),
        ),
        backgroundColor: Colors.white,
        body: _getScreen(_selectedIndex, h, w),
      ),
    );
  }

  Widget _getScreen(int index, double h, double w) {
    switch (index) {
      case 0:
        return Padding(
          padding:
              EdgeInsets.fromLTRB(w * 0.04, h * 0.03, w * 0.04, h * 0.01),
          child: Column(
            children: [
              SizedBox(width: w * 0.05),
              Row(
                children: [
                  Text(
                    "Hi",
                    style: TextStyle(
                        color: Color(0xFF282828),
                        fontWeight: FontWeight.w500,
                        fontSize: h * 0.032),
                  ),
                  SizedBox(width: w * 0.015),
                  userName.isEmpty
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          '$userName,',
                          style: TextStyle(
                              color: Color(0xffEF3D49),
                              fontWeight: FontWeight.bold,
                              fontSize: h * 0.032),
                        ),
                ],
              ),
              Text(
                "Got yourself tested? Here, choose any option and find out.",
                style: TextStyle(
                    fontSize: h * 0.025,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: h * 0.02,
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
                  color: Color(0xffEf3d49),
                ),
                width: w,
                height: h * 0.25,
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Liver();
                        }));
                      },
                      child: Container(
                        width: w * 0.35,
                        height: h * 0.20,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 0.5,
                              blurRadius: 3,
                              blurStyle: BlurStyle.outer,
                              offset: Offset(1, 1),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(h * 0.03),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: w * 0.25,
                              height: h * 0.1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/liver.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: h * 0.01),
                            Text('Liver',
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
                          return Diabeties();
                        }));
                      },
                      child: Container(
                        width: w * 0.35,
                        height: h * 0.20,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 0.5,
                              blurRadius: 3,
                              blurStyle: BlurStyle.outer,
                              offset: Offset(1, 1),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(h * 0.03),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: w * 0.2,
                              height: h * 0.1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/diabetes.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: h * 0.01),
                            Text('Diabetes',
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
              ),
              SizedBox(height: h * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Health Tips',
                      style: TextStyle(
                          fontSize: h * 0.028,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.bold)),
                  Text('See All',
                      style: TextStyle(
                          fontSize: h * 0.018,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: h * 0.02),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    HealthTips tip = healthTips[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
                      margin: EdgeInsets.only(bottom: h * 0.015),
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: w * 0.2,
                            height: h * 0.1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(tip.imageUrl),
                              ),
                            ),
                          ),
                          SizedBox(width: w * 0.05),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip.title,
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: h * 0.005),
                              SizedBox(
                                width: w * 0.55,
                                child: Text(
                                  tip.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: h * 0.015,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      case 1:
        return History();
      case 2:
        return Tips();
      case 3:
        return Profile();
      default:
        return Container();
    }
  }
}
