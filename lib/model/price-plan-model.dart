import 'package:ddroutes/shared/util/from-json-converter.dart';

class PricePlanModel {
  String pricePlanId;
  String vehicleType;
  String defaultWeightPrefix;
  double defaultWeight;
  String defaultWeightUnit;
  String defaultDistancePrefix;
  double defaultDistance;
  String defaultDistanceUnit;
  double defaultPricing;
  double subDistance;
  double subDistancePricing;
  String subDistanceUnit;
  double subWeight;
  double subWeightPricing;
  String subWeightUnit;

  PricePlanModel(
      {this.pricePlanId,
      this.vehicleType,
      this.defaultWeightPrefix,
      this.defaultWeight,
      this.defaultWeightUnit,
      this.defaultDistancePrefix,
      this.defaultDistance,
      this.defaultDistanceUnit,
      this.defaultPricing,
      this.subDistance,
      this.subDistancePricing,
      this.subDistanceUnit,
      this.subWeight,
      this.subWeightPricing,
      this.subWeightUnit});

  PricePlanModel.copy(PricePlanModel from)
      : this(
            pricePlanId: from.pricePlanId,
            vehicleType: from.vehicleType,
            defaultWeightPrefix: from.defaultWeightPrefix,
            defaultWeight: from.defaultWeight,
            defaultWeightUnit: from.defaultWeightUnit,
            defaultDistancePrefix: from.defaultDistancePrefix,
            defaultDistance: from.defaultDistance,
            defaultDistanceUnit: from.defaultDistanceUnit,
            defaultPricing: from.defaultPricing,
            subDistance: from.subDistance,
            subDistancePricing: from.subDistancePricing,
            subDistanceUnit: from.subDistanceUnit,
            subWeight: from.subWeight,
            subWeightPricing: from.subWeightPricing,
            subWeightUnit: from.subWeightUnit);

  Map<String, dynamic> toJson() => {
        "pricePlanId": pricePlanId,
        "vehicleType": vehicleType,
        "defaultWeightPrefix": defaultWeightPrefix,
        "defaultWeight": defaultWeight,
        "defaultWeightUnit": defaultWeightUnit,
        "defaultDistancePrefix": defaultDistancePrefix,
        "defaultDistance": defaultDistance,
        "defaultDistanceUnit": defaultDistanceUnit,
        "defaultPricing": defaultPricing,
        "subDistance": subDistance,
        "subDistancePricing": subDistancePricing,
        "subDistanceUnit": subDistanceUnit,
        "subWeight": subWeight,
        "subWeightPricing": subWeightPricing,
        "subWeightUnit": subWeightUnit
      };

  PricePlanModel.fromJson(Map<String, dynamic> json)
      : this(
            pricePlanId: json["pricePlanId"],
            vehicleType: json["vehicleType"],
            defaultWeightPrefix: json["defaultWeightPrefix"],
            defaultWeight:
                FromJsonConverter.convertStringToDouble(json["defaultWeight"]),
            defaultWeightUnit: json["defaultWeightUnit"],
            defaultDistancePrefix: json["defaultDistancePrefix"],
            defaultDistance: FromJsonConverter.convertStringToDouble(
                json["defaultDistance"]),
            defaultDistanceUnit: json["defaultDistanceUnit"],
            defaultPricing:
                FromJsonConverter.convertStringToDouble(json["defaultPricing"]),
            subDistance:
                FromJsonConverter.convertStringToDouble(json["subDistance"]),
            subDistancePricing: FromJsonConverter.convertStringToDouble(
                json["subDistancePricing"]),
            subDistanceUnit: json["subDistanceUnit"],
            subWeight:
                FromJsonConverter.convertStringToDouble(json["subWeight"]),
            subWeightPricing: FromJsonConverter.convertStringToDouble(
                json["subWeightPricing"]),
            subWeightUnit: json["subWeightUnit"]);
}
