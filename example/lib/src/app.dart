import 'package:flutter/material.dart';
import 'package:progress_indicator_button/progress_button.dart';

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
          child: Container(
            width: 200,
            height: 60,
            child: ProgressButton(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Text(
                "Sample",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              onPressed: (AnimationController controller) {
                if (controller.isCompleted) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
