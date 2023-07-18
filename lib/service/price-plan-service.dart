import 'dart:developer';

import 'package:ddroutes/model/price-plan-model.dart';
import 'package:ddroutes/service/rest-service.dart';

class PricePlanService {
  static final PricePlanService pricePlanService =
      PricePlanService.constructor();

  factory PricePlanService() {
    return pricePlanService;
  }

  PricePlanService.constructor();

  final rest = RestService();
  final endPoint = 'price-plan/';

  Future<List<PricePlanModel>> getPricePlan() async {
    final result = await rest.get(endPoint + 'find-all');

    if (result.success) {
      return (result.data as List)
          .map((itemJson) => PricePlanModel.fromJson(itemJson))
          .toList();
    }
    log('Data: ${result.message}');
    throw result.message;
  }
}

final pricePlanService = PricePlanService();
