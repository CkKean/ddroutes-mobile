
import 'package:ddroutes/service/rest-service.dart';

class PublicService {
  static final PublicService publicService = PublicService.constructor();

  factory PublicService() {
    return publicService;
  }

  PublicService.constructor();

  final rest = RestService();
  final endPoint = 'task-proof/';

// Future<List<TaskModel>> getProfileImage() async {
//   final result = await rest.get(endPoint + 'find/tasks');
//
//   if (result.success) {
//     return (result.data as List)
//         .map((itemJson) => TaskModel.fromJson(itemJson))
//         .toList();
//   }
//   log('Data: ${result.message}');
//   throw result.message;
// }
}

final publicService = PublicService();
