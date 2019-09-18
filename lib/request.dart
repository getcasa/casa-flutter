import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

class Request {
  SharedPreferences prefs;
  String token;
  String apiUrl = 'http://192.168.1.46:3000';

  Request() {
    SharedPreferences.getInstance().then((_prefs) {
      prefs = _prefs;

      token = prefs.getString('token');
    });
  }

  Future<dynamic> getHomes() async {
    var response = await http.get(
      apiUrl + '/v1/homes',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
    );
    var parsedJson = json.decode(response.body);
    return parsedJson;
  }

  Future<dynamic> addHome(body) async {
    var response = await http.post(
      apiUrl + '/v1/homes',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
      body: body
    );
    var parsedJson = json.decode(response.body);
    return parsedJson;
  }

  Future<dynamic> signin(String email, String password) async {
    var response = await http.post(
      apiUrl + '/v1/signin',
      body: {'email': email, 'password': password}
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['message']);
    }
    return parsedJson;
  }
}