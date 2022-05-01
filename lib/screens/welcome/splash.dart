import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_folder/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/image/drive.png",
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "File Store System",
                style: TextStyle(fontSize: 20, color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> firstTimeLoginChecking() async {
    preferences = await SharedPreferences.getInstance();
    var name = preferences.getString(Global.NAME);
    print("HERE NAME $name");
    if (name != null) {
      Navigator.of(context).pushReplacementNamed('homepage');
    } else {
      Navigator.of(context).pushReplacementNamed('login_page');
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    firstTimeLoginChecking();
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
}
