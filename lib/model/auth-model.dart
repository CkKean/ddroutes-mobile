import 'package:ddroutes/shared/util/from-json-converter.dart';

class AuthModel {
  String username;
  String fullname;
  int userType;
  String position;
  String jwtToken;
  String profileImg;
  String profileImgPath;
  int expiresIn;
  DateTime startDate;

  AuthModel({
    this.username,
    this.fullname,
    this.userType,
    this.position,
    this.jwtToken,
    this.expiresIn,
    this.startDate,
    this.profileImg,
    this.profileImgPath,
  });

  AuthModel.copy(AuthModel from)
      : this(
          username: from.username,
          fullname: from.fullname,
          userType: from.userType,
          position: from.position,
          jwtToken: from.jwtToken,
          expiresIn: from.expiresIn,
          startDate: from.startDate,
          profileImg: from.profileImg,
          profileImgPath: from.profileImgPath,
        );

  Map<String, dynamic> toJson() => {
        "username": username,
        "fullname": fullname,
        "userType": userType,
        "position": position,
        "jwtToken": jwtToken,
        "expiresIn": expiresIn,
        "startDate": startDate,
        "profileImg": profileImg,
        "profileImgPath": profileImgPath,
      };

  AuthModel.fromJson(json)
      : this(
            username: json["username"],
            fullname: json["fullname"],
            userType: json["userType"],
            position: json["position"],
            jwtToken: json["jwtToken"],
            expiresIn: json["expiresIn"],
            profileImg: json["profileImg"],
            profileImgPath: json["profileImgPath"],
            startDate:
                FromJsonConverter.convertStringToDateTime(json["startDate"]));
}
