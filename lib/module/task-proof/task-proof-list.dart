import 'package:ddroutes/constant/dialog-status.constant.dart';
import 'package:ddroutes/constant/route-status.constant.dart';
import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/model/order-route-model.dart';
import 'package:ddroutes/model/task-model.dart';
import 'package:ddroutes/module/task-proof/task-proof-detail.dart';
import 'package:ddroutes/module/task-proof/task-route.dart';
import 'package:ddroutes/service/task-proof-service.dart';
import 'package:ddroutes/shared/UI/shared-custom-dialog.dart';
import 'package:ddroutes/shared/UI/shared-loader-dialog.dart';
import 'package:ddroutes/shared/util/identify-order-type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../constant/route-status.constant.dart';

class TaskProofList extends StatefulWidget {
  final int selectedRouteId;

  TaskProofList({Key key, this.selectedRouteId}) : super(key: key);

  @override
  TaskProofListState createState() => TaskProofListState();
}

class TaskProofListState extends State<TaskProofList>
    with SingleTickerProviderStateMixin {
  String appBarTitle = "Tasks";
  List<OrderRouteModel> oriTaskList = [];
  List<OrderRouteModel> taskList = [];
  int _activeMeterIndex;
  OrderRouteModel _selectedTask;
  Color _taskStatusColor;
  TabController _tabController;
  Future getTaskList;

  MapBoxNavigation _directions;
  MapBoxOptions _options;
  bool _isMultipleStop = false;
  double _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  double initialLatitude;
  double initialLongitude;
  String _instruction = "";
  Position currentPosition;
  bool serviceEnabled;

  int selectedPanel;
  DateFormat dateFormat = DateFormat("h:mma");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );
    _tabController.addListener(isTaskSelected);
    getTaskList = taskProofService.getTasksList();
    selectedPanel = widget.selectedRouteId;
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void isTaskSelected() async {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 1) {
        if (_selectedTask == null ||
            _selectedTask.status == RouteStatusConstant.COMPLETED) {
          await sharedCustomAlertDialog(
              context: context,
              dialogStatus: DialogStatusConstant.WARNING,
              title: "Warning",
              content: _selectedTask == null
                  ? "Please select a task."
                  : "The task is completed.",
              cancelText: "Close");

          setState(() {
            _tabController.index = 0;
          });
        }
      }
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await sharedCustomAlertDialog(
          context: context,
          dialogStatus: DialogStatusConstant.WARNING,
          title: "Warning",
          content: "Location services are disabled. Please enable it.",
          cancelCallback: Navigator.of(context).pop,
          confirmCallback: () async {
            Navigator.pop(context);
            await Geolocator.openLocationSettings();
          },
          cancelText: "Close",
          confirmText: "Setting");

      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return currentPosition;
  }

  Future<void> refreshData() async {
    setState(() {
      getTaskList = taskProofService.getTasksList();
    });
  }

  openMapsSheet(context, double lat, double long, String routeStatus) async {
    if (!checkRouteStatus(routeStatus)) {
      try {
        final coords = Coords(lat, long);
        final availableMaps = await MapLauncher.installedMaps;

        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  child: Wrap(
                    children: <Widget>[
                      for (var map in availableMaps)
                        Ink(
                          color: Colors.white,
                          child: ListTile(
                              onTap: () {
                                map.showMarker(
                                  coords: coords,
                                );
                              },
                              title: Text(
                                map.mapName,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              leading: SvgPicture.asset(
                                map.icon,
                                height: 30.0,
                                width: 30.0,
                              )),
                        ),
                      Ink(
                        color: Colors.white,
                        child: ListTile(
                            onTap: () async {
                              var wayPoints = <WayPoint>[];
                              await _determinePosition();
                              wayPoints.add(WayPoint(
                                  name: "Destination",
                                  latitude: lat,
                                  longitude: long));
                              wayPoints.add(WayPoint(
                                  name: "Origin",
                                  latitude: currentPosition.latitude,
                                  longitude: currentPosition.longitude));

                              await startNavigation(wayPoints);
                            },
                            title: Text(
                              "In App",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            leading: Icon(
                              Icons.map,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } catch (e) {
        print(e);
        return sharedCustomAlertDialog(
          title: "Warning",
          content: "There are something went wrong. Please try again later.",
          context: context,
          dialogStatus: DialogStatusConstant.WARNING,
          cancelText: "OK",
        );
      }
    }
  }

  Future<void> initialize() async {
    if (!mounted) return;

    _directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    _options = MapBoxOptions(
        zoom: 18.0,
        tilt: 50.0,
        bearing: 0.0,
        enableRefresh: false,
        alternatives: false,
        isOptimized: true,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        allowsUTurnAtWayPoints: true,
        mode: MapBoxNavigationMode.driving,
        units: VoiceUnits.metric,
        simulateRoute: false,
        animateBuildRoute: false,
        language: "en");
  }

  Future<void> startNavigation(var wayPoints) async {
    if (!mounted) return;

    await _directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  bool checkRouteStatus(String routeStatus) {
    bool isCompleted = false;
    if (routeStatus != RouteStatusConstant.READY &&
        routeStatus != RouteStatusConstant.IN_PROGRESS) {
      isCompleted = true;
      sharedCustomAlertDialog(
          context: context,
          dialogStatus: DialogStatusConstant.WARNING,
          title: "Warning",
          content: "The task is $routeStatus",
          cancelText: "Close");
    }
    return isCompleted;
  }

  void onClickStartRoute(BuildContext context,
      {String routeId,
      String routeStatus,
      bool roundTrip,
      int companyAddress}) async {
    showLoaderDialog(context, "Loading");

    if (routeId.isNotEmpty && routeStatus == RouteStatusConstant.READY) {
      IResponse response = await taskProofService.startRoute(
          routeId: routeId,
          companyAddress: companyAddress,
          roundTrip: roundTrip);
      if (response.success) {
        sharedCustomAlertDialog(
            context: context,
            dialogStatus: DialogStatusConstant.SUCCESS,
            title: "Success",
            content: response.data,
            cancelText: "Close",
            popCount: 2);
        await refreshData();
      } else {
        sharedCustomAlertDialog(
            context: context,
            dialogStatus: DialogStatusConstant.WARNING,
            title: "Failed",
            content: response.message,
            cancelText: "Close",
            popCount: 2);
      }
    }
  }

  String getLatitude({TaskModel taskModel, String routeId}) {
    String latitude;

    if (IdentifyOrderType.getOrderType(taskModel, routeId) == 0) {
      latitude = taskModel.senderLatitude;
    } else {
      latitude = taskModel.recipientLatitude;
    }

    return latitude;
  }

  String getLongitude({TaskModel taskModel, String routeId}) {
    String longitude;

    if (IdentifyOrderType.getOrderType(taskModel, routeId) == 0) {
      longitude = taskModel.senderLongitude;
    } else {
      longitude = taskModel.recipientLongitude;
    }

    return longitude;
  }

  String getAddress({TaskModel taskModel}) {
    return "${taskModel.recipientAddress}, ${taskModel.recipientPostcode} ${taskModel.recipientCity}, Malaysia";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderRouteModel>>(
        future: getTaskList,
        builder: (context, AsyncSnapshot<List<OrderRouteModel>> snapshot) {
          if (snapshot.hasData) {
            oriTaskList = [...snapshot.data];
            taskList = [...snapshot.data];
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
            Text('Data loading'),
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
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: buildTab(),
          body: buildTabBarView(context),
        ),
      ),
    );
  }

  PreferredSize buildTab() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 15.0),
      child: ColoredBox(
        color: Colors.white70,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 14.0,
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).accentColor,
              indicatorWeight: 3,
              tabs: [
                buildTabBarItem(Icons.assignment_turned_in, "Tasks List"),
                buildTabBarItem(Icons.alt_route, "Route")
              ],
            )
          ],
        ),
      ),
    );
  }

  Container buildTabBarItem(IconData icons, String title) {
    return Container(
      height: 50.0,
      child: Tab(
        child: Column(
          children: <Widget>[
            Icon(icons, size: 20.0, color: Colors.black),
            Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  TabBarView buildTabBarView(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Tab(child: _buildTasksContainer(context)),
        Tab(
          child: (_selectedTask != null &&
                  _selectedTask.status == RouteStatusConstant.IN_PROGRESS)
              ? TaskRoute(selectedTask: _selectedTask)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 50),
                      Text('Loading'),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  RefreshIndicator _buildTasksContainer(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
        return await refreshData();
      },
      child: Container(
        height: height,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: (taskList.length == 0)
              ? Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("No task"),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (taskList.length > 0)
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: taskList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildExpansionTile(context,
                              taskListIndex: index,
                              taskStatus: taskList[index].status);
                        },
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Container buildExpansionTile(BuildContext context,
      {int taskListIndex, String taskStatus}) {
    if (selectedPanel != null) {
      _activeMeterIndex = selectedPanel;
      _selectedTask = taskList[widget.selectedRouteId];
      selectedPanel = null;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool status) {
          if (taskStatus == RouteStatusConstant.READY) {
            sharedCustomAlertDialog(
                context: context,
                title: "Warning",
                content: "The task have not start yet.",
                popCount: 1,
                cancelText: "Close",
                dialogStatus: DialogStatusConstant.WARNING);
            return;
          }
          setState(() {
            _activeMeterIndex =
                _activeMeterIndex == taskListIndex ? null : taskListIndex;
            _selectedTask =
                _activeMeterIndex != null ? taskList[taskListIndex] : null;
          });
        },
        children: [
          new ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _activeMeterIndex == taskListIndex,
            backgroundColor: _activeMeterIndex == taskListIndex
                ? Colors.yellow.shade50
                : Colors.white,
            headerBuilder: (BuildContext context, bool isExpanded) => Container(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  if (taskList[taskListIndex].status ==
                      RouteStatusConstant.READY)
                    buildReadyHeader(taskListIndex, context),
                  buildHeaderTitle(
                      taskList[taskListIndex], taskListIndex, context),
                ],
              ),
            ),
            body: Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) => Card(
                        margin: const EdgeInsets.all(7.0),
                        color: Colors.transparent,
                        elevation: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 7.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white),
                          child: InkWell(
                            onTap: () {
                              if (!checkRouteStatus(
                                  taskList[taskListIndex].status)) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TaskProofDetail(
                                          panelActiveIndex: _activeMeterIndex,
                                          routeId:
                                              taskList[taskListIndex].routeId,
                                          taskModel: taskList[taskListIndex]
                                              .displayOrderList[index])),
                                );
                              }
                            },
                            child: ListTile(
                              leading: _buildListLeading(
                                index: index,
                                orderType: taskList[taskListIndex]
                                    .displayOrderList[index]
                                    .displayMobileOrderType,
                              ),
                              title: SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: _buildListTitle(
                                        trackingNo:
                                            "${taskList[taskListIndex].displayOrderList[index].trackingNo}",
                                        orderStatus: taskList[taskListIndex]
                                            .displayOrderList[index]
                                            .displayOrderStatus,
                                        index: index),
                                  )),
                              subtitle: SizedBox(
                                  width: double.infinity,
                                  child: _buildListSubtitle(
                                      recipientName: taskList[taskListIndex]
                                          .displayOrderList[index]
                                          .recipientName,
                                      recipientAddress: getAddress(
                                        taskModel: taskList[taskListIndex]
                                            .displayOrderList[index],
                                      ),
                                      index: index)),
                              isThreeLine: true,
                              trailing: _buildTaskNavigationButton(context,
                                  latitude: taskList[taskListIndex]
                                      .displayOrderList[index]
                                      .recipientLatitude,
                                  longitude: taskList[taskListIndex]
                                      .displayOrderList[index]
                                      .recipientLongitude,
                                  routeStatus: taskList[taskListIndex].status),
                            ),
                          ),
                        ),
                      ),
                  itemCount: taskList[taskListIndex].displayOrderList.length),
            ),
          ),
        ],
      ),
    );
  }

  Flexible buildHeaderTitle(
      OrderRouteModel task, int taskListIndex, BuildContext context) {
    if (task.status == RouteStatusConstant.READY) {
      _taskStatusColor = Colors.redAccent;
    } else if (task.status == RouteStatusConstant.IN_PROGRESS) {
      _taskStatusColor = Colors.blue;
    } else {
      _taskStatusColor = Colors.green;
    }

    return Flexible(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    color: _taskStatusColor,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child:
                      Text(task.status, style: TextStyle(color: Colors.white)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 3),
                child: Text(
                  DateFormat('dd-MM-yyyy').format(task.departureDate),
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          Text(
            "${taskList[taskListIndex].routeId}",
            style: TextStyle(color: Colors.black, fontSize: 15),
            softWrap: true,
          ),
          buildContentRow(
              iconData: Icons.access_time_rounded,
              text: "${dateFormat.format(task.departureTime)}"),
          if (task.roundTrip)
            buildContentRow(iconData: Icons.check, text: "Round Trip"),
          buildContentRow(
              iconData: Icons.directions_car_rounded,
              text: "${task.vehiclePlateNo}"),
          buildContentRow(
              iconData: Icons.location_city_rounded,
              text:
                  "${task.companyAddress.address},${task.companyAddress.postcode} ${task.companyAddress.city}"),
        ],
      ),
    );
  }

  Row buildContentRow({IconData iconData, String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 18,
          child: Icon(
            iconData,
            size: 15,
          ),
        ),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 15),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Column buildReadyHeader(int taskListIndex, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 5),
          width: 70,
          child: MaterialButton(
            onPressed: () async {
              DateTime currentDT = DateTime.now();
              DateTime earlierTime = taskList[taskListIndex].departureTime.subtract(Duration(minutes: 15));

              if (currentDT.compareTo(earlierTime) < 0) {
                await sharedCustomAlertDialog(
                    context: context,
                    dialogStatus: DialogStatusConstant.WARNING,
                    title: "Warning",
                    content:
                        'Only can start at ${dateFormat.format(taskList[taskListIndex].departureTime)} or 15 minutes before departure time.',
                    cancelText: "Close");
                return;
              } else {
                if (taskList[taskListIndex].status ==
                    RouteStatusConstant.READY) {
                  onClickStartRoute(
                    context,
                    routeId: taskList[taskListIndex].routeId,
                    routeStatus: taskList[taskListIndex].status,
                    companyAddress: taskList[taskListIndex].companyAddress.id,
                    roundTrip: taskList[taskListIndex].roundTrip,
                  );
                  return;
                }
              }
            },
            elevation: 5.0,
            color: Theme.of(context).accentColor,
            disabledColor: Colors.grey.shade400,
            child: Text(
              "Start",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildListLeading({int index, String orderType}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "#${index + 1} \n",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                  text: orderType,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.black))
            ],
          ),
        ),
      ],
    );
  }

  RichText _buildListTitle({String trackingNo, int index, String orderStatus}) {
    Color color;
    if (orderStatus == RouteStatusConstant.COMPLETED) {
      color = Colors.green;
    } else if (orderStatus == RouteStatusConstant.IN_PROGRESS) {
      color = Colors.blueAccent;
    } else if (orderStatus == RouteStatusConstant.FAILED) {
      color = Colors.red;
    } else if (orderStatus == RouteStatusConstant.PENDING) {
      color = Colors.orange;
    } else if (orderStatus == RouteStatusConstant.PICKED_UP) {
      color = Colors.lime;
    } else {
      color = Colors.grey;
    }

    return RichText(
      text: TextSpan(
        text: "$trackingNo \n",
        style:
            Theme.of(context).textTheme.headline5.copyWith(color: Colors.black),
        children: <TextSpan>[
          TextSpan(
              text: "$orderStatus",
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(color: color))
        ],
      ),
    );
  }

  Text _buildListSubtitle(
      {String recipientName, String recipientAddress, int index}) {
    return Text(
      ("$recipientName \n$recipientAddress"),
      style:
          Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.black),
      textAlign: TextAlign.left,
    );
  }

  IconButton _buildTaskNavigationButton(BuildContext context,
      {String latitude, String longitude, String routeStatus}) {
    return IconButton(
        icon: Icon(Icons.directions_rounded),
        iconSize: 35,
        color: Colors.blue,
        onPressed: () async {
          await openMapsSheet(context, double.parse(latitude),
              double.parse(longitude), routeStatus);
        });
  }

  Future<void> _onRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null)
          _instruction = progressEvent.currentStepInstruction;
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        _routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        _routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        _isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        _routeBuilt = false;
        _isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }
}
