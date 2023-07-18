import 'package:ddroutes/shared/util/from-json-converter.dart';

class ShippingOrderModel {
  String orderNo;
  String orderType;
  String orderStatus;
  String trackingNo;

  String senderName;
  String senderMobileNo;
  String senderEmail;
  String senderAddress;
  String senderCity;
  String senderState;
  String senderPostcode;
  String fullSenderAddress;

  String recipientName;
  String recipientMobileNo;
  String recipientEmail;
  String recipientAddress;
  String recipientCity;
  String recipientState;
  String recipientPostcode;
  String recipientLatitude;
  String recipientLongitude;
  String recipientFormattedAddress;
  String fullRecipientAddress;

  int itemQty;
  String itemType;
  double itemWeight;

  String paymentMethod;
  String vehicleType;
  double shippingCost;

  String proofId;
  String routeId;
  int sortId;

  bool isPickedUp;
  String pickupOrderStatus;
  String pickupProofId;
  int pickupSortId;
  String pickupRouteId;

  String createdBy;
  DateTime createdAt;
  String updatedBy;
  DateTime updatedAt;
  bool sameAsRegisteredInfo;

  ShippingOrderModel(
      {this.orderNo,
      this.orderType,
      this.orderStatus,
      this.trackingNo,
      this.senderName,
      this.senderMobileNo,
      this.senderEmail,
      this.senderAddress,
      this.senderCity,
      this.senderState,
      this.senderPostcode,
      this.fullSenderAddress,
      this.recipientName,
      this.recipientMobileNo,
      this.recipientEmail,
      this.recipientAddress,
      this.recipientCity,
      this.recipientState,
      this.recipientPostcode,
      this.recipientLatitude,
      this.recipientLongitude,
      this.recipientFormattedAddress,
      this.fullRecipientAddress,
      this.itemQty,
      this.itemType,
      this.itemWeight,
      this.paymentMethod,
      this.vehicleType,
      this.shippingCost,
      this.proofId,
      this.routeId,
      this.sortId,
      this.createdBy,
      this.createdAt,
      this.isPickedUp,
      this.pickupOrderStatus,
      this.pickupProofId,
      this.pickupSortId,
      this.pickupRouteId,
      this.sameAsRegisteredInfo});

  ShippingOrderModel.copy(ShippingOrderModel from)
      : this(
            orderNo: from.orderNo,
            orderType: from.orderType,
            orderStatus: from.orderStatus,
            trackingNo: from.trackingNo,
            senderName: from.senderName,
            senderMobileNo: from.senderMobileNo,
            senderEmail: from.senderEmail,
            senderAddress: from.senderAddress,
            senderCity: from.senderCity,
            senderState: from.senderState,
            senderPostcode: from.senderPostcode,
            fullSenderAddress: from.fullSenderAddress,
            recipientName: from.recipientName,
            recipientMobileNo: from.recipientMobileNo,
            recipientEmail: from.recipientEmail,
            recipientAddress: from.recipientAddress,
            fullRecipientAddress: from.fullRecipientAddress,
            recipientCity: from.recipientCity,
            recipientState: from.recipientState,
            recipientPostcode: from.recipientPostcode,
            recipientLatitude: from.recipientLatitude,
            recipientLongitude: from.recipientLongitude,
            recipientFormattedAddress: from.recipientFormattedAddress,
            itemQty: from.itemQty,
            itemType: from.itemType,
            itemWeight: from.itemWeight,
            paymentMethod: from.paymentMethod,
            vehicleType: from.vehicleType,
            shippingCost: from.shippingCost,
            proofId: from.proofId,
            routeId: from.routeId,
            sortId: from.sortId,
            isPickedUp: from.isPickedUp,
            pickupOrderStatus: from.pickupOrderStatus,
            pickupProofId: from.pickupProofId,
            pickupSortId: from.pickupSortId,
            pickupRouteId: from.pickupRouteId,
            createdBy: from.createdBy,
            createdAt: from.createdAt,
            sameAsRegisteredInfo: from.sameAsRegisteredInfo);

  ShippingOrderModel.fromJson(json)
      : this(
            orderNo: json["orderNo"],
            orderType: json["orderType"],
            orderStatus: json["orderStatus"],
            trackingNo: json["trackingNo"],
            senderName: json["senderName"],
            senderMobileNo: json["senderMobileNo"],
            senderEmail: json["senderEmail"],
            senderAddress: json["senderAddress"],
            senderCity: json["senderCity"],
            senderState: json["senderState"],
            senderPostcode: json["senderPostcode"],
            recipientName: json["recipientName"],
            recipientMobileNo: json["recipientMobileNo"],
            recipientEmail: json["recipientEmail"],
            recipientAddress: json["recipientAddress"],
            recipientCity: json["recipientCity"],
            recipientState: json["recipientState"],
            recipientPostcode: json["recipientPostcode"],
            recipientLatitude: json["recipientLatitude"],
            recipientLongitude: json["recipientLongitude"],
            recipientFormattedAddress: json["recipientFormattedAddress"],
            itemQty: json["itemQty"],
            itemType: json["itemType"],
            itemWeight:
                FromJsonConverter.convertStringToDouble(json["itemWeight"]),
            paymentMethod: json["paymentMethod"],
            vehicleType: json["vehicleType"],
            shippingCost:
                FromJsonConverter.convertStringToDouble(json["shippingCost"]),
            proofId: json["proofId"],
            routeId: json["routeId"],
            sortId: json["sortId"],
            isPickedUp: FromJsonConverter.convertIntToBool(json["isPickedUp"]),
            pickupOrderStatus: json["pickupOrderStatus"],
            pickupProofId: json["pickupProofId"],
            pickupSortId: json["pickupSortId"],
            pickupRouteId: json["pickupRouteId"],
            createdBy: json["createdBy"],
            createdAt: FromJsonConverter.convertStringToDateTime(
                json["createdAt"].toString()));

  Map<String, dynamic> toJson() => {
        "orderNo": orderNo,
        "orderType": orderType,
        "orderStatus": orderStatus,
        "trackingNo": trackingNo,
        "senderName": senderName,
        "senderMobileNo": senderMobileNo,
        "senderEmail": senderEmail.isNotEmpty ? senderEmail : null,
        "senderAddress": senderAddress,
        "senderCity": senderCity,
        "senderState": senderState,
        "senderPostcode": senderPostcode,
        "fullSenderAddress": fullSenderAddress,
        "recipientName": recipientName,
        "recipientMobileNo": recipientMobileNo,
        "recipientEmail": recipientEmail.isNotEmpty ? recipientEmail : null,
        "recipientAddress": recipientAddress,
        "recipientCity": recipientCity,
        "recipientState": recipientState,
        "recipientPostcode": recipientPostcode,
        "recipientLatitude": recipientLatitude,
        "recipientLongitude": recipientLongitude,
        "recipientFormattedAddress": recipientFormattedAddress,
        "fullRecipientAddress": fullRecipientAddress,
        "itemQty": itemQty,
        "itemType": itemType,
        "itemWeight": itemWeight,
        "paymentMethod": paymentMethod,
        "vehicleType": vehicleType,
        "shippingCost": shippingCost,
        "proofId": proofId,
        "routeId": routeId,
        "sortId": sortId,
        "isPickedUp": isPickedUp,
        "pickupOrderStatus": pickupOrderStatus,
        "pickupProofId": pickupProofId,
        "pickupSortId": pickupSortId,
        "pickupRouteId": pickupRouteId,
        "createdBy": createdBy,
        "createdAt": createdAt
      };
}
