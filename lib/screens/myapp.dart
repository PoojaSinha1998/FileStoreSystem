import 'package:flutter/material.dart';
import 'package:flutter_folder/screens/auth/login.dart';
import 'package:flutter_folder/screens/auth/signup.dart';
import 'package:flutter_folder/screens/homepage.dart';
import 'package:flutter_folder/screens/welcome/splash.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        'signup_page': (BuildContext context) => SignUPage(),
        'login_page': (BuildContext context) => LoginPage(),
        'homepage': (BuildContext context) => HomePage(),
      },
      home: SplashPage(),
    );
  }
}
