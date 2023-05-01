import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:todo_app/phone_signin/phone_sigin.dart';

class phone_screen extends StatefulWidget {
  String VarificationidFinal;
  phone_screen({Key? key, required this.VarificationidFinal}) : super(key: key);

  @override
  State<phone_screen> createState() => _phone_screenState();
}

class _phone_screenState extends State<phone_screen> {
  @override
  TextEditingController _phoneController = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  int start = 30;
  bool wait = false;
  String buttonname = 'send';
  phonesigin phone_sigin = phonesigin();
  String smscode = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Signin with phone',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              textfield(),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    Text(
                      'Enter 6 Digit OTP',
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              otpfield(),
              SizedBox(
                height: 40,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Send OTP again in',
                    style: TextStyle(fontSize: 16, color: Colors.yellowAccent)),
                TextSpan(
                    text: ' 00$start',
                    style: TextStyle(fontSize: 16, color: Colors.pinkAccent)),
                TextSpan(
                    text: ' sec',
                    style: TextStyle(fontSize: 16, color: Colors.pinkAccent)),
              ])),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  phone_sigin.verifyCode(
                      smscode, widget.VarificationidFinal, context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffff9601)),
                  child: Center(
                      child: Text(
                    'Lets Go',
                    style: TextStyle(
                        color: Color(0xfffbe2ae),
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void Starttimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          wait = false;
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpfield() {
    return OTPTextField(
      controller: otpController,
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 58,
      otpFieldStyle: OtpFieldStyle(
          borderColor: Colors.white, backgroundColor: Color(0xff1d1d1d)),
      style: TextStyle(fontSize: 17, color: Colors.white),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smscode = pin;
        });
      },
    );
  }

  Widget textfield() {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 60,
        decoration: BoxDecoration(
            color: Color(0xff1d1d1d), borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
            controller: _phoneController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Enter your phone number',
                hintStyle: TextStyle(color: Colors.white54, fontSize: 17),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 19, horizontal: 8),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                  child: Text(
                    '(+92)',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: wait
                      ? null
                      : () {
                          Starttimer();
                          setState(() {
                            wait = true;
                            start = 30;
                            buttonname = 'Resend';
                          });
                          phone_sigin.sendVerificationCode(
                              "+92 ${_phoneController.text}", context);
                        },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Text(
                      buttonname,
                      style: TextStyle(
                          color: wait ? Colors.grey : Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))));
  }
}
