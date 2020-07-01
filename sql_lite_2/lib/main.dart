import 'package:flutter/material.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  Future<Database> database;

  void prepareDb() async{

    database = openDatabase(
      join(await getDatabasesPath(), 'test_db.db'),
      onCreate: (db, version){
        
        return db.execute("CREATE TABLE text(id INTEGER PRIMARY KEY)");
      },
      version: 1,
    );
  }

  Future<void> insertData() async{

    Database db = await database;

    db.insert('text', {
      'id': _counter,

    },
    conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List> data() async{

    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('text');

    List data = List.generate(maps.length, (index) => maps[index]['id']);

    return data;
  }
  void getData() async{

    List dataList = await data();
    for (int index = 0; index < dataList.length; index++){
      print(dataList[index]);
    }
  }
  void setData() async{
    setState(() {

      _counter++;
    });
    await insertData();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prepareDb();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: setData,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: getData,
            tooltip: 'Download Data',
            child: Icon(Icons.get_app),
          ),
        ],
      ),
    );
  }
}
