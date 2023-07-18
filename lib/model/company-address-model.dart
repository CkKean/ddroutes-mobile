import 'package:ddroutes/shared/util/from-json-converter.dart';

class CompanyAddressModel {
  int id;
  String address;
  String city;
  String state;
  String postcode;
  double latitude;
  double longitude;
  String formattedAddress;

  CompanyAddressModel({
    this.id,
    this.address,
    this.city,
    this.state,
    this.postcode,
    this.latitude,
    this.longitude,
    this.formattedAddress,
  });

  CompanyAddressModel.fromJson(json)
      : this(
          id: json["id"],
          address: json["address"],
          city: json["city"],
          state: json["state"],
          postcode: json["postcode"],
          latitude: FromJsonConverter.convertStringToDouble(json["latitude"]),
          longitude: FromJsonConverter.convertStringToDouble(json["longitude"]),
          formattedAddress: json["formattedAddress"],
        );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "city": city,
        "state": state,
        "postcode": postcode,
        "latitude": latitude,
        "longitude": longitude,
        "formattedAddress": formattedAddress,
      };
}
