// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: h * 0.03),
              Text(
                "You don't have any history of disease predictions.",
                style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
              ),
            ],
          ),
        )
      )
    ); 
  }
}