// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get user => auth.authStateChanges();

  Future<void> verifyPhoneNumber(
      String phoneNumber,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeSent codeSent,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout) async {
    return auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<User?> signInWithCredential(AuthCredential credential) async {
    try {
      final userCredential = await auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (error) {
      print("Error signing in with credential: $error");
      return null;
    }
  }

  Future<void> resendOtp(
      String phoneNumber, void Function(String, int?) codeSent) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 0),
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}