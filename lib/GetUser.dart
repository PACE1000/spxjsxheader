import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spxjsxheader/AuthManager.dart';
import 'package:http/http.dart' as http;

class GetUserScreen extends StatefulWidget {
  GetUserScreen({Key? key}) : super(key: key);

  @override
  _GetUserScreen createState() => _GetUserScreen();
}

class _GetUserScreen extends State<GetUserScreen> {
  final AuthManager authManager = AuthManager();

  Future<String?> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, dynamic>> getUser() async {
    Map<String, dynamic> item = {};
    try {
      String? accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception("Access token not found");
      }
      var res = await http.get(
        Uri.parse("http://192.168.93.9:5000/user"),
        headers: {
          'access_token': accessToken,
        },
      );

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        print(response);
      } else {
        print("Failed to load user data");
      }
    } catch (e) {
      print(e);
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {
              getUser();
            },
            child: Text("Dapat User"),
          ),
        ],
      ),
    );
  }
}
