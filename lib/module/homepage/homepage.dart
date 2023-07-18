import 'package:ddroutes/constant/api-routes.constant.dart';
import 'package:ddroutes/constant/dialog-status.constant.dart';
import 'package:ddroutes/constant/drawer-option.constant.dart';
import 'package:ddroutes/constant/routes.constant.dart';
import 'package:ddroutes/constant/user-type.constant.dart';
import 'package:ddroutes/module/core/drawer.dart';
import 'package:ddroutes/module/login/login.dart';
import 'package:ddroutes/shared/UI/shared-custom-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Items {
  String title;
  String subtitle;
  String event;
  String img;

  Items({this.title, this.subtitle, this.event, this.img});
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  String appBarTitle = "DD Routes";

  SharedPreferences prefs;
  String username;
  String fullname;
  String position;
  int userType;
  String startDate;
  String profileImg;
  String profileImgPath;
  int gridIndex;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      fullname = prefs.getString("fullName");
      position = prefs.getString("position");
      userType = prefs.getInt("userType");
      startDate = prefs.getString("startDate");
      profileImg = prefs.getString("profileImg");
      profileImgPath = prefs.getString("profileImgPath");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await sharedCustomAlertDialog(
        context: context,
        dialogStatus: DialogStatusConstant.WARNING,
        title: "Are you sure?",
        content: "Do you want to exit the App?",
        cancelText: "Cancel",
        confirmText: "Confirm",
        confirmCallback: () => Navigator.of(context).pop(true),
        cancelCallback: () => Navigator.of(context).pop(false)));
  }

  void onLogout() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()), (_) => false);
  }

  void navigateTo(String route) async {
    if (route == DrawerOptionConstant.LOGOUT) {
      onLogout();
      return;
    }

    Navigator.pushNamed(
      context,
      route,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userType == UserTypeConstant.NU) {
      gridIndex = 4;
    } else {
      gridIndex = 3;
    }

    return buildScaffold();
  }

  WillPopScope buildScaffold() {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shadowColor: Colors.transparent,
          title: Text(
            "Dashboard",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        // body: buildContentContainer(),
        body: Stack(
          children: <Widget>[dashBg, content],
        ),
        drawer: DrawerComponent(),
      ),
    );
  }

  GridView buildStaffGridView() {
    return GridView.count(
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      crossAxisCount: 2,
      childAspectRatio: .90,
      children: [
        buildContentCard(
            text: DrawerOptionConstant.TASKS,
            iconData: Icons.work_rounded,
            function: () => navigateTo(RoutesConstant.TASKS),
            color: Color(0xFFA7BBFF)),
        buildPersonalDetailCard(),
        buildLogOutCard()
      ],
    );
  }

  GridView buildNormalUserGridView() {
    return GridView.count(
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      crossAxisCount: 2,
      childAspectRatio: .90,
      children: [
        buildContentCard(
            color: Color(0xFF95EFDA),
            text: DrawerOptionConstant.CREATE_SHIPPING_ORDER,
            iconData: Icons.add_circle_rounded,
            function: () => navigateTo(RoutesConstant.CREATE_SHIPPING_ORDER)),
        buildContentCard(
            color: Color(0xFFA7BBFF),
            text: DrawerOptionConstant.MY_SHIPPING_ORDER,
            iconData: Icons.local_shipping_rounded,
            function: () => navigateTo(RoutesConstant.MY_SHIPPING_ORDER)),
        buildPersonalDetailCard(),
        buildLogOutCard()
      ],
    );
  }

  Card buildPersonalDetailCard() {
    return buildContentCard(
        text: DrawerOptionConstant.PERSONAL_DETAILS,
        iconData: Icons.perm_identity_rounded,
        function: () => navigateTo(RoutesConstant.PERSONAL_DETAILS),
        color: Color(0xFFFFA8BD));
  }

  Card buildLogOutCard() {
    return buildContentCard(
        text: DrawerOptionConstant.LOGOUT,
        iconData: Icons.power_settings_new,
        function: () => navigateTo(RoutesConstant.LOGOUT),
        color: Color(0xFFFFE4AF));
  }

  Card buildContentCard(
      {String text, IconData iconData, void function(), Color color}) {
    return Card(
      color: Colors.black.withOpacity(0.4),
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => function(),
        child: Container(
          decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Icon(
                    iconData,
                    size: 50,
                    color: color,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  get dashBg => Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Color(0xFF008C8C)),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(color: Colors.transparent),
            flex: 6,
          ),
        ],
      );

  get content => Container(
        child: Column(
          children: <Widget>[
            header,
            grid,
          ],
        ),
      );

  get header => Container(
        height: 150,
        padding: const EdgeInsets.only(top: 9, left: 6, right: 6, bottom: 4),
        margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                      child: profileImgPath != null
                          ? FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: "assets/images/default-profile.png",
                              image:
                                  '${ApiRoutesConstant.IMG_URL}$profileImgPath/$profileImg')
                          : Image.asset("assets/images/default-profile.png"),
                    )),
              ],
            ),
            Text("@$username",
                style: TextStyle(color: Colors.black, fontSize: 12)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Welcome Back",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "$fullname",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),

            // ListTile(
            //   contentPadding: EdgeInsets.only(left: 20, right: 20),
            //   title: Text(
            //     "Hi, $fullname",
            //     style: TextStyle(
            //         color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
            //   ),
            //   subtitle: Text(
            //     "Welcome Back",
            //     style: TextStyle(
            //         color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
            //   ),
            //   trailing: CircleAvatar(
            //       radius: 30.0,
            //       child: ClipOval(
            //         child: profileImgPath != null
            //             ? FadeInImage.assetNetwork(
            //                 fit: BoxFit.cover,
            //                 placeholder: "assets/images/default-profile.png",
            //                 image:
            //                     '${ApiRoutesConstant.IMG_URL}$profileImgPath/$profileImg')
            //             : Image.asset("assets/images/default-profile.png"),
            //       )),
            // ),
          ],
        ),
      );

  get grid => Expanded(
        child: Container(
          padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 16),
          child: (userType == UserTypeConstant.S ||
                  userType == UserTypeConstant.SA)
              ? buildStaffGridView()
              : buildNormalUserGridView(),
        ),
      );
}
