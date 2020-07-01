import 'package:flutter/material.dart';


class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);


  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  void loadData() async{

    Future.delayed(Duration(seconds: 1)).then((value) {

      Navigator.pushReplacementNamed(context, '/login');

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           FlutterLogo(
             size: 200.0,
           )
          ],
        ),
      ),
    );
  }
}
