import 'package:ddroutes/model/company-address-model.dart';
import 'package:ddroutes/model/task-model.dart';

class RouteDistanceDurationModel {
  List<TaskModel> orderList;
  CompanyAddressModel companyAddress;
  bool roundTrip;

  RouteDistanceDurationModel({
    this.companyAddress,
    this.roundTrip,
    this.orderList,
  });

  RouteDistanceDurationModel.copy(TaskModel from) : this();

  Map<String, dynamic> toJson() => {
        "companyAddress": companyAddress.toJson(),
        "roundTrip": roundTrip,
        "orderList": orderList.map((e) => e.toJson()).toList(),
      };

  RouteDistanceDurationModel.fromJson(Map<String, dynamic> json) : this();
}
