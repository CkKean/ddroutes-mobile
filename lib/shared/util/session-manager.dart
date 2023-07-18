import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String jwtToken = "";

//set data into shared preferences like this
  Future<void> setAuthToken(String jwtToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("jwtToken", jwtToken);
  }

//get value from shared preferences
  Future<String> getJwtToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String jwtToken = pref.getString("jwtToken") ?? null;
    return jwtToken;
  }
}
