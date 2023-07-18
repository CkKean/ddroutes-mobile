import 'package:ddroutes/shared/util/from-json-converter.dart';

class TrackingModel {
  String orderStatus;
  String trackingNo;
  String orderType;
  String orderNo;
  String routeStatus;
  String pickupOrderStatus;
  String pickupReason;
  String deliveryReason;
  DateTime orderPlacedAt;
  DateTime orderShippedAt;
  DateTime orderEstShippedAt;
  DateTime orderComingAt;
  DateTime orderEstComingAt;
  DateTime orderReceivedAt;
  DateTime orderPickedAt;
  DateTime orderCompletedAt;

  TrackingModel({
    this.orderStatus,
    this.trackingNo,
    this.orderType,
    this.orderNo,
    this.routeStatus,
    this.pickupOrderStatus,
    this.orderPlacedAt,
    this.orderShippedAt,
    this.orderEstShippedAt,
    this.orderComingAt,
    this.orderEstComingAt,
    this.orderReceivedAt,
    this.orderPickedAt,
    this.orderCompletedAt,
    this.pickupReason,
    this.deliveryReason,
  });

  TrackingModel.copy(TrackingModel from)
      : this(
          orderStatus: from.orderStatus,
          trackingNo: from.trackingNo,
          orderType: from.orderType,
          orderNo: from.orderNo,
          routeStatus: from.routeStatus,
          pickupOrderStatus: from.pickupOrderStatus,
          orderPlacedAt: from.orderPlacedAt,
          orderShippedAt: from.orderShippedAt,
          orderEstShippedAt: from.orderEstShippedAt,
          orderComingAt: from.orderComingAt,
          orderEstComingAt: from.orderEstComingAt,
          orderReceivedAt: from.orderReceivedAt,
          orderPickedAt: from.orderPickedAt,
          orderCompletedAt: from.orderCompletedAt,
          pickupReason: from.pickupReason,
          deliveryReason: from.deliveryReason,
        );

  TrackingModel.fromJson(json)
      : this(
          orderStatus: json["orderStatus"],
          trackingNo: json["trackingNo"],
          orderType: json["orderType"],
          orderNo: json["orderNo"],
          deliveryReason: json["deliveryReason"],
          pickupReason: json["pickupReason"],
          routeStatus: json["routeStatus"],
          pickupOrderStatus: json["pickupOrderStatus"],
          orderPlacedAt:
              FromJsonConverter.convertStringToDateTime(json["orderPlacedAt"]),
          orderShippedAt:
              FromJsonConverter.convertStringToDateTime(json["orderShippedAt"]),
          orderComingAt:
              FromJsonConverter.convertStringToDateTime(json["orderComingAt"]),
          orderEstShippedAt: FromJsonConverter.convertStringToDateTime(
              json["orderEstShippedAt"]),
          orderEstComingAt: FromJsonConverter.convertStringToDateTime(
              json["orderEstComingAt"]),
          orderReceivedAt: FromJsonConverter.convertStringToDateTime(
              json["orderReceivedAt"]),
          orderPickedAt:
              FromJsonConverter.convertStringToDateTime(json["orderPickedAt"]),
          orderCompletedAt: FromJsonConverter.convertStringToDateTime(
              json["orderCompletedAt"]),
        );

  Map<String, dynamic> toJson() => {
        "orderStatus": orderStatus,
        "trackingNo": trackingNo,
        "orderType": orderType,
        "orderNo": orderNo,
        "pickupReason": pickupReason,
        "deliveryReason": deliveryReason,
        "routeStatus": routeStatus,
        "pickupOrderStatus": pickupOrderStatus,
        "orderPlacedAt": orderPlacedAt,
        "orderShippedAt": orderShippedAt,
        "orderEstShippedAt": orderEstShippedAt,
        "orderComingAt": orderComingAt,
        "orderEstComingAt": orderEstComingAt,
        "orderReceivedAt": orderReceivedAt,
        "orderPickedAt": orderPickedAt,
        "orderCompletedAt": orderCompletedAt,
      };
}
