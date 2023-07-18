class IResponse {
  bool success;
  String message;
  dynamic data;
  int errorCode;

  IResponse({this.success, this.message, this.data, this.errorCode});

  IResponse.copy(IResponse from)
      : this(
            success: from.success,
            message: from.message,
            data: from.data,
            errorCode: from.errorCode);

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
        "errorCode": errorCode
      };

  IResponse.fromJson(Map<String, dynamic> json)
      : this(
            success: json["success"],
            message: json["message"],
            data: json["data"],
            errorCode: json["errorCode"]);
}
