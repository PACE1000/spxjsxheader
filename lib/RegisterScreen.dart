import 'package:flutter/material.dart';
import 'package:spxjsxheader/Controller.dart';

class RegisterScreen extends StatefulWidget{
  RegisterScreen({Key? key}):super(key: key);

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen>{

  TextEditingController username = TextEditingController();
  TextEditingController no_telepon = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nama_lengkap = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController nama_panggilan = TextEditingController();
  TextEditingController id_role = TextEditingController();

  Controller _controller = Controller();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(controller: username),
          TextField(controller: no_telepon),
          TextField(controller: password,),
          TextField(controller: nama_lengkap),
          TextField(controller: email),
          TextField(controller: alamat),
          TextField(controller: nama_panggilan),
          TextField(controller: id_role),
          TextButton(onPressed: (){
            _controller.register(username.text, no_telepon.text, password.text, nama_lengkap.text, email.text, alamat.text, nama_panggilan.text, id_role.text);
          }, child: Text("Register"))
        ],
      ),
    );
  }
}