import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../home_page/home_page.dart';
import '../signin and login pages/signin.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  File? _image;
  final picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _StringdownloadURL;

  Future<void> _uploadFile() async {
    if (_image == null) {
      return;
    }
    final Reference storageRef =
        _storage.ref().child('images/${DateTime.now()}.jpg');
    final UploadTask uploadTask = storageRef.putFile(_image!);
    final TaskSnapshot downloadUrl = await uploadTask;
    final url = await downloadUrl.ref.getDownloadURL();
    print('File Uploaded. Download Url: $url');
    setState(() {
      _StringdownloadURL = url;
    });
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<void> _getgalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  void _handleError(dynamic error, StackTrace stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to load image.'),
      ),
    );
  }

  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  auth
                      .signOut()
                      .then((value) => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signin_scrren()))
                          })
                      .onError((error, stackTrace) => {});
                },
                icon: Icon(Icons.logout)),
          )
        ],
      ),
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              _image != null
                  ? CircleAvatar(
                      onBackgroundImageError: (error, stackTrace) =>
                          _handleError(error, stackTrace!),
                      radius: 50,
                      backgroundColor: Colors.black,
                      backgroundImage: FileImage(_image!),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 35,
                      )),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      _uploadFile().then((value) => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => homepage(
                                          url: _StringdownloadURL,
                                        )))
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Container(
                          child: Center(
                              child: Text(
                            'Upload profile image',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          )),
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                Color(0xff8a32f1),
                                Color(0xffad32f9)
                              ]))),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        _showAlertDialog(context);
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.teal,
                        size: 35,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            InkWell(
              onTap: () {
                _getImage();
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text('Camara'),
                leading: Icon(Icons.camera),
              ),
            ),
            InkWell(
              onTap: () {
                _getgalleryImage();
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text('Gallery'),
                leading: Icon(Icons.image),
              ),
            )
          ],
        );
      },
    );
  }
}
