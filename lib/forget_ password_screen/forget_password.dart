import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import '../signin and login pages/login.dart';

class forget_password_screen extends StatefulWidget {
  const forget_password_screen({Key? key}) : super(key: key);

  @override
  State<forget_password_screen> createState() => _forget_password_screenState();
}

class _forget_password_screenState extends State<forget_password_screen> {
  final auth = FirebaseAuth.instance;
  @override
  final forgetpasswordcontroller = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black87,
        title: Text(
          'Forget password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: Colors.black87,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textitem(
                'Enter email',
                TextInputType.emailAddress,
                forgetpasswordcontroller,
                false,
              ),
              SizedBox(
                height: 30,
              ),
              colorButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () {
        auth
            .sendPasswordResetEmail(
                email: forgetpasswordcontroller.text.toString())
            .then((value) => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login_screen()))
                })
            .onError((error, stackTrace) =>
                {_showSnackBar('Password reset email sent successfully')});
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Color(0xfffd746c), Color(0xffff9868), Color(0xfffd746c)],
            )),
        child: Center(
            child: Text(
          'Lets Go',
          style: TextStyle(color: Colors.white, fontSize: 20),
        )),
      ),
    );
  }

  _showSnackBar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Widget textitem(String Labletext, TextInputType keyboardtype,
      TextEditingController mycontroller, bool obsecure) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        obscureText: obsecure,
        controller: mycontroller,
        style: TextStyle(color: Colors.white),
        keyboardType: keyboardtype,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 1.5, color: Colors.amber)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 1, color: Colors.grey)),
            labelText: Labletext,
            labelStyle: TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );
  }
}
