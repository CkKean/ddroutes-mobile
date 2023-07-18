import 'dart:io';

import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/model/order-route-model.dart';
import 'package:ddroutes/model/route-distance-duration-model.dart';
import 'package:ddroutes/model/task-proof-model.dart';
import 'package:ddroutes/service/rest-service.dart';

class TaskProofService {
  static final TaskProofService taskProofService =
      TaskProofService.constructor();

  factory TaskProofService() {
    return taskProofService;
  }

  TaskProofService.constructor();

  final rest = RestService();
  final endPoint = 'task-proof/';

  Future<List<OrderRouteModel>> getTasksList() async {
    final result = await rest.get(endPoint + 'find/tasks');

    if (result.success) {
      return (result.data as List)
          .map((itemJson) => OrderRouteModel.fromJson(itemJson))
          .toList();
    }
    throw result.message;
  }

  Future<IResponse> startRoute(
      {String routeId, int companyAddress, bool roundTrip}) async {
    var roundTripInInt;
    if (roundTrip) {
      roundTripInInt = 1;
    } else {
      roundTripInInt = 0;
    }
    print(roundTrip.toString());
    Map<String, String> queryParams = {
      "routeId": routeId,
      "companyAddress": companyAddress.toString(),
      "roundTrip": roundTripInInt.toString()
    };
    String queryString = Uri(queryParameters: queryParams).query;
    String requestUrl = endPoint + "start/route" + '?' + queryString;
    final result = await rest.get(requestUrl);
    return result;
  }

  Future<IResponse> createTaskProof({TaskProofModel taskProof}) async {
    final result = await rest.post(endPoint + 'create', data: taskProof);
    if (result.success) {
      return result;
    }
    return result;
  }

  Future<IResponse> createTaskProofWithImage(
      {String url, File imageFile, dynamic file, TaskProofModel data}) async {
    var response = await rest.postDataWithImage(
        endPoint: endPoint + url, imageFile: imageFile, data: data, file: file);
    return response;
  }

  Future<IResponse> getDistanceTime(
      {RouteDistanceDurationModel routeDistanceDuration}) async {
    final result =
        await rest.post(endPoint + 'duration', data: routeDistanceDuration);
    if (result.success) return result;
    return null;
  }
}

final taskProofService = TaskProofService();
