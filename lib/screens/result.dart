// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class DiseaseResult extends StatefulWidget {
  final String diseasePrediction;
  final int diseaseStatus;

  DiseaseResult({required this.diseasePrediction, required this.diseaseStatus});

  @override
  State<DiseaseResult> createState() => _DiseaseResultState();
}

class _DiseaseResultState extends State<DiseaseResult> {
  late String imagePath;

  @override
  void initState() {
    super.initState();
    imagePath = _getGIF(widget.diseaseStatus);
  }
  
  String _getGIF(int status){
    if (status == 0){
      return 'assets/negative.gif';
    } else if (status == 1 || status == 2){
      return 'assets/positive.gif';
    } else {
      return 'assets/upload.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(h*0.02),
          child: Column(
            children: [
              Center(
              child: CircleAvatar(
                  backgroundImage: AssetImage(imagePath),
                ),
              ),
            SizedBox(width: w*0.3, height: h*0.04,),
            Text(
              widget.diseasePrediction)
            ]
            ),
          ),
        ),
      );
  }
}