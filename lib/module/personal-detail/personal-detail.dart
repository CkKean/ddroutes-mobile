import 'package:ddroutes/constant/api-routes.constant.dart';
import 'package:ddroutes/constant/user-type.constant.dart';
import 'package:ddroutes/model/user-model.dart';
import 'package:ddroutes/service/user-service.dart';
import 'package:ddroutes/shared/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalDetail extends StatefulWidget {
  const PersonalDetail({Key key}) : super(key: key);

  @override
  _PersonalDetailState createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail>
    with SingleTickerProviderStateMixin {
  UserModel userInformation;
  Future getUserInfo;
  String appBarTitle = "Personal Detail";
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    getUserInfo = userService.getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: getUserInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userInformation = snapshot.data;
            print(userInformation.profileImg);
            print(userInformation.profileImgPath);
            return _buildScaffold();
          }
          return _buildLoading();
        });
  }

  Scaffold _buildLoading() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 50),
            Text('Data is loading...'),
          ],
        ),
      ),
    );
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (userInformation.profileImgPath != null &&
                    userInformation.profileImg != null)
                ? containerImage()
                : containerNoImage(),
            Container(
              child: TabBar(
                labelStyle: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600),
                tabs: [
                  tab(title: "Personal Information"),
                  tab(title: "Contact Information"),
                  tab(title: "Address Information"),
                  tab(title: "Account Information"),
                ],
                controller: _tabController,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueAccent),
                isScrollable: true,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Card(
                      margin: EdgeInsets.all(10),
                      elevation: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildDetailInfo(context,
                                  label: "Full Name",
                                  detail: userInformation.fullName),
                              buildDetailInfo(context,
                                  label: "Gender",
                                  detail: userInformation.gender == "M"
                                      ? "Male"
                                      : "Female"),
                              buildDetailInfo(context,
                                  label: "Date Of Birth",
                                  detail: userInformation.dob
                                      .toString()
                                      .substring(0, 10)),
                              buildDetailInfo(context,
                                  label: "Race", detail: userInformation.race),
                              buildDetailInfo(context,
                                  label: "Religion",
                                  detail: userInformation.religion),
                            ]),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Card(
                      margin: EdgeInsets.all(10),
                      elevation: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildDetailInfo(context,
                                  label: "Email",
                                  detail: userInformation.email),
                              buildDetailInfo(context,
                                  label: "Mobile Number",
                                  detail: userInformation.mobileNo
                                              .substring(0, 2) ==
                                          '60'
                                      ? userInformation.mobileNo
                                      : '60' + userInformation.mobileNo),
                            ]),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Card(
                      margin: EdgeInsets.all(10),
                      elevation: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildDetailInfo(context,
                                label: "Address",
                                detail: "${userInformation.address}"),
                            buildDetailInfo(context,
                                label: "Postcode",
                                detail: "${userInformation.postcode}"),
                            buildDetailInfo(context,
                                label: "City",
                                detail: "${userInformation.city}"),
                            buildDetailInfo(context,
                                label: "State",
                                detail: "${userInformation.state}"),
                            buildDetailInfo(context,
                                label: "Country", detail: "Malaysia"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Card(
                      margin: EdgeInsets.all(10),
                      elevation: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildDetailInfo(context,
                                label: "Username",
                                detail: userInformation.username),
                            buildDetailInfo(context,
                                label: "User Type",
                                detail: UserTypeConstant.getUserType(
                                    userInformation.userType)),
                            if (userInformation.userType != UserTypeConstant.NU)
                              buildDetailInfo(context,
                                  label: "Position",
                                  detail: userInformation.position),
                            if (userInformation.userType == UserTypeConstant.S)
                              buildDetailInfo(context,
                                  label: "Joined Date",
                                  detail: userInformation.startDate != null
                                      ? userInformation.startDate
                                          .toString()
                                          .substring(0, 10)
                                      : null),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Tab tab({String title}) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.blueAccent, width: 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }

  Container containerNoImage() {
    return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(40.0),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0, // soften the shadow
                spreadRadius: 1.0, //extend the shadow
                offset: Offset(
                  1.0, // Move to right 10  horizontally
                  1.0, // Move to bottom 10 Vertically
                ),
              )
            ],
            border: Border.all(
              color: Colors.green,
              width: 3,
            ),
            color: Colors.green.shade300,
            shape: BoxShape.circle),
        child: Text(
          "${userInformation.fullName[0] + userInformation.fullName.split(' ')[1][0]}",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ));
  }

  Container containerImage() {
    return Container(
      margin: EdgeInsets.all(30.0),
      padding: EdgeInsets.all(50.0),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                '${ApiRoutesConstant.IMG_URL}${userInformation.profileImgPath}/${userInformation.profileImg}'),
            fit: BoxFit.contain,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                1.0, // Move to right 10  horizontally
                1.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          border: Border.all(
            color: Colors.green,
            width: 3,
          ),
          color: Colors.green.shade300,
          shape: BoxShape.circle),
    );
  }

  Card buildNormalUserCard() {
    return Card(
        elevation: 5.0,
        margin: EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildTitlePadding(context, title: "Personal Information"),
                buildDetailInfo(context,
                    label: "Full Name", detail: userInformation.fullName),
                buildDetailInfo(context,
                    label: "Mobile Number", detail: userInformation.mobileNo),
                buildDetailInfo(context,
                    label: "Email", detail: userInformation.email),
                buildDetailInfo(context,
                    label: "Address", detail: userInformation.address),
                buildDetailInfo(context,
                    label: "Postcode", detail: userInformation.postcode),
                buildDetailInfo(context,
                    label: "City", detail: userInformation.city),
                buildDetailInfo(context,
                    label: "State", detail: userInformation.state),
              ]),
        ));
  }

  Center buildContainer(String label, int number) {
    return Center(
      child: Container(
        width: 300,
        // height:,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                1.0, // Move to right 10  horizontally
                1.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(8.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "$label \n",
            style: TextStyle(
                color: createMaterialColor(Color(0xFF424B57)), fontSize: 19.0),
            children: <TextSpan>[
              TextSpan(
                  text: "$number", style: Theme.of(context).textTheme.headline1)
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTitlePadding(BuildContext context, {String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w600,
              fontSize: 26.0,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Padding buildDetailInfo(BuildContext context,
      {String label, dynamic detail}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label:",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w600),
            softWrap: true,
          ),
          Text(
            detail != null ? "$detail" : "-",
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
