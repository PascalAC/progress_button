import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progress_button/progress_button.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Progress Button Sample",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sample"),
        ),
        body: Center(
          child: ProgressButton(
            width: 320,
            height: 60,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Text(
              "Sample",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            onPressed: (AnimationController controller) async {
              controller.forward();
              await Future.delayed(Duration(seconds: 5));
              controller.reverse();
            },
          ),
        ),
      ),
    );
  }
}
