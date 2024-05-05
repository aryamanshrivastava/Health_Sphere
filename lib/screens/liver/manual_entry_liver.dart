// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';
import 'package:health_sphere/screens/result.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ManualEntryLiver extends StatefulWidget {
  const ManualEntryLiver({super.key});

  @override
  ManualEntryLiverState createState() => ManualEntryLiverState();
}

class ManualEntryLiverState extends State<ManualEntryLiver> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController totalBilirubinController =
      TextEditingController();
  final TextEditingController directBilirubinController =
      TextEditingController();
  final TextEditingController alkalinePhosphataseController =
      TextEditingController();
  final TextEditingController alamineAminotransferaseController =
      TextEditingController();
  final TextEditingController aspartateAminotransferaseController =
      TextEditingController();
  final TextEditingController totalProteinController = TextEditingController();
  final TextEditingController albuminController = TextEditingController();
  final TextEditingController albuminAndGlobulinRatioController =
      TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    genderController.dispose();
    totalBilirubinController.dispose();
    directBilirubinController.dispose();
    alkalinePhosphataseController.dispose();
    alamineAminotransferaseController.dispose();
    aspartateAminotransferaseController.dispose();
    totalProteinController.dispose();
    albuminController.dispose();
    albuminAndGlobulinRatioController.dispose();
    super.dispose();
  }

  String prediction = "";
  int status = -1;

  Future<void> sendData() async {
    Map<String, dynamic> jsonData = {
      "disease_value": 1,
      "upload_type": "M",
      "parameters": [
        {
          "age": int.parse(ageController.text),
          "gender": int.parse(genderController.text),
          "total_bilirubin": double.parse(totalBilirubinController.text),
          "direct_bilirubin": double.parse(directBilirubinController.text),
          "alp": double.parse(alkalinePhosphataseController.text),
          "sgpt": double.parse(alamineAminotransferaseController.text),
          "sgot": double.parse(aspartateAminotransferaseController.text),
          "total_proteins": double.parse(totalProteinController.text),
          "albumin": double.parse(albuminController.text),
          "a:g_ratio": double.parse(albuminAndGlobulinRatioController.text)
        }
      ] 
    };

    print(jsonData);
    String requestBody = jsonEncode(jsonData);

    try{
      var response = await http.post(
        Uri.parse('http://192.168.211.34:5000/predict'),
        headers: <String, String>{
          'Content-Type' : 'application/json; charset=UTF-8',
        },
        body: requestBody
      );
      if (response.statusCode == 200) {
        print('Request successful: ${response.body}');
        final jsonOutput = json.decode(response.body);
        setState(() {
          prediction = jsonOutput['prediction'];
          status = jsonOutput['status'];

          if (status == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiseaseResult(
                diseasePrediction : prediction,
                diseaseStatus : status,
              )
            )
            );
          } else if (status == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiseaseResult(
                diseasePrediction : prediction,
                diseaseStatus : status,
                )
              )
            );
          }
        });
      } else {
        print('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFEF3d49),
        title: const Text(
          'Manual Entry',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Age',
                  controller: ageController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Gender [Male : 0, Female : 1]',
                  controller: genderController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Total Bilirubin (mg/dL)',
                  controller: totalBilirubinController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Direct Bilirubin (mg/dL)',
                  controller: directBilirubinController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Alkaline Phosphatase (ALP) (IU/L)',
                  controller: alkalinePhosphataseController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Alanine Aminotransferase (SGPT/ALT) (IU/L)',
                  controller: alamineAminotransferaseController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Aspartate Aminotransferase (SGOT/AST) (IU/L)',
                  controller: aspartateAminotransferaseController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Total Protein (g/dL)',
                  controller: totalProteinController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Albumin (g/dL)',
                  controller: albuminController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Albumin and Globulin Ratio',
                  controller: albuminAndGlobulinRatioController,
                ),
                _sizedBox(screenHeight),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      sendData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEF3D49),
                    minimumSize: Size(screenWidth * 0.9, screenHeight * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text('Submit',
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                ),
                _sizedBox(screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    required TextEditingController controller,
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black38),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          suffix: Column(
            children: [
              GestureDetector(
                onTap: () {
                  controller.text =
                      (double.parse(controller.text) + 0.1).toStringAsFixed(2);
                },
                child: SizedBox(
                    height: 10,
                    width: 20,
                    child: Icon(Icons.arrow_drop_up, color: Colors.black)),
              ),
              GestureDetector(
                onTap: () {
                  controller.text =
                      (double.parse(controller.text) - 0.1).toStringAsFixed(2);
                },
                child: SizedBox(
                    height: 10,
                    width: 20,
                    child: Icon(Icons.arrow_drop_down, color: Colors.black)),
              ),
            ],
          )),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget _sizedBox(double height) {
    return SizedBox(height: height * 0.02);
  }
}
