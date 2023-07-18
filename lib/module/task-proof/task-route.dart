import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ddroutes/constant/route-status.constant.dart';
import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/model/order-route-model.dart';
import 'package:ddroutes/model/route-distance-duration-model.dart';
import 'package:ddroutes/model/task-model.dart';
import 'package:ddroutes/service/task-proof-service.dart';
import 'package:ddroutes/shared/util/identify-order-type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import './map-bottom-pill.dart';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 20;
const double PIN_VISIBLE_POSITION = 15;
const double PIN_INVISIBLE_POSITION = -220;

class TaskRoute extends StatefulWidget {
  final OrderRouteModel selectedTask;

  TaskRoute({Key key, this.selectedTask}) : super(key: key);

  @override
  TaskRouteState createState() => TaskRouteState();
}

class TaskRouteState extends State<TaskRoute> {
  String appBarTitle = "Navigation";
  OrderRouteModel orderRoute;
  double pinPillPosition = PIN_VISIBLE_POSITION;

  LatLng _startPosition;
  LatLng _destinationPosition;

  GoogleMapController mapController;

  Marker startMarker;
  Marker destinationMarker;

  List<Marker> markersList = [];
  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  Future myFuture;
  LatLngBounds latLngBounds;

  String totalDuration = '0';
  Future totalDurationFuture;

  _createPolylines() async {
    polylinePoints = PolylinePoints();

    List<PolylineWayPoint> wayPoints = [];
    int i = 0;

    for (int i = 0; i < orderRoute.displayOrderList.length; i++) {
      TaskModel tempTaskModel = orderRoute.displayOrderList[i];
      Marker marker;
      String latitude;
      String longitude;
      String address;

      longitude = tempTaskModel.recipientLongitude;
      latitude = tempTaskModel.recipientLatitude;
      address = tempTaskModel.recipientAddress +
          ', ' +
          tempTaskModel.recipientPostcode +
          ' ' +
          tempTaskModel.recipientCity +
          ',' +
          tempTaskModel.recipientState +
          ', Malaysia';

      Color color;
      if (tempTaskModel.displayOrderStatus == RouteStatusConstant.FAILED) {
        color = Colors.red;
      } else if (tempTaskModel.displayOrderStatus ==
          RouteStatusConstant.IN_PROGRESS) {
        color = Colors.blue;
      } else if (tempTaskModel.displayOrderStatus ==
              RouteStatusConstant.COMPLETED ||
          tempTaskModel.displayOrderStatus == RouteStatusConstant.DELIVERED ||
          tempTaskModel.displayOrderStatus == RouteStatusConstant.PICKED_UP) {
        color = Colors.green;
      }

      wayPoints.add(new PolylineWayPoint(location: ("$latitude,$longitude")));

      marker = new Marker(
          markerId: MarkerId('${i + 1}'),
          onTap: () {
            setState(() {
              this.pinPillPosition = PIN_VISIBLE_POSITION;
            });
          },
          position: LatLng(
            double.parse(latitude),
            double.parse(longitude),
          ),
          // infoWindow: InfoWindow(
          //   title: address,
          //   snippet: address,
          // ),
          icon: await getMarkerIcon(Size(80.0, 80.0), i, color));

      markersList.add(marker);
    }

    markers.addAll(markersList);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyB0aRG_lW_Ll2yRrmF1TPMcMt-nyOozXEw", // Google Maps API Key
      PointLatLng(_startPosition.latitude, _startPosition.longitude),
      PointLatLng(
          _destinationPosition.latitude, _destinationPosition.longitude),
      optimizeWaypoints: false,
      travelMode: TravelMode.driving,
      wayPoints: wayPoints,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      PolylineId id = PolylineId('poly');
      Polyline polyline;
      polyline = Polyline(
          polylineId: id,
          color: Color.fromARGB(255, 40, 122, 198).withOpacity(0.5),
          points: polylineCoordinates,
          width: 5,
          visible: true,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap);

      polylines[id] = polyline;
    });
  }

  void setSourceAndDestinationMarkerIcons() async {
    startMarker = Marker(
        markerId: MarkerId('Start'),
        position: LatLng(
          _startPosition.latitude,
          _startPosition.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Start',
          snippet: orderRoute.companyAddress.address,
        ),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          setState(() {
            this.pinPillPosition = PIN_VISIBLE_POSITION;
          });
        });

    if (orderRoute.roundTrip) {
      startMarker = Marker(
          markerId: MarkerId('Start & End'),
          position: LatLng(
            _startPosition.latitude,
            _startPosition.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start & End',
            snippet: orderRoute.companyAddress.address,
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            setState(() {
              this.pinPillPosition = PIN_VISIBLE_POSITION;
            });
          });
    }

    markers.add(startMarker);
  }

  void setInitialLocation() {
    _startPosition = LatLng(
      orderRoute.companyAddress.latitude,
      orderRoute.companyAddress.longitude,
    );

    String latitude;
    String longitude;
    if (IdentifyOrderType.getOrderType(
            orderRoute.orderList.last, orderRoute.routeId) ==
        0) {
      longitude = orderRoute.orderList.last.senderLongitude;
      latitude = orderRoute.orderList.last.senderLatitude;
    } else {
      longitude = orderRoute.orderList.last.recipientLongitude;
      latitude = orderRoute.orderList.last.recipientLatitude;
    }

    if (orderRoute.roundTrip) {
      _destinationPosition = _startPosition;
    } else {
      _destinationPosition =
          LatLng(double.parse(latitude), double.parse(longitude));
    }
  }

  void getTotalDuration() async {
    RouteDistanceDurationModel routeDistanceDuration =
        new RouteDistanceDurationModel(
            companyAddress: orderRoute.companyAddress,
            roundTrip: orderRoute.roundTrip,
            orderList: orderRoute.displayOrderList);
    IResponse result = await taskProofService.getDistanceTime(
        routeDistanceDuration: routeDistanceDuration);
    totalDuration = result.data['text'];
  }

  @override
  void initState() {
    super.initState();
    orderRoute = widget.selectedTask;
    setInitialLocation();
    setSourceAndDestinationMarkerIcons();
    latLngBounds = boundsFromLatLngList();
    getTotalDuration();
    myFuture = _createPolylines();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialCameraPosition = CameraPosition(
        target: LatLng(orderRoute.companyAddress.latitude,
            orderRoute.companyAddress.longitude),
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        zoom: CAMERA_ZOOM);

    return FutureBuilder<dynamic>(
        future: myFuture,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildMap(_initialCameraPosition);
          }
          return _buildLoading();
        });
  }

  Center _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 50),
          Text('Map is loading...'),
        ],
      ),
    );
  }

  Container _buildMap(CameraPosition initialCameraPosition) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: markers != null ? Set<Marker>.from(markers) : null,
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: initialCameraPosition,
              compassEnabled: false,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: true,
              tiltGesturesEnabled: false,
              mapType: MapType.normal,
              trafficEnabled: false,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onCameraMoveStarted: () {
                setState(() {
                  this.pinPillPosition = PIN_INVISIBLE_POSITION;
                });
              },
              onCameraIdle: () {
                setState(() {
                  this.pinPillPosition = PIN_VISIBLE_POSITION;
                });
              },
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  mapController = controller;
                });
                mapController.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    latLngBounds,
                    100, // padding
                  ),
                );
              },
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.white.withOpacity(0.7), // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 35,
                            height: 35,
                            child: Icon(Icons.zoom_in),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ClipOval(
                      child: Material(
                        color: Colors.white.withOpacity(0.7), // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 35,
                            height: 35,
                            child: Icon(Icons.zoom_out),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ClipOval(
                      child: Material(
                        color: Colors.white.withOpacity(0.7), // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 35,
                            height: 35,
                            child: Icon(Icons.zoom_out_map_rounded),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                latLngBounds,
                                100, // padding
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                left: 0,
                right: 0,
                bottom: this.pinPillPosition,
                child: MapBottomPill(
                  companyAddressModel: orderRoute.companyAddress,
                  taskModel: orderRoute.displayOrderList,
                  roundTrip: orderRoute.roundTrip,
                  routeId: orderRoute.routeId,
                  totalDistance: "${orderRoute.totalDistance.toString()} KM",
                  totalDuration: totalDuration,
                )),
          ],
        ),
      ),
    );
  }

  Future<BitmapDescriptor> getMarkerIcon(
      Size size, int index, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Radius radius = Radius.circular(size.width / 2);
    final Paint shadowPaint = Paint()..color = color;
    final double shadowWidth = 10.0;
    final Paint borderPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);
    // Add Middle Text
    TextPainter insideText = TextPainter(textDirection: TextDirection.ltr);
    insideText.text = TextSpan(
      text: "${index + 1}",
      style: TextStyle(
          fontSize: 23.0, color: Colors.black, fontWeight: FontWeight.w600),
    );
    insideText.layout();
    insideText.paint(
        canvas,
        Offset(size.width - size.width / 2 - insideText.width / 2,
            size.width / 2 - insideText.height / 2));
    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  LatLngBounds boundsFromLatLngList() {
    double x0, x1, y0, y1;
    TaskModel startPoint = new TaskModel(
        recipientLatitude: orderRoute.companyAddress.latitude.toString(),
        recipientLongitude: orderRoute.companyAddress.longitude.toString());
    List<TaskModel> orderList = [...widget.selectedTask.orderList, startPoint];

    for (var task in orderList) {
      double latitude = double.parse(task.recipientLatitude);
      double longitude = double.parse(task.recipientLongitude);

      if (x0 == null) {
        x0 = x1 = latitude;
        y0 = y1 = longitude;
      } else {
        if (latitude > x1) x1 = latitude;
        if (latitude < x0) x0 = latitude;
        if (longitude > y1) y1 = longitude;
        if (longitude < y0) y0 = longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
