import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ddroutes/constant/dialog-status.constant.dart';
import 'package:ddroutes/constant/routes.constant.dart';
import 'package:ddroutes/model/auth-model.dart';
import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/service/authentication-service.dart';
import 'package:ddroutes/shared/UI/shared-custom-dialog.dart';
import 'package:ddroutes/shared/UI/shared-loader-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isUsernameValid = false;
  bool isPasswordValid = false;
  bool isPasswordVisible = true;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  void signIn(username, password) async {
    var key = utf8.encode(password);
    var digest = sha256.convert(key).toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      showLoaderDialog(context, "Processing...");
      IResponse result = await authenticationService.signIn(username, digest);
      Navigator.pop(context);
      if (result.success) {
        final AuthModel authModel = AuthModel.fromJson(result.data);
        prefs.setString("jwtToken", authModel.jwtToken);
        prefs.setString("username", authModel.username);
        prefs.setString("fullName", authModel.fullname);
        prefs.setInt("userType", authModel.userType);
        prefs.setString("startDate", authModel.startDate.toString());
        if (authModel.profileImg != null && authModel.profileImgPath != null) {
          prefs.setString("profileImg", authModel.profileImg);
          prefs.setString("profileImgPath", authModel.profileImgPath);
        }

        prefs.setBool("isLoggedIn", true);
        if (authModel.userType != 2) {
          prefs.setString("position", authModel.position ?? null);
        }
        Navigator.pushReplacementNamed(context, RoutesConstant.HOMEPAGE);
      } else {
        sharedCustomAlertDialog(
            context: context,
            title: "Login Error",
            content: result.message,
            cancelText: "Close",
            popCount: 1,
            dialogStatus: DialogStatusConstant.ERROR);
      }
    } catch (error) {
      sharedCustomAlertDialog(
          context: context,
          title: "Login Error",
          content: error.toString(),
          cancelText: "Close",
          popCount: 1,
          dialogStatus: DialogStatusConstant.ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/login_bg.jpg',
                  ),
                  fit: BoxFit.cover,
              )),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 55),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/logo4.png',
                                width: 300, height: 80),
                            SizedBox(height: 20),
                            _formEntryField(
                                title: "Username",
                                controller: username,
                                errorText: 'The username field cannot be empty',
                                validate: isUsernameValid),
                            _formEntryField(
                              title: "Password",
                              controller: password,
                              errorText: "The password field cannot be empty",
                              validate: isPasswordValid,
                              icon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  icon: isPasswordVisible
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off)),
                            ),
                            SizedBox(height: 30),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  password.text.isEmpty
                                      ? isPasswordValid = true
                                      : isPasswordValid = false;
                                  username.text.isEmpty
                                      ? isUsernameValid = true
                                      : isUsernameValid = false;
                                });

                                if (username.text.isNotEmpty &&
                                    password.text.isNotEmpty)
                                  signIn(username.text, password.text);
                              },
                              child: Container(
                                width: 130,
                                padding: EdgeInsets.symmetric(vertical: 13),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).accentColor),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _formEntryField(
      {String title,
      TextEditingController controller,
      bool validate,
      String errorText,
      IconButton icon}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 10),
          if (title == "Password")
            TextField(
                controller: controller,
                style: TextStyle(color: Colors.black, fontSize: 18),
                obscureText: isPasswordVisible,
                decoration: inputDecoration(title, icon, validate, errorText)),
          if (title == "Username")
            TextField(
                controller: controller,
                style: TextStyle(color: Colors.black, fontSize: 18),
                obscureText: title == "Password" ? isPasswordVisible : false,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                decoration: inputDecoration(title, icon, validate, errorText))
        ],
      ),
    );
  }

  InputDecoration inputDecoration(
      String title, IconButton icon, bool validate, String errorText) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
        borderRadius: BorderRadius.circular(25.7),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
        borderRadius: BorderRadius.circular(25.7),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(25.7),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(25.7),
      ),
      prefixIcon: title == "Password" ? Icon(Icons.lock) : Icon(Icons.person),
      suffixIcon: title == "Password" ? icon : null,
      errorText: validate ? '$errorText' : null,
      border: InputBorder.none,
      fillColor: Colors.white,
      filled: true,
      contentPadding: title != "Password"
          ? const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0)
          : const EdgeInsets.only(left: 14.0, top: 13.0),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
