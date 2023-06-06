import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../home_page/home_page.dart';
import '../signin and login pages/signin.dart';

class Profilepage extends StatefulWidget {
  Profilepage({
    Key? key,
  }) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  File? _image;
  final picker = ImagePicker();
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final ref = FirebaseDatabase.instance.ref('users');
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _uploadFile() async {
    final firebase_storage.Reference storageRef = _storage.ref().child(
          'images/${FirebaseAuth.instance.currentUser!.uid.toString()}.jpg',
        );
    final firebase_storage.UploadTask uploadTask =
        storageRef.putFile(_image!.absolute);
    await Future.value(uploadTask);
    final firebase_storage.TaskSnapshot downloadUrl = await uploadTask;
    final url = await downloadUrl.ref.getDownloadURL();
    ref
        .child(uid)
        .update({'profileimageurl': url.toString()})
        .then((value) => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => homepage())),
            })
        .onError((error, stackTrace) => {});
  }

  Future<void> _getcameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadFile();
      }
    });
  }

  Future<void> _getgalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadFile();
      }
    });
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            InkWell(
              onTap: () {
                _getcameraImage();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UsersData();
  }

  String? ProfileImage;
  Future<void> UsersData() async {
    final Data = await FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(uid.toString())
        .get();
    setState(() {
      ProfileImage = Data.child('profileimageurl').value.toString();
    });
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
                      .catchError((error, stackTrace) => {});
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
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey)),
                child: ClipRRect(
                  child: _image == null &&
                          (ProfileImage == null ||
                              ProfileImage?.isEmpty == true)
                      ? Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 35,
                        )
                      : _image != null
                          ? FutureBuilder<File>(
                              future: Future.value(_image),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 35,
                                  );
                                } else if (snapshot.hasData) {
                                  return Image.file(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            )
                          : Image.network(
                              ProfileImage!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 35,
                                );
                              },
                            ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      _showAlertDialog(context);
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
