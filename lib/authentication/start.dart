// splash_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:videohaven/videoHaven.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the Home screen after a delay
    Timer(Duration(seconds: 2), () {
     Navigator.pushReplacement(
         context,
       CupertinoPageRoute(builder: (context)=>VideoHaven())
       );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Image.asset('assets/Haven.gif', width: 500, height: 500),
      ),
    );
  }
}
