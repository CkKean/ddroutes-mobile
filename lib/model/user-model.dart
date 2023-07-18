import 'package:ddroutes/shared/util/from-json-converter.dart';

class UserModel {
  int userType;
  String username;
  String fullName;
  String mobileNo;
  String email;
  String address;
  String city;
  String state;
  String postcode;
  String country;
  DateTime startDate;
  String position;
  String gender;
  String race;
  String religion;
  DateTime dob;
  String profileImg;
  String profileImgPath;

  UserModel({this.userType,
    this.username,
    this.fullName,
    this.address,
    this.mobileNo,
    this.email,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.startDate,
    this.position,
    this.gender,
    this.race,
    this.religion,
    this.dob,
    this.profileImg,
    this.profileImgPath});

  UserModel.copy(UserModel from)
      : this(
      userType: from.userType,
      username: from.username,
      fullName: from.fullName,
      mobileNo: from.mobileNo,
      email: from.email,
      city: from.city,
      address: from.address,
      state: from.state,
      postcode: from.postcode,
      country: from.country,
      startDate: from.startDate,
      position: from.position,
      gender: from.gender,
      race: from.race,
      religion: from.religion,
      dob: from.dob,
      profileImg: from.profileImg,
      profileImgPath: from.profileImgPath);

  UserModel.fromJson(json)
      : this(
      userType: json["userType"],
      username: json["username"],
      fullName: json["fullName"],
      mobileNo: json["mobileNo"],
      address: json["address"],
      email: json["email"],
      city: json["city"],
      state: json["state"],
      postcode: json["postcode"],
      country: json["country"],
      startDate:
      FromJsonConverter.convertStringToDateTime(json["startDate"]),
      position: json["position"],
      gender: json["gender"],
      race: json["race"],
      religion: json["religion"],
      dob: FromJsonConverter.convertStringToDateTime(json["dob"]),
      profileImg: json["profileImg"],
      profileImgPath: json["profileImgPath"]);

  Map<String, dynamic> toJson() =>
      {
        "userType": userType,
        "username": username,
        "fullName": fullName,
        "mobileNo": mobileNo,
        "email": email,
        "city": city,
        "postcode": postcode,
        "startDate": startDate,
        "position": position,
        "gender": gender,
        "race": race,
        "religion": religion,
        "dob": dob,
        "profileImg": profileImg,
        "profileImgPath": profileImgPath,
      };
}
