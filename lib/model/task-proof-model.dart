class TaskProofModel {
  String status;
  String reason;
  DateTime arrivedAt;
  String recipientName;
  String recipientIcNo;
  String orderNo;
  String trackingNo;
  String routeId;

  TaskProofModel({this.status,
    this.reason,
    this.arrivedAt,
    this.recipientName,
    this.recipientIcNo,
    this.orderNo,
    this.trackingNo,
    this.routeId});

  TaskProofModel.copy(TaskProofModel from)
      : this(
    status: from.status,
    reason: from.reason,
    arrivedAt: from.arrivedAt,
    recipientName: from.recipientName,
    recipientIcNo: from.recipientIcNo,
    orderNo: from.orderNo,
    trackingNo: from.trackingNo,
    routeId: from.routeId,
  );

  TaskProofModel.fromJson(json)
      : this(
    status: json["status"],
    reason: json["reason"],
    arrivedAt: json["arrivedAt"],
    recipientName: json["recipientName"],
    recipientIcNo: json["recipientIcNo"],
    orderNo: json["orderNo"],
    trackingNo: json["trackingNo"],
    routeId: json["routeId"],
  );

  Map<String, dynamic> toJson() =>
      {
        "status": status,
        "reason": reason,
        "arrivedAt": arrivedAt != null ? arrivedAt.toIso8601String() : null,
        "recipientName": recipientName,
        "recipientIcNo": recipientIcNo,
        "orderNo": orderNo,
        "trackingNo": trackingNo,
        "routeId": routeId
      };
}
