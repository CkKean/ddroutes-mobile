import 'package:ddroutes/shared/util/from-json-converter.dart';

class TaskModel {
  String senderName;
  String senderMobileNo;
  String senderAddress;
  String senderCity;
  String senderState;
  String senderPostcode;
  String senderLatitude;
  String senderLongitude;

  String recipientName;
  String recipientMobileNo;
  String recipientAddress;
  String recipientCity;
  String recipientState;
  String recipientPostcode;
  String recipientLatitude;
  String recipientLongitude;

  int itemQty;
  String itemWeight;
  String routeId;
  String orderNo;
  String trackingNo;
  String orderType;
  String orderStatus;
  bool isPickedUp;
  String pickupOrderStatus;
  String pickupProofId;
  int pickupSortId;
  String pickupRouteId;

  String displayOrderType;
  String displayOrderStatus;
  String displayMobileOrderType;
  String displayMobileNo;

  TaskModel(
      {this.senderName,
      this.senderMobileNo,
      this.senderAddress,
      this.senderCity,
      this.senderState,
      this.senderPostcode,
      this.senderLatitude,
      this.senderLongitude,
      this.recipientName,
      this.recipientMobileNo,
      this.recipientAddress,
      this.recipientCity,
      this.recipientState,
      this.recipientPostcode,
      this.recipientLatitude,
      this.recipientLongitude,
      this.itemQty,
      this.itemWeight,
      this.routeId,
      this.orderNo,
      this.trackingNo,
      this.orderStatus,
      this.orderType,
      this.isPickedUp,
      this.pickupOrderStatus,
      this.pickupProofId,
      this.pickupSortId,
      this.displayOrderStatus,
      this.displayOrderType,
      this.displayMobileOrderType,
      this.displayMobileNo,
      this.pickupRouteId});

  TaskModel.copy(TaskModel from)
      : this(
          senderName: from.senderName,
          senderMobileNo: from.senderMobileNo,
          senderAddress: from.senderAddress,
          senderCity: from.senderCity,
          senderState: from.senderState,
          senderPostcode: from.senderPostcode,
          senderLatitude: from.senderLatitude,
          senderLongitude: from.senderLongitude,
          recipientName: from.recipientName,
          recipientMobileNo: from.recipientMobileNo,
          recipientAddress: from.recipientAddress,
          recipientCity: from.recipientCity,
          recipientState: from.recipientState,
          recipientPostcode: from.recipientPostcode,
          recipientLatitude: from.recipientLatitude,
          recipientLongitude: from.recipientLongitude,
          itemQty: from.itemQty,
          itemWeight: from.itemWeight,
          routeId: from.routeId,
          orderNo: from.orderNo,
          trackingNo: from.trackingNo,
          orderStatus: from.orderStatus,
          orderType: from.orderType,
          isPickedUp: from.isPickedUp,
          pickupOrderStatus: from.pickupOrderStatus,
          pickupProofId: from.pickupProofId,
          pickupSortId: from.pickupSortId,
          pickupRouteId: from.pickupRouteId,
          displayOrderType: from.displayOrderType,
          displayMobileOrderType: from.displayMobileOrderType,
          displayOrderStatus: from.displayOrderStatus,
          displayMobileNo: from.displayMobileNo,
        );

  Map<String, dynamic> toJson() => {
        "senderName": senderName,
        "senderMobileNo": senderMobileNo,
        "senderAddress": senderAddress,
        "senderCity": senderCity,
        "senderState": senderState,
        "senderPostcode": senderPostcode,
        "senderLatitude": senderLatitude,
        "senderLongitude": senderLongitude,
        "recipientName": recipientName,
        "recipientMobileNo": recipientMobileNo,
        "recipientAddress": recipientAddress,
        "recipientCity": recipientCity,
        "recipientState": recipientState,
        "recipientPostcode": recipientPostcode,
        "recipientLatitude": recipientLatitude,
        "recipientLongitude": recipientLongitude,
        "itemQty": itemQty,
        "itemWeight": itemWeight,
        "routeId": routeId,
        "orderNo": orderNo,
        "trackingNo": trackingNo,
        "orderStatus": orderStatus,
        "orderType": orderType,
        "isPickedUp": isPickedUp,
        "pickupOrderStatus": pickupOrderStatus,
        "pickupProofId": pickupProofId,
        "pickupSortId": pickupSortId,
        "pickupRouteId": pickupRouteId,
        "displayOrderStatus": displayOrderStatus,
        "displayMobileOrderType": displayMobileOrderType,
        "displayOrderType": displayOrderType,
        "displayMobileNo": displayMobileNo,
      };

  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
          senderName: json["senderName"],
          senderMobileNo: json["senderMobileNo"],
          senderAddress: json["senderAddress"],
          senderCity: json["senderCity"],
          senderState: json["senderState"],
          senderPostcode: json["senderPostcode"],
          senderLatitude: json["senderLatitude"],
          senderLongitude: json["senderLongitude"],
          recipientName: json["recipientName"],
          recipientMobileNo: json["recipientMobileNo"],
          recipientAddress: json["recipientAddress"],
          recipientCity: json["recipientCity"],
          recipientState: json["recipientState"],
          recipientPostcode: json["recipientPostcode"],
          recipientLatitude: json["recipientLatitude"],
          recipientLongitude: json["recipientLongitude"],
          itemQty: json["itemQty"],
          itemWeight: json["itemWeight"],
          routeId: json["routeId"],
          orderNo: json["orderNo"],
          trackingNo: json["trackingNo"],
          orderStatus: json["orderStatus"],
          orderType: json["orderType"],
          isPickedUp: FromJsonConverter.convertIntToBool(json["isPickedUp"]),
          pickupOrderStatus: json["pickupOrderStatus"],
          pickupProofId: json["pickupProofId"],
          pickupSortId: json["pickupSortId"],
          pickupRouteId: json["pickupRouteId"],
          displayMobileOrderType: json["displayMobileOrderType"],
          displayMobileNo: json["displayMobileNo"],
          displayOrderStatus: json["displayOrderStatus"],
          displayOrderType: json["displayOrderType"],
        );
}
