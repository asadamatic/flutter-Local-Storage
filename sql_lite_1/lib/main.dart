import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Dog.dart';
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
 void prepareDB() async{
   // Open the database and store the reference.
    database = openDatabase(
     // Set the path to the database. Note: Using the `join` function from the
     // `path` package is best practice to ensure the path is correctly
     // constructed for each platform.
     join(await getDatabasesPath(), 'doggie_database.db'),
     onCreate: (db, version) {
       // Run the CREATE TABLE statement on the database.
       return db.execute(
         "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
       );
     },
     // Set the version. This executes the onCreate function and provides a
     // path to perform database upgrades and downgrades.
     version: 1,
   );


 }

  // Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  void getDog() async{
   List<Dog> animals = await dogs();
   for (int index = 0; index < animals.length; index++){
     print(animals[index].name);
   }
  }
  void setDog() async{
   insertDog(Dog(id: 1, name: 'pet', age: 12));
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
    prepareDB();
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
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: setDog,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: getDog,
            tooltip: 'Increment',
            child: Icon(Icons.get_app),
          ),
        ],
      ),
    );
  }
}
