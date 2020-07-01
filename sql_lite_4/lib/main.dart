import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqllite4/UserData.dart';

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

  void _incrementCounter() async{

    retreiveData();
    await update(UserData(email: 'asadamatic20@gmail.com', username: 'asadamatic', password: '12341234'));
    retreiveData();
  }


  Future<Database> database;

  void initializeDB() async{

    database = openDatabase(
      join(await getDatabasesPath(), 'userdb.db'),
      version: 1,
      onCreate: (db, version){
        db.execute('CREATE TABLE USERS(username TEXT PRIMARY KEY, email TEXT UNIQUE, password TEXT)');
      }
    );
  }

  Future<List<Map<String, dynamic>>> retreive() async{

    Database db = await database;

    List<Map<String, dynamic>> lists = await db.query('USERS');

    return lists;
  }

  void retreiveData() async{

    List lists = await retreive();

    print(lists);
  }

  Future<void> update(UserData userData) async{

    Database db = await database;

    db.update('USERS', userData.toMap(), where: 'username = ?', whereArgs: [userData.username]);

  }
  Future<void> insert(UserData userData) async{

    Database db = await database;

    db.insert("USERS", userData.toMap());

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDB();
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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
