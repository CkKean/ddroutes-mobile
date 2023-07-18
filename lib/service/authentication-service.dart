import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/service/rest-service.dart';

class AuthenticationService {
  static final AuthenticationService authenticationService =
      AuthenticationService.constructor();

  factory AuthenticationService() {
    return authenticationService;
  }

  AuthenticationService.constructor();

  final rest = RestService();
  final endPoint = 'auth/';

  Future<IResponse> signIn(String username, String password) async {
    final user = {"username": username, "password": password};

    return await rest.post(endPoint + 'mobile/signin',
        data: user);
  }
}

final authenticationService = AuthenticationService();
