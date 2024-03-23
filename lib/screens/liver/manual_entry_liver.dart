// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';

class ManualEntryLiver extends StatefulWidget {
  const ManualEntryLiver({super.key});

  @override
  ManualEntryLiverState createState() => ManualEntryLiverState();
}

class ManualEntryLiverState extends State<ManualEntryLiver> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController totalBilirubinController =
      TextEditingController();
  final TextEditingController directBilirubinController =
      TextEditingController();
  final TextEditingController alkalinePhosphataseController =
      TextEditingController();
  final TextEditingController alamineAminotransferaseController =
      TextEditingController();
  final TextEditingController totalProteinController = TextEditingController();
  final TextEditingController albuminController = TextEditingController();
  final TextEditingController albuminAndGlobulinRatioController =
      TextEditingController();

  @override
  void dispose() {
    totalBilirubinController.dispose();
    directBilirubinController.dispose();
    alkalinePhosphataseController.dispose();
    alamineAminotransferaseController.dispose();
    totalProteinController.dispose();
    albuminController.dispose();
    albuminAndGlobulinRatioController.dispose();
    super.dispose();
  }

  String getConcatenatedValues() {
    return '[${totalBilirubinController.text}, ${directBilirubinController.text}, ${alkalinePhosphataseController.text}, ${alamineAminotransferaseController.text}, ${totalProteinController.text}, ${albuminController.text}, ${albuminAndGlobulinRatioController.text}]';
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade500,
        title: const Text(
          'Manual Entry',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                  labelText: 'Alkaline Phosphatase (IU/L)',
                  controller: alkalinePhosphataseController,
                ),
                _sizedBox(screenHeight),
                _buildTextFormField(
                  labelText: 'Alamine Aminotransferase (IU/L)',
                  controller: alamineAminotransferaseController,
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
                      // Print the values in an array format
                      print([
                        totalBilirubinController.text,
                        directBilirubinController.text,
                        alkalinePhosphataseController.text,
                        alamineAminotransferaseController.text,
                        totalProteinController.text,
                        albuminController.text,
                        albuminAndGlobulinRatioController.text,
                      ]);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade500,
                    minimumSize: Size(screenWidth * 0.9, screenHeight * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text('Submit',
                      style: TextStyle(fontSize: 28, color: Colors.white)),
                ),
                _sizedBox(screenHeight),
                Center(
                  child: Text(
                    "Values Collected in this form ${getConcatenatedValues()}",
                    style: TextStyle(color: Colors.white),
                  ),
                )
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
          border: const OutlineInputBorder(),
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
