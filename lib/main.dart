import 'package:ddroutes/module/homepage/homepage.dart';
import 'package:ddroutes/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'module/core/router.dart';
import 'module/login/login.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainAppState();
  }
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DD Routes',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      home: MyApp(),
      onGenerateRoute: createRoute,
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Widget> loadFromFuture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    return status ? Future.value(HomePage()) : Future.value(LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        navigateAfterFuture: loadFromFuture(),
        title: Text(
          'Welcome Back',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset('assets/images/logo4.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.red);
  }
}
