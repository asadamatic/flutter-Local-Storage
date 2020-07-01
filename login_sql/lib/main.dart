import 'package:flutter/material.dart';
import 'package:loginsql/Screens/LoadingScren.dart';
import 'package:loginsql/Screens/LoginScreen.dart';
import 'package:loginsql/Screens/SignupScreen.dart';
import 'package:loginsql/Screens/SuccesfulSignup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => LoadingScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/success': (context) => SuccessfulSignup(),
      },
    );
  }
}
