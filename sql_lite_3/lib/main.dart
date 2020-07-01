import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

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

  Future<Database> database;
  List<Map<String, dynamic>> list = List();
  void initiateDB() async{

    database = openDatabase(
      join(await getDatabasesPath(), 'studetns.db'),
      onCreate: (db, version){

       return db.execute("CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT)");
      },
      version: 1,
    );
  }
  
  Future<void> insertData() async{
    
    Database db = await database;
    
    db.insert('students', {
      'id': _counter,
      'name': 'Student',
    },
    conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  void setData() async{

    _incrementCounter();
    await insertData();
    retrieveData();
  }
  Future<List<Map<String, dynamic>>> getData() async{
    Database db = await database;

    List<Map<String, dynamic>> map = await db.query('students');

    return map;
  }

  void retrieveData() async{

    List<Map<String, dynamic>> templist = await getData();
    setState(() {
      list = templist;
    });
    for (int index = 0; index < list.length; index++){

      print('${list[index]['id']} --- ${list[index]['name']}');
    }
  }
  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiateDB();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Column(
              children: list.map((student) => ListTile(
                title: Text('${student['id']}'),
                subtitle: Text(student['name']),
              )).toList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: setData,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
