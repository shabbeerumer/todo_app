import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  TodoCard(
      {required this.title,
      required this.icon,
      required this.iconcolor,
      required this.timer,
      required this.check,
      required this.iconbgColor,
      required this.onchange,
      required this.index});

  final String title;
  final IconData icon;
  final Color iconcolor;
  final String timer;
  final bool check;
  final Color iconbgColor;
  final Function onchange;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            data: ThemeData(
                primarySwatch: Colors.blue,
                unselectedWidgetColor: Color(0xff5e616a)),
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                activeColor: Color(0XFF6CF8A9),
                checkColor: Color(0XFF0E3E26),
                value: check,
                onChanged: (val) {
                  onchange(index);
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 75,
              child: Card(
                color: Color(0XFF2A2E3D),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: iconbgColor),
                      child: Icon(
                        icon,
                        color: iconcolor,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        title.toString(),
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                    Text(
                      timer.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
