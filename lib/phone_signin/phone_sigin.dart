import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/phone_signin/phone_screen.dart';
import '../home_page/home_page.dart';

class phonesigin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send an SMS message to the user's phone number
  Future<void> sendVerificationCode(
      String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // This callback will be called if auto verification of sms is successfull
        await _auth.signInWithCredential(credential);
        print('User signed in successfully.');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Phone number verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => phone_screen(
                      VarificationidFinal: verificationId,
                    )));
        print('Please check your phone for the verification code.');
      },
      codeAutoRetrievalTimeout: (_) {
        // This callback will be called when the SMS code auto-retrieval times out
      },
    );
  }

  // Verify the SMS code entered by the user
// Verify the SMS code entered by the user
  Future<void> verifyCode(
      String smsCode, String VarificationID, context) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: VarificationID,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => homepage()));
    } catch (e) {
      print('Error signing in with SMS code: ${e.toString()}');
    }
  }
}
