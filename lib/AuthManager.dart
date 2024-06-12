import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthManager with WidgetsBindingObserver {
  Future<Map<String, dynamic>> login(String username, String password) async {
    Map<String, dynamic> result = {};

    try {
      var res = await http.post(
        Uri.parse("http://192.168.93.9:5000/login"), // Replace localhost with your IP address
        body: {
          "identifier": username,
          "password": password,
        },
      );

      if (res.statusCode == 200) {
        print("Login successful");
        var response = jsonDecode(res.body);

        // Extract the needed values from the response
        String accessToken = response['access_token'];
        Map<String, dynamic> user = response['user'];
        String userName = user['username'];
        String namaLengkap = user['nama_lengkap'];
        String email = user['email'];
        int role = user['role'];

        // Store the values in the result map
        result = {
          'access_token': accessToken,
          'username': userName,
          'nama_lengkap': namaLengkap,
          'email': email,
          'role': role,
        };

        // Save the access token and expiry time in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setInt('expiry_time', DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch);

        print(result);
      } else {
        print("Login failed");
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<bool> isAccessTokenExpired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int expiryTime = prefs.getInt('expiry_time') ?? 0;
    return DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  Future<void> checkAndRefreshToken() async {
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state == AppLifecycleState.paused) {
      // Save the last active time
      await prefs.setInt('last_active_time', DateTime.now().millisecondsSinceEpoch);
    } else if (state == AppLifecycleState.resumed) {
      // Check the last active time
      int lastActiveTime = prefs.getInt('last_active_time') ?? 0;
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      // If the difference between current time and last active time is more than 5 minutes
      if (currentTime - lastActiveTime > 5 * 60 * 1000) {
        // Invalidate the token
        await prefs.remove('access_token');
        await prefs.remove('expiry_time');
        print("Session expired due to inactivity.");
        // Handle session expiry, redirect to login or show message
      } else {
        // Update the expiry time by adding the remaining time to the current time
        int remainingTime = prefs.getInt('expiry_time')! - lastActiveTime;
        await prefs.setInt('expiry_time', currentTime + remainingTime);
      }
    }
  }

  void startListening() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stopListening() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
