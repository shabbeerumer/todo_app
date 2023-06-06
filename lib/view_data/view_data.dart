import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Viewdata extends StatefulWidget {
  var data;
  var id;
  Viewdata({Key? key, required this.data, required this.id}) : super(key: key);

  @override
  State<Viewdata> createState() => _ViewdataState();
}

class _ViewdataState extends State<Viewdata> {
  @override
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  String type = '';
  String Cetogory = '';
  bool edit = false;

  @override
  void initState() {
    super.initState();
    print(widget.id);
    var title = widget.data['title'].toString();
    titlecontroller = TextEditingController(text: title);
    descriptioncontroller =
        TextEditingController(text: widget.data['description'].toString());
    type = widget.data['task'].toString();
    Cetogory = widget.data['cetegory'].toString();
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      )),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            final ref =
                                FirebaseDatabase.instance.ref().child('todo');
                            ref
                                .child(widget.id.toString())
                                .remove()
                                .then((value) =>
                                    {print(widget.id), Navigator.pop(context)})
                                .onError((error, stackTrace) =>
                                    {print(error.toString())});
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 28,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: edit ? Colors.green : Colors.white,
                            size: 28,
                          )),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? 'Editing' : 'view',
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
                      'Your Todo',
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
                    edit ? button() : Container(),
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
        final ref = FirebaseDatabase.instance.ref('todo');
        ref
            .child(widget.id)
            .update({
              'id': widget.id,
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
            'Update todo',
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
        enabled: edit,
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
      onTap: edit
          ? () {
              setState(() {
                type = lable;
              });
            }
          : null,
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
      onTap: edit
          ? () {
              setState(() {
                Cetogory = lable;
              });
            }
          : null,
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
            enabled: edit,
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
