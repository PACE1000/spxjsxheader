import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    try {
      await storage.write(key: "access_token", value: token);
      print("Access token saved: $token");
    } catch (e) {
      print("Error saving access token: $e");
    }
  }
}
