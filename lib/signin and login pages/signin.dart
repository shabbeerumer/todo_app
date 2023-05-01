import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../google_signin/google_signin.dart';
import '../home_page/home_page.dart';
import '../phone_signin/phone_screen.dart';
import 'login.dart';

class Signin_scrren extends StatefulWidget {
  const Signin_scrren({Key? key}) : super(key: key);

  @override
  State<Signin_scrren> createState() => _Signin_scrrenState();
}

class _Signin_scrrenState extends State<Signin_scrren> {
  final Emailcontroller = TextEditingController();
  final Passwordcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  final FirebaseAuthentication firebaseAuth = FirebaseAuthentication();

  @override
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
                'Signin',
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
              textitem(
                  'Email', TextInputType.emailAddress, Emailcontroller, false),
              SizedBox(
                height: 15,
              ),
              textitem(
                  'Password', TextInputType.number, Passwordcontroller, true),
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
                    'if you already have an account?',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login_screen()));
                    },
                    child: Text(
                      ' login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
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
            .createUserWithEmailAndPassword(
                email: Emailcontroller.text.toString(),
                password: Passwordcontroller.text.toString())
            .then((value) => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login_screen())),
                  setState(() {
                    loading = false;
                  })
                })
            .onError((error, stackTrace) => {
                  Get.snackbar(
                    'Signin',
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
                    'Sign in',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
      ),
    );
  }

  Widget buttonitems(
      String Buttonname, String image, double imagesize, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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

  Widget textitem(
    String Labletext,
    TextInputType keyboardtype,
    TextEditingController Controller,
    bool obscureText,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        controller: Controller,
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
