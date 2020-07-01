import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  SharedPreferences pref;
  TextEditingController _controller = TextEditingController();
  bool userLoggedIn = false;

  void _incrementCounter() async{
    pref = await SharedPreferences.getInstance();
    setState(() {

      _counter++;
      userLoggedIn = true;
    });

    pref.setInt('counter', _counter);
    pref.setString('name', _controller.text.toString());
    pref.setBool('userLoggedIn', userLoggedIn);
  }
  void _removeSharedPref() async{

    pref = await SharedPreferences.getInstance();

    pref.remove('counter');

  }
  void getData() async{

    pref = await SharedPreferences.getInstance();
    _counter = pref.getInt('counter');
    _controller.text = pref.getString('name');
    userLoggedIn = pref.getBool('userLoggedIn');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter your name...'
              ),
              onChanged: (value){
                _incrementCounter();
              },
            ),
            Text(userLoggedIn ? 'Logged In': 'User logged out'),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          FloatingActionButton(
            onPressed: _removeSharedPref,
            tooltip: 'Increment',
            child: Icon(Icons.remove),
          ),

          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
