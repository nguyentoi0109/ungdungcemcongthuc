import 'package:shared_preferences/shared_preferences.dart';


class UserPreferences {
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';

  static Future<void> saveCredentials(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPassword, password);
  }

  static Future<Map<String, String>> getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString(_keyUsername);
    final String? password = prefs.getString(_keyPassword);
    return {'username': username ?? '', 'password': password ?? ''};
  }

  static Future<bool> checkCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUsername) && prefs.containsKey(_keyPassword);
  }
  static Future<void> removeCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUsername); // Xóa giá trị username
    prefs.remove(_keyPassword); // Xóa giá trị password
  }
}
