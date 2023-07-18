
import 'package:ddroutes/model/user-model.dart';
import 'package:ddroutes/service/rest-service.dart';

class UserService {
  static final UserService userService = UserService.constructor();

  factory UserService() {
    return userService;
  }

  UserService.constructor();

  final rest = RestService();
  final endPoint = "user/";

  Future<UserModel> getUserInfo() async {
    final result = await rest.get(endPoint + "find/user");
    if (result.success) {
      return UserModel.fromJson(result.data);
    }
    throw result.message;
  }
}

final userService = UserService();
