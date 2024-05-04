// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../data/healthtips.dart';

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: h * 0.03),
              SizedBox(
                width: w,
                child: Text(
                  "These are some of the simple tips to stay healthy.", 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                  ),
                ),
              ),
              SizedBox(height: h * 0.02),
              Expanded(
                child: ListView.builder(
                  itemCount: healthTips.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    HealthTips tip = healthTips[index];
                    return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(h * 0.02),
                          ),
                          margin: EdgeInsets.only(bottom: h * 0.015),
                          padding: EdgeInsets.all(10),
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
                                      textAlign: TextAlign.justify,
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
                          )
                    );
              }
          )
        ),

            ],
          ),
      )
    ));
  }
}