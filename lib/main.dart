import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spxjsxheader/AuthManager.dart';
import 'package:spxjsxheader/GetUser.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthManager authManager = AuthManager();

  @override
  Widget build(BuildContext context) {
    authManager.startListening();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              return GetUserScreen();
            } else {
              return LoginPage();
            }
          }
        },
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    if (accessToken == null || await authManager.isAccessTokenExpired()) {
      return false;
    } else {
      return true;
    }
  }
}

class LoginPage extends StatelessWidget {
  final AuthManager authManager = AuthManager();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[

            TextField(controller: username,),
            TextField(controller: password,),
            ElevatedButton(
          onPressed: () async {
            // Example login action
            await authManager.login(username.text, password.text);
            if (!await authManager.isAccessTokenExpired()) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GetUserScreen()),
              );
            }
          },
          child: Text("Login"),
        ),
          ],
        )
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final AuthManager authManager = AuthManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example logout action
            authManager.stopListening();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
