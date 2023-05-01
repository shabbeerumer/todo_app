import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todo_app/signin%20and%20login%20pages/signin.dart';
import '../forget_ password_screen/forget_password.dart';
import '../google_signin/google_signin.dart';
import '../home_page/home_page.dart';
import '../phone_signin/phone_screen.dart';

class Login_screen extends StatefulWidget {
  const Login_screen({Key? key}) : super(key: key);

  @override
  State<Login_screen> createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {
  @override
  final loginEmailcontroller = TextEditingController();
  final loginPasswordcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  final FirebaseAuthentication firebaseAuth = FirebaseAuthentication();

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              buttonitems('Continue with google', 'assets/Goggleimage.png', 25,
                  () async {
                final User? user = await firebaseAuth.signInWithGoogle();

                if (user != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homepage()));
                } else {
                  print('some thing wants wrong');
                }
              }),
              SizedBox(
                height: 15,
              ),
              buttonitems(
                  'Continue with Phonenumber', 'assets/Phoneimage.png', 29, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => phone_screen(
                              VarificationidFinal: '',
                            )));
              }),
              SizedBox(
                height: 15,
              ),
              Text('or', style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                height: 15,
              ),
              textitem('Email', TextInputType.emailAddress,
                  loginEmailcontroller, false),
              SizedBox(
                height: 15,
              ),
              textitem('Password', TextInputType.number,
                  loginPasswordcontroller, true),
              SizedBox(
                height: 30,
              ),
              colorButton(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "don't have an account?",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Signin_scrren()));
                    },
                    child: Text(
                      ' Signin',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => forget_password_screen()));
                },
                child: Text(
                  'Forget Password?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () {
        setState(() {
          loading = true;
        });
        auth
            .signInWithEmailAndPassword(
                email: loginEmailcontroller.text.toString(),
                password: loginPasswordcontroller.text.toString())
            .then((value) => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homepage())),
                  setState(() {
                    loading = false;
                  })
                })
            .onError((error, stackTrace) => {
                  Get.snackbar(
                    'Login',
                    error.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                  ),
                  setState(() {
                    loading = false;
                  })
                });
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
            child: loading
                ? CircularProgressIndicator()
                : Text(
                    'Log in',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
      ),
    );
  }

  Widget buttonitems(
      String Buttonname, String image, double imagesize, VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(width: 1, color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: imagesize,
                width: imagesize,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                Buttonname,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
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
