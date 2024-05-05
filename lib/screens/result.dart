// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

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
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    imagePath = _getGIF(widget.diseaseStatus);
     Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Set opacity to 1.0 to show image
      });
    });
  }
  
  String _getGIF(int status){
    if (status == 0){
      return 'assets/negative_1.png';
    } else if (status == 1){
      return 'assets/positive_1.png';
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
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(h*0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1500),
                opacity: _opacity,
                child: Center(
                  child: CircleAvatar(
                      backgroundImage: AssetImage(imagePath),
                      radius: 100,
                    ),
                ),
              ),
            SizedBox(width: w*0.3, height: h*0.04,),
            Text(
              widget.diseasePrediction
               ,
               style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
               ),)
              ]
            ),
          ),
        ),
      );
  }
}