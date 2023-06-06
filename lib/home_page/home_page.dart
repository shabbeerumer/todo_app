import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../AddTodo/AddTodo.dart';
import '../TodoCard/TodoCard.dart';
import '../profilepage/profile.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../view_data/view_data.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  const homepage({
    Key? key,
  }) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  final auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.ref();
  List<Select> Selected = [];
  var currentime = DateTime.now();
  String userId = '';

  void onchange(int index) {
    setState(() {
      print(Selected[index].id);
      Selected[index].checkvalue = !Selected[index].checkvalue;
    });
  }

  @override
  void initState() {
    super.initState();
    getUsersprofileurl();
  }

  String? profileImageUrl;
  Future<void> getUsersprofileurl() async {
    final Data = await FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(auth.currentUser!.uid)
        .get();

    setState(() {
      profileImageUrl = Data.child('profileimageurl').value.toString();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        actions: [
          if (profileImageUrl == null)
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person),
            )
          else
            Visibility(
              visible: profileImageUrl != null && profileImageUrl!.isNotEmpty,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    profileImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person),
                      );
                    },
                  ),
                ),
              ),
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
                        : Selected.any((item) => item.checkvalue == true)
                            ? IconButton(
                                onPressed: () async {
                                  final instance = FirebaseDatabase.instance
                                      .ref()
                                      .child('todo');
                                  final toDelete = List.from(Selected.where(
                                      (item) => item.checkvalue));
                                  print(toDelete);
                                  Selected
                                      .clear(); // Clear the Selected list before deletion
                                  for (var item in toDelete) {
                                    await instance.child(item.id).remove();
                                    print('Removed item with id ${item.id}');
                                  }
                                  setState(() {
                                    Selected.removeWhere(
                                        (item) => toDelete.contains(item));
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 28,
                                ),
                              )
                            : Container()
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
            var selectedData = snapshot.value;
            var userId = snapshot.key.toString();
            Selected.add(Select(id: userId, checkvalue: false));

            if (auth.currentUser!.uid.toString() ==
                snapshot.child('Uid').value.toString()) {
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
            }
            return Container();
          }),
    );
  }
}

class Select {
  String id;
  bool checkvalue = false;
  Select({required this.id, required this.checkvalue});
}
