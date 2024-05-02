// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';

class ManualEntryDiabetes extends StatefulWidget {
  const ManualEntryDiabetes({super.key});

  @override
  ManualEntryDiabetesState createState() => ManualEntryDiabetesState();
}

class ManualEntryDiabetesState extends State<ManualEntryDiabetes> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Define diabetes controllers for each TextFormField
  final TextEditingController pregnanciesController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController skinThicknessController = TextEditingController();
  final TextEditingController insulinController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController diabetesPedigreeController =
      TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    pregnanciesController.dispose();
    glucoseController.dispose();
    bloodPressureController.dispose();
    skinThicknessController.dispose();
    insulinController.dispose();
    bmiController.dispose();
    diabetesPedigreeController.dispose();
    ageController.dispose();
    super.dispose();
  }

  String getConcatenatedValues() {
    return '[${pregnanciesController.text}, ${glucoseController.text}, ${bloodPressureController.text}, ${skinThicknessController.text}, ${insulinController.text}, ${bmiController.text}, ${diabetesPedigreeController.text}, ${ageController.text}]';
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFEF3D49),
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
                _buildTextFormField(
                  labelText: 'No. of Pregnancies',
                  controller: pregnanciesController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Glucose (mg/dL)',
                  controller: glucoseController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Body Mass Index (BMI)',
                  controller: bmiController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Diabetes Pedigree Function',
                  controller: diabetesPedigreeController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                    labelText: 'Age', controller: ageController),
                _sizedBox(screenHeight),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      // Print the values in an array format
                      print([
                        diabetesPedigreeController.text,
                        bmiController.text,
                        pregnanciesController.text,
                        ageController.text,
                        glucoseController.text
                      ]);
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
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
                _sizedBox(screenHeight),
                Center(
                  child: Text(
                    "Values Collected in this form ${getConcatenatedValues()}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        suffix: Column(
          children: [
            GestureDetector(
              onTap: () {
                int currentValue = int.tryParse(controller.text) ?? 0;
                controller.text = (currentValue + 1).toString();
              },
              child: SizedBox(
                height: 10,
                width: 20,
                child: Icon(Icons.arrow_drop_up, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () {
                int currentValue = int.tryParse(controller.text) ?? 0;
                controller.text = (currentValue - 1).toString();
              },
              child: SizedBox(
                height: 10,
                width: 20,
                child: Icon(Icons.arrow_drop_down, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
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
