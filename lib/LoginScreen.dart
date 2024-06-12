import 'package:flutter/material.dart';
import 'package:spxjsxheader/Controller.dart';

class LoginScreen extends StatefulWidget{
  LoginScreen({Key? key}):super(key: key);


  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{
  TextEditingController Username = TextEditingController();
  TextEditingController Password = TextEditingController();

  Controller _controller = Controller();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(controller: Username),
          TextField(controller: Password,),
          TextButton(onPressed: (){
            _controller.login(Username.text,Password.text);
          }, child: Text("Login"))
        ],
      ),
    );
  }
}