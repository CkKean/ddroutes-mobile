import 'package:ddroutes/model/task-model.dart';
import 'package:ddroutes/shared/util/from-json-converter.dart';

import 'company-address-model.dart';

class OrderRouteModel {
  String routeId;
  int departurePoint;
  bool roundTrip;
  DateTime departureDate;
  DateTime departureTime;
  String status;
  String vehiclePlateNo;
  double timeNeeded;
  double totalDistance;
  DateTime createdAt;
  List<TaskModel> orderList;
  List<TaskModel> displayOrderList;
  CompanyAddressModel companyAddress;

  OrderRouteModel(
      {this.routeId,
      this.departurePoint,
      this.roundTrip,
      this.departureDate,
      this.departureTime,
      this.status,
      this.vehiclePlateNo,
      this.timeNeeded,
      this.totalDistance,
      this.createdAt,
      this.orderList,
      this.displayOrderList,
      this.companyAddress});

  OrderRouteModel.copy(OrderRouteModel from)
      : this(
            routeId: from.routeId,
            departurePoint: from.departurePoint,
            roundTrip: from.roundTrip,
            departureDate: from.departureDate,
            departureTime: from.departureTime,
            status: from.status,
            vehiclePlateNo: from.vehiclePlateNo,
            timeNeeded: from.timeNeeded,
            totalDistance: from.totalDistance,
            createdAt: from.createdAt,
            orderList: from.orderList,
            displayOrderList: from.displayOrderList,
            companyAddress: from.companyAddress);

  OrderRouteModel.fromJson(json)
      : this(
            routeId: json['routeId'],
            departurePoint: json['departurePoint'],
            roundTrip: FromJsonConverter.convertIntToBool(json['roundTrip']),
            departureDate: FromJsonConverter.convertStringToDateTime(
                json['departureDate']),
            departureTime: FromJsonConverter.convertStringToDateTime(
                json['departureTime']),
            status: json['status'],
            vehiclePlateNo: json['vehiclePlateNo'],
            timeNeeded:
                FromJsonConverter.convertStringToDouble(json['timeNeeded']),
            totalDistance:
                FromJsonConverter.convertStringToDouble(json['totalDistance']),
            createdAt:
                FromJsonConverter.convertStringToDateTime(json['createdAt']),
            orderList: json['orderList']
                .map<TaskModel>((order) => TaskModel.fromJson(order))
                .toList(),
            displayOrderList: json['displayOrderList']
                .map<TaskModel>((order) => TaskModel.fromJson(order))
                .toList(),
            companyAddress:
                CompanyAddressModel.fromJson(json['companyAddress']));

  Map<String, dynamic> toJson() => {
        "routeId": routeId,
        "departurePoint": departurePoint,
        "roundTrip": roundTrip,
        "departureDate": departureDate,
        "departureTime": departureTime,
        "status": status,
        "vehiclePlateNo": vehiclePlateNo,
        "timeNeeded": timeNeeded,
        "totalDistance": totalDistance,
        "createdAt": createdAt,
      };
}
