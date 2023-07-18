import 'package:ddroutes/model/filter-shippng-order-model.dart';
import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/model/shipping-order-model.dart';
import 'package:ddroutes/model/user-model.dart';
import 'package:ddroutes/service/rest-service.dart';

class ShippingOrderService {
  static final ShippingOrderService shippingOrderService =
      ShippingOrderService.constructor();

  factory ShippingOrderService() {
    return shippingOrderService;
  }

  ShippingOrderService.constructor();

  final rest = RestService();
  final endPoint = "shipping-order/";

  Future<FilterShippingOrderModel> getShippingOrderList() async {
    final result = await rest.get(endPoint + "find-all");
    if (result.success) {
      return FilterShippingOrderModel.fromJson(result.data);
    }
    throw result.message;
  }

  Future<List<ShippingOrderModel>> getShippingOrderStatus() async {
    final result = await rest.get(endPoint + "find-all");
    if (result.success) {
      return (result.data as List)
          .map((itemJson) => ShippingOrderModel.fromJson(itemJson))
          .toList();
    }
    throw result.message;
  }

  Future<List<String>> getVehicleList() async {
    final result = await rest.get(endPoint + "type");
    if (result.success) {
      return List<String>.from(result.data.map((x) => x));
    }
    throw result.message;
  }

  Future<dynamic> getShippingCost(
      {ShippingOrderModel shippingOrderModel}) async {
    final result =
        await rest.post(endPoint + "shipping-cost", data: shippingOrderModel);
    if (result.success) {
      return result.data;
    }
    throw result.message;
  }

  Future<UserModel> getUserInfo() async {
    final result = await rest.get(endPoint + "find/user");
    if (result.success) {
      return UserModel.fromJson(result.data);
    }
    throw result.message;
  }

  Future<IResponse> createShippingOrder(
      {ShippingOrderModel shippingOrderModel}) async {
    final result =
        await rest.post(endPoint + 'create', data: shippingOrderModel);

    return result;
  }
}

final shippingOrderService = ShippingOrderService();
