import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AddTodo/AddTodo.dart';
import '../TodoCard/TodoCard.dart';
import '../profilepage/profile.dart';
import '../signin and login pages/signin.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../view_data/view_data.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  final url;
  const homepage({Key? key, this.url}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  final auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Select> Selected = [];
  var currentime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deleteSelected();
  }

  void deleteSelected() {
    final instance = FirebaseDatabase.instance.ref().child('todo');
    for (int i = 0; i < Selected.length; i++) {
      if (Selected[i].checkvalue == true) {
        instance.child(Selected[i].id.toString()).remove().then((_) {
          setState(() {
            // Remove the item from the selected list
            Selected.removeAt(i);
          });
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        actions: [
          widget.url != null
              ? CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(widget.url.toString()),
                )
              : CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                ),
          SizedBox(
            width: 15,
          )
        ],
        title: Text(
          "Today's Schedule",
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(35),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${DateFormat('MMMMEEEEd').format(currentime)}",
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Selected.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              deleteSelected();
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 28,
                            )),
                  ],
                ),
              ),
            )),
      ),
      bottomNavigationBar:
          BottomNavigationBar(backgroundColor: Colors.black, items: [
        BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            )),
        BottomNavigationBarItem(
            label: '',
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTodoPage()));
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
            )),
        BottomNavigationBarItem(
            label: '',
            icon: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profilepage()));
                },
                child: Icon(Icons.settings, size: 32, color: Colors.white))),
      ]),
      body: FirebaseAnimatedList(
        defaultChild: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
        query: databaseReference.child('todo'),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          IconData icon = Icons.error;
          Color iconcolor = Colors.red;
          var selectedData;
          selectedData = snapshot.value;
          String userId = snapshot.key.toString();

          switch (snapshot.child('cetegory').value.toString()) {
            case "work":
              icon = Icons.run_circle_outlined;
              iconcolor = Colors.red;
              break;
            case "Workout":
              icon = Icons.alarm;
              iconcolor = Colors.teal;
              break;
            case "food":
              icon = Icons.local_grocery_store;
              iconcolor = Colors.blue;
              break;
            case "Design":
              icon = Icons.audiotrack;
              iconcolor = Colors.green;
              break;
            case "Run":
              icon = Icons.directions_run;
              iconcolor = Colors.purple;
              break;
            default:
              icon = Icons.add;
              iconcolor = Colors.red;
          }

          Selected.add(Select(id: userId, checkvalue: false));

          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Viewdata(
                            data: selectedData,
                            id: userId,
                          )));
            },
            child: TodoCard(
              title: snapshot.child('title').value.toString(),
              icon: icon,
              iconcolor: iconcolor,
              timer: "${DateFormat('jm').format(currentime)}",
              check: Selected[index].checkvalue,
              iconbgColor: Colors.white,
              onchange: onchange,
              index: index,
            ),
          );
        },
      ),
    );
  }

  void onchange(int index) {
    setState(() {
      Selected[index].checkvalue = !Selected[index].checkvalue;
    });
  }
}

class Select {
  String id;
  bool checkvalue = false;
  Select({required this.id, required this.checkvalue});
}

//SingleChildScrollView(
//child: Container(
//height: MediaQuery.of(context).size.height,
//width: MediaQuery.of(context).size.width,
//padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//child: Column(
//children: [
//TodoCard(
//title: 'Wake up bro',
//icon: Icons.alarm,
//iconcolor: Colors.red,
//timer: '10 AM',
//check: true,
//iconbgColor: Colors.white,
//),
//SizedBox(height: 10),
//TodoCard(
//title: 'Lets go gym',
//icon: Icons.run_circle,
//iconcolor: Colors.white,
//timer: '11 AM',
//check: false,
//iconbgColor: Color(0xff2cc8d9),
//),
//SizedBox(height: 10),
//TodoCard(
//title: 'buy some food',
//icon: Icons.local_grocery_store,
//iconcolor: Colors.white,
//timer: '12 AM',
//check: false,
//iconbgColor: Color(0xfff19733)),
//SizedBox(height: 10),
//TodoCard(
//title: 'tasting something',
//icon: Icons.audiotrack,
//iconcolor: Colors.white,
//timer: '13 AM',
//check: false,
//iconbgColor: Color(0xff3dc2b9)),
//SizedBox(height: 10),
//],
//),
//),
//),
