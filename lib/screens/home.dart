// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';

import '../data/healthtips.dart';
import 'diabetes/diabeties.dart';
import 'liver/liver.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.orange.shade500,
        //   title: Text('HealthSphere',
        //       style: TextStyle(fontWeight: FontWeight.bold)),
        //   centerTitle: true,
        // ),
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.03),
          child: Column(
            children: [
              SizedBox(
                height: h * 0.02,
              ),
              Row(
                children: [
                  Text(
                    "Hi",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: h * 0.025),
                  ),
                  SizedBox(width: w * 0.015),
                  Text(
                    "Avik,",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontSize: h * 0.025),
                  ),
                ],
              ),
              Text(
                "Got yourself checked? Here, choose any option and find out.",
                style: TextStyle(
                    fontSize: h * 0.025,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(h * 0.02),
                  color: Color.fromARGB(255, 238, 232, 232),
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
                          border: Border.all(color: Colors.black, width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(h * 0.02),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: w * 0.3,
                              height: h * 0.1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/liver.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: h * 0.03),
                            Text('LIVER',
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
                          border: Border.all(color: Colors.black, width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(h * 0.02),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: w * 0.2,
                              height: h * 0.1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/dia.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: h * 0.03),
                            Text('DIABETES',
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
              SizedBox(height: h * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Health Tips',
                      style: TextStyle(
                          fontSize: h * 0.018,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold)),
                  Text('See All',
                      style: TextStyle(
                          fontSize: h * 0.018,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: h * 0.0),
              Row(
                children: [
                  Text('Health Tips',
                      style: TextStyle(
                          fontSize: h * 0.028,
                          color: Color(0xff000000),
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
                      margin: EdgeInsets.only(bottom: h * 0.02),
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
                              SizedBox(height: h * 0.008),
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
        ),
      ),
    );
  }
}
