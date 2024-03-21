// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:helath_sphere/screens/diabeties/diabeties.dart';
import 'package:helath_sphere/screens/liver/liver.dart';

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
        backgroundColor: Color(0xff050B29),
        appBar: AppBar(
          backgroundColor: Color(0xffB9FFB7),
          title: Text('HealthSphere',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: 
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.03),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Liver();
                      }));
                    },
                    child: Container(
                      width: w * 0.43,
                      height: h * 0.25,
                      decoration: BoxDecoration(
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
                          SizedBox(height: h * 0.01),
                          Text('LIVER',
                              style: TextStyle(
                                  fontSize: h * 0.025,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Diabeties();
                      }));
                    },
                    child: Container(
                      width: w * 0.43,
                      height: h * 0.25,
                      decoration: BoxDecoration(
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
                          SizedBox(height: h * 0.01),
                          Text('DIABETES',
                              style: TextStyle(
                                  fontSize: h * 0.025,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: h * 0.03),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Health Tips',
              //         style: TextStyle(
              //             fontSize: h * 0.018,
              //             color: Color(0xffffffff),
              //             fontWeight: FontWeight.bold)),
              //     Text('See All',
              //         style: TextStyle(
              //             fontSize: h * 0.018,
              //             color: Color(0xffffffff),
              //             fontWeight: FontWeight.bold)),
              //   ],
              // ),
              // SizedBox(height: h * 0.02),
              // SizedBox(
              //   height: h * 0.52,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     scrollDirection: Axis.vertical,
              //     itemCount: 4,
              //     itemBuilder: (BuildContext context, int index) {
              //       HealthTips tip = healthTips[index];
              //       return Container(
              //         decoration: BoxDecoration(
              //           color: Color(0xffffffff),
              //           borderRadius: BorderRadius.circular(h * 0.02),
              //         ),
              //         margin: EdgeInsets.only(bottom: h * 0.02),
              //         padding: EdgeInsets.all(8.0),
              //         child: Row(
              //           children: [
              //             Container(
              //               width: w * 0.4,
              //               height: h * 0.1,
              //               decoration: BoxDecoration(
              //                 image: DecorationImage(
              //                   image: AssetImage('assets/1.png'),
              //                 ),
              //               ),
              //             ),
              //             SizedBox(width: w * 0.02),
              //             Text(
              //               tip.title,
              //               style: TextStyle(
              //                 color: Color(0xff000000),
              //                 fontSize: h * 0.02,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
