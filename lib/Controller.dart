import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller {
   final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String username, String password) async {
    Map<String, dynamic> item = {};

    try {
      // Retrieve the access token from secure storage
      var res = await http.post(
        Uri.parse("http://localhost:5000/login"), // Replace localhost with your IP address,
        body:{
          "identifier": username,
          "password": password,
        },
      );

      if (res.statusCode == 200) {
        print("Login successful");
        var response = jsonDecode(res.body);
        String access_token = response['access_token'];
        Map<String,dynamic> user = response['user'];
         String userName = user['username'];
      String namaLengkap = user['nama_lengkap'];
      String email = user['email'];
      int role = user['role'];

      // Store the values in the result map
      item = {
        'access_token': access_token,
        'username': userName,
        'nama_lengkap': namaLengkap,
        'email': email,
        'role': role,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', access_token);
      await prefs.setInt('expiry_time', DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch);
      print(item);
      } else {
        print("Login failed");
      }
    } catch (e) {
      print(e);
    }

    return item;
  }

  Future<bool> isAccessTokenExpired() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int expiryTime = prefs.getInt('expiry_time') ?? 0;
  return DateTime.now().millisecondsSinceEpoch > expiryTime;
}

Future<void> someFunctionThatRequiresAuth() async {
  bool isExpired = await isAccessTokenExpired();
  if (isExpired) {
    print("Access token is expired, please login again.");
    // Handle expired token scenario, maybe redirect to login page
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    // Use the access token for your requests
    print("Access token is valid: $accessToken");
  }
}

   Future<void> register(
    String username,
    String no_telepon,
    String password,
    String nama_lengkap,
    String email,
    String alamat,
    String nama_panggilan,
    String id_role
  ) async {
    try {
      var res = await http.post(
        Uri.parse("http://localhost:5000/user"), // Replace localhost with your IP address
 
        body: {
          "username": username,
          "no_telepon": no_telepon,
          "password": password,
          "nama_lengkap": nama_lengkap,
          "email": email,
          "alamat": alamat,
          "nama_panggilan": nama_panggilan,
          "id_role": id_role
        },
      );

      if (res.statusCode == 200) {
        print("Berhasil");
      } else {
        print("Failed with status code: ${res.statusCode}");
        print("Response body: ${res.body}");
      }
    } catch (e) {
      print(e);
    }
  }
}