import 'package:ddroutes/model/shipping-order-model.dart';

class FilterShippingOrderModel {
  List<ShippingOrderModel> allOrder;
  List<ShippingOrderModel> completedList;
  List<ShippingOrderModel> inProgressList;
  List<ShippingOrderModel> failedList;
  List<ShippingOrderModel> pendingList;
  List<ShippingOrderModel> pickedUpList;

  FilterShippingOrderModel(
      {this.allOrder,
      this.completedList,
      this.inProgressList,
      this.failedList,
      this.pendingList,
      this.pickedUpList});

  FilterShippingOrderModel.fromJson(json)
      : this(
          allOrder: json['allOrder']
              .map<ShippingOrderModel>(
                  (order) => ShippingOrderModel.fromJson(order))
              .toList(),
          completedList: json['completedList']
              .map<ShippingOrderModel>(
                  (order) => ShippingOrderModel.fromJson(order))
              .toList(),
          inProgressList: json['inProgressList']
              .map<ShippingOrderModel>(
                  (order) => ShippingOrderModel.fromJson(order))
              .toList(),
          failedList: json['failedList']
              .map<ShippingOrderModel>(
                  (order) => ShippingOrderModel.fromJson(order))
              .toList(),
          pendingList: json['pendingList']
              .map<ShippingOrderModel>(
                  (order) => ShippingOrderModel.fromJson(order))
              .toList(),
          pickedUpList: json['pickedUpList']
              .map<ShippingOrderModel>(
                  (order) => ShippingOrderModel.fromJson(order))
              .toList(),
        );
}
