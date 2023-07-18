import 'package:ddroutes/constant/api-routes.constant.dart';
import 'package:ddroutes/constant/drawer-option.constant.dart';
import 'package:ddroutes/constant/user-type.constant.dart';
import 'package:ddroutes/module/login/login.dart';
import 'package:ddroutes/shared/UI/oval-right-clipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerComponent extends StatefulWidget {
  DrawerComponent({Key key}) : super(key: key);

  @override
  DrawerComponentState createState() => DrawerComponentState();
}

class DrawerComponentState extends State<DrawerComponent> {
  String appBarTitle = "DD Routes";
  String username;
  int userType;
  String position;
  String jwtToken;
  String profileImg;
  String profileImgPath;

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      userType = prefs.getInt("userType");
      position = prefs.getString("position");
      jwtToken = prefs.getString("jwtToken");
      profileImg = prefs.getString("profileImg");
      profileImgPath = prefs.getString("profileImgPath");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDrawerRowTapped(String choice) async {
    if (choice == DrawerOptionConstant.LOGOUT) {
      onLogout();
      return;
    }

    Navigator.popAndPushNamed(
      context,
      choice,
    );
  }

  void onLogout() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return buildDrawer();
  }

  ClipPath buildDrawer() {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 35),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                      ),
                      onPressed: () {
                        onLogout();
                      },
                    ),
                  ),
                  Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue,
                          width: 5,
                        ),
                        image: DecorationImage(
                          image: (profileImgPath != null && profileImg != null)
                              ? NetworkImage(
                                  '${ApiRoutesConstant.IMG_URL}$profileImgPath/$profileImg')
                              : AssetImage(
                                  "assets/images/default-profile-img.jpg"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  SizedBox(height: 5.0),
                  Text(
                    username ?? "Default Value",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 30.0),
                  buildDrawerRow(Icons.home, DrawerOptionConstant.HOMEPAGE),
                  if (userType != UserTypeConstant.NU)
                    buildDrawerRow(
                        Icons.work_rounded, DrawerOptionConstant.TASKS),
                  if (userType == UserTypeConstant.NU)
                    buildDrawerRow(Icons.local_shipping_rounded,
                        DrawerOptionConstant.MY_SHIPPING_ORDER),
                  if (userType == UserTypeConstant.NU)
                    buildDrawerRow(Icons.add_circle_rounded,
                        DrawerOptionConstant.CREATE_SHIPPING_ORDER),
                  buildDrawerRow(
                      Icons.power_settings_new, DrawerOptionConstant.LOGOUT),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buildDrawerRow(IconData icon, String title) {
    return GestureDetector(
        onTap: () {
          onDrawerRowTapped(title);
        },
        child: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(children: [
              Icon(
                icon,
              ),
              SizedBox(width: 10.0),
              Text(
                title,
                style: TextStyle(fontSize: 16.0),
              ),
              Spacer(),
            ]),
          ),
          buildDivider()
        ]));
  }

  Divider buildDivider() {
    return Divider(
      color: Colors.grey.shade500,
    );
  }
}
