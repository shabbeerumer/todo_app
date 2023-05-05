import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/signin%20and%20login%20pages/signin.dart';
import 'AddTodo/AddTodo.dart';
import 'TodoCard/TodoCard.dart';
import 'code_tasting_page.dart';
import 'firebase_options.dart';
import 'home_page/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'todo app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: user != null ? homepage() : Signin_scrren());
  }
}
