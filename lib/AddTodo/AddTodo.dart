import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home_page/home_page.dart';
import 'package:firebase_database/firebase_database.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  @override
  final titlecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  String type = '';
  String Cetogory = '';

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff1d1e26),
          Color(0xff252041),
        ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              IconButton(
                  onPressed: () {
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => homepage()));
                      },
                      child: Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [Colors.indigoAccent, Colors.purple])),
                        child: Icon(
                          Icons.add,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  icon: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          color: Colors.white,
                          letterSpacing: 4),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'New Todo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          color: Colors.white,
                          letterSpacing: 2),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    lable('Tast Title'),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 30,
                    ),
                    lable('Tast Type'),
                    SizedBox(
                      height: 17,
                    ),
                    Row(
                      children: [
                        taskSelect('Important', 0xffff6d6e),
                        SizedBox(width: 20),
                        taskSelect('Planned', 0xff2bc8d9),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    lable('Description'),
                    SizedBox(
                      height: 12,
                    ),
                    description(),
                    SizedBox(
                      height: 25,
                    ),
                    lable('Cetegory'),
                    SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        CetegorySelect('food', 0xffff6d6e),
                        SizedBox(width: 20),
                        CetegorySelect('Workout', 0xfff29732),
                        SizedBox(width: 20),
                        CetegorySelect('work', 0xff6557ff),
                        SizedBox(width: 20),
                        CetegorySelect('Design', 0xff234ebd),
                        SizedBox(width: 20),
                        CetegorySelect('Run', 0xff2bc849),
                      ],
                    ),
                    SizedBox(height: 50),
                    button(),
                    SizedBox(height: 30),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        final id = DateTime.now().microsecondsSinceEpoch.toString();
        final ref = FirebaseDatabase.instance.ref('todo');
        ref
            .child(id)
            .set({
              'id': id,
              'title': titlecontroller.text.toString(),
              'task': type,
              'description': descriptioncontroller.text.toString(),
              'cetegory': Cetogory,
            })
            .then((value) => {Navigator.pop(context)})
            .onError((error, stackTrace) => {print(error.toString())});
      },
      child: Container(
          child: Center(
              child: Text(
            'Add todo',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white,
            ),
          )),
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors: [Color(0xff8a32f1), Color(0xffad32f9)]))),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xff2a2e3d)),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: descriptioncontroller,
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
            hintText: 'Tast title',
            contentPadding: EdgeInsets.only(left: 20, right: 20)),
      ),
    );
  }

  Widget taskSelect(String lable, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          type = lable;
        });
      },
      child: Chip(
        backgroundColor: type == lable ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(lable,
            style: TextStyle(
                color: type == lable ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
        labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget CetegorySelect(String lable, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          Cetogory = lable;
        });
      },
      child: Chip(
        backgroundColor: Cetogory == lable ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(lable,
            style: TextStyle(
                color: Cetogory == lable ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
        labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xff2a2e3d)),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: titlecontroller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
            hintText: 'Tast title',
            contentPadding: EdgeInsets.only(left: 20, right: 20)),
      ),
    );
  }

  Widget lable(String lable) {
    return Text(
      lable,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          color: Colors.white,
          letterSpacing: 0.2),
    );
  }
}
