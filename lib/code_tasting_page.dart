import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class tasting extends StatefulWidget {
  const tasting({Key? key}) : super(key: key);

  @override
  State<tasting> createState() => _State();
}

class _State extends State<tasting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              timer();
            },
            child: Center(
              child: Container(
                child: Text('ASDD'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void timer() {
  DateTime startTime = DateTime.now();
// code to be executed
  DateTime endTime = DateTime.now();
  Duration elapsed = endTime.difference(startTime);
  print('Time  elapsed: ${elapsed.inSeconds} seconds');
}
