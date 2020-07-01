import 'package:flutter/material.dart';
import 'package:loginsql/Data/UserData.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  GlobalKey<FormState> formKey = GlobalKey();

  //Animated Image Container
  double height = 200.0, width = 200.0;
  //Form controllers
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool hidePassword = true;
  Color hidePasswordButtonColor = Colors.grey;
  FocusNode credentialFocus, usernameFocus, passwordFocus;

  //Database controllers
  Future<Database> database;

  void initializeDB() async{

    database = openDatabase(
        join(await getDatabasesPath(), 'user.db'),
        version: 1
    );
  }

  Future<List<Map<String, dynamic>>> retreive() async{

    Database db = await database;

    List<Map<String, dynamic>> usersList = await db.query('USERS');

    return usersList;

  }

  void retreiveData(BuildContext context) async{

    List tempList = await retreive();

    for (int index = 0; index < tempList.length; index++){

      if ((usernameController.text == tempList[index]['username'] || usernameController.text == tempList[index]['email']) && passwordController.text.trim() == tempList[index]['password']){

        Navigator.pushNamed(context, '/success');
      }
    }
  }
  //Logo animation method
  void usernameLogoAnimation(){
    if (usernameFocus.hasFocus == true){
      setState(() {
        height = 0.0;
        width = 0.0;
      });
    }else{
      setState(() {
        height = 200.0;
        width = 200.0;
      });
    }
  }
  void passwordLogoAnimation(){
    if (passwordFocus.hasFocus == true){
      setState(() {
        height = 0.0;
        width = 0.0;
      });
    }else{
     setState(() {
       height = 200.0;
       width = 200.0;
     });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeDB();
    credentialFocus = FocusNode();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();

    usernameFocus.addListener(usernameLogoAnimation);
    passwordFocus.addListener(passwordLogoAnimation);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: AnimatedContainer(
                height: height,
                width: width,
                duration: Duration(milliseconds: 500),
                child: FlutterLogo(
                  size: 200.0,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                            child: TextFormField(
                              controller: usernameController,
                              focusNode: usernameFocus,
                              validator: (value){

                                if (value.isEmpty){

                                  return 'Username is required!';
                                }else if (value.contains(' ')){

                                  return 'Username can not contain spaces!';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(fontSize: 20.0),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person
                                ),
                                hintText: 'Username or Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    const Radius.circular(35.0)
                                  )
                                )
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                            child: TextFormField(
                              controller: passwordController,
                              focusNode: passwordFocus,
                              obscureText: hidePassword,
                              validator: (value){

                                if (value.isEmpty){

                                  return 'Password is required!';
                                }else if (value.length < 6){

                                  return 'Password is too short!';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(fontSize: 20.0),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                      Icons.lock
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      size: 30.0,
                                      color: hidePasswordButtonColor,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        hidePassword = hidePassword ? false : true;
                                        hidePasswordButtonColor = hidePasswordButtonColor == Colors.grey ? Colors.blue : Colors.grey;
                                      });
                                    },
                                    padding: EdgeInsets.only(right: 20.0)
                                  ),
                                  hintText: 'Password',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(35.0)
                                      )
                                  )
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35.0)
                            ),
                            height: 70.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  child: Builder(
                                  builder: (builderContext){
                                    return FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(35.0)
                                      ),
                                      child: Text('Log In', style: TextStyle(fontSize: 24.0),),
                                      onPressed: () {
                                        if (formKey.currentState.validate()){
                                          retreiveData(builderContext);
                                        }
                                      },
                                      color: Colors.blue,
                                      textColor: Colors.white,

                                    );
                                   },
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account? ", style: TextStyle(fontSize: 22.0, color: Colors.blue),),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                            child: Text('Sign Up', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blue),)

                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
