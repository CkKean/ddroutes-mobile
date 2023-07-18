import 'dart:developer';

import 'package:ddroutes/model/tracking-model.dart';
import 'package:ddroutes/service/rest-service.dart';

class TrackingService {
  static final TrackingService trackingService = TrackingService.constructor();

  factory TrackingService() {
    return trackingService;
  }

  TrackingService.constructor();

  final rest = RestService();
  final endPoint = "tracking/";

  Future<TrackingModel> getShippingOrderStatus(String orderNo) async {
    Map<String, String> queryParams = {"trackingOrderNo": orderNo};
    String queryString = Uri(queryParameters: queryParams).query;

    var requestUrl = endPoint + "find" + '?' + queryString; // result
    final result = await rest.get(requestUrl);
    if (result.success) {
      return TrackingModel.fromJson(result.data);
    }
    log('Data: ${result.message}');
    throw result.message;
  }
}

final trackingService = TrackingService();
