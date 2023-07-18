import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:ddroutes/model/i-response.dart';
import 'package:ddroutes/model/task-proof-model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestService {
  static final RestService instance = RestService.constructor();

  factory RestService() {
    return instance;
  }

  RestService.constructor();

  // static const String baseUrl = 'http://localhost:3000/ddroutes-modular';
  // static const String baseUrl = 'http://10.0.2.2:3000/ddroutes-modular/';
  // static const String baseUrl = 'http://192.168.1.11:3000/ddroutes-modular/';

  static const String baseUrl = 'https://ddroutes-modular.herokuapp.com/ddroutes-modular/';

  Future<IResponse> get(String endPoint) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String jwtToken = pref.getString("jwtToken") ?? null;
    String url = baseUrl + endPoint;

    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $jwtToken'});
    if (response.statusCode == 200) {
      return IResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load.');
    }
  }

  Future<IResponse> post(String endPoint, {dynamic data}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String jwtToken = pref.getString("jwtToken") ?? null;
    String url = baseUrl + endPoint;

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $jwtToken'
        },
        body: jsonEncode(data));
    return IResponse.fromJson(jsonDecode(response.body));
  }

  Future<IResponse> postDataWithImage(
      {String endPoint,
      File imageFile,
      dynamic file,
      TaskProofModel data}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String jwtToken = pref.getString("jwtToken") ?? null;
    String url = baseUrl + endPoint;
    var stream;
    var length;
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var multipartFile;

    if (file != null) {
      stream = ByteStream.fromBytes(file);
      multipartFile = new http.MultipartFile.fromBytes("file", file,
          filename: data.orderNo + ".png");
    } else {
      String baseName = basename(imageFile.path);
      String fileName = data.orderNo + "." + baseName.split('.')[1];
      stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      length = await imageFile.length();
      multipartFile =
          new http.MultipartFile("file", stream, length, filename: fileName);
    }

    request.files.add(multipartFile);
    request.fields['taskProof'] = json.encode(data);

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $jwtToken'
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return IResponse.fromJson(jsonDecode(response.body));
  }
}
