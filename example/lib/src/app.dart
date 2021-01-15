import 'dart:math';

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
              gradient: new LinearGradient(
                colors: <Color>[
                  Colors.red,
                  Colors.blue,
                ]
              ),
              strokeWidth: 2,
              child: Text(
                "Sample",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              errorChild: const Icon(
                Icons.close_sharp,
                color: Colors.white,
              ),
              successChild: const Icon(
                Icons.check_sharp,
                color: Colors.white,
              ),
              onPressed: ( controller ) async {
                await controller.loading();
                await new Future.delayed( const Duration( seconds: 3 ) );
                if ( Random.secure().nextBool() )
                  await controller.success();
                else await controller.error();
              },
            ),
          ),
        ),
      ),
    );
  }
}
