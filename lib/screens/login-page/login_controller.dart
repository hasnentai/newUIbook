import 'dart:async';

import 'package:bookabook/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Constants consts = Constants();

class LoginController {
  // static const String _URL = 'http://bookabook.co.za/wp-json/jwt-auth/v1/token';
  SharedPreferences prefs;
  Future<http.Response> login(String username, String password) async {
    final http.Response response = await http.post('https://bookabook.co.za/wp-json/jwt-auth/v1/token?username=hasnen712&password=hasnenvkfan712');
    print(response);
    return response;
  }

  Future<void> saveUserData(Map<String, dynamic> userInfo) async {
    prefs = await SharedPreferences.getInstance();

    prefs.setString("email", userInfo["user_email"]);
    prefs.setString("token", userInfo["token"]);
    prefs.setString("displayName", userInfo["user_display_name"]);
  }
}
