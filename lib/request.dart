import 'package:casa/structs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

class Request {
  static final Request _singleton = new Request._internal();
  SharedPreferences prefs;
  String token;
  String apiUrl = 'http://192.168.1.46:3000';

  factory Request() {
    return _singleton;
  }

  Future<String> init() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Request._internal();

  Future<dynamic> updateUserPassword(String userId, body) async {
    var response = await http.put(
      apiUrl + '/v1/users/' + userId + '/password',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
      body: body
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> updateUserEmail(String userId, body) async {
    var response = await http.put(
      apiUrl + '/v1/users/' + userId + '/email',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
      body: body
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> updateUserProfil(String userId, body) async {
    var response = await http.put(
      apiUrl + '/v1/users/' + userId,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
      body: body
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<User> getUser(String userId) async {
    if (userId == '') {
      userId = 'me';
    }
    var response = await http.get(
      apiUrl + '/v1/users/' + userId,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    var _user = User(parsedJson);
    return _user;
  }

  Future<dynamic> editHomeMember(String homeId, String userId, body) async {
    var response = await http.put(
      apiUrl + '/v1/homes/' + homeId + '/members/' + userId,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
      body: body
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> removeHomeMember(String homeId, String userId) async {
    var response = await http.delete(
      apiUrl + '/v1/homes/' + homeId + '/members/' + userId,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> addHomeMember(String homeId, body) async {
    var response = await http.post(
      apiUrl + '/v1/homes/' + homeId + '/members',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
      body: body
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 201) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> getHomeMembers(String homeId) async {
    var response = await http.get(
      apiUrl + '/v1/homes/' + homeId + '/members',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token}
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> getRooms(String homeId) async {
    var response = await http.get(
      apiUrl + '/v1/homes/' + homeId + '/rooms',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token}
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> addRoom(String homeId, body) async {
    var response = await http.post(
      apiUrl + '/v1/homes/' + homeId + '/rooms',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
      body: body
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 201) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> getHome(String homeId) async {
    var response = await http.get(
      apiUrl + '/v1/homes/' + homeId,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> getHomes() async {
    var response = await http.get(
      apiUrl + '/v1/homes',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> editHome(String homeId, body) async {
    var response = await http.put(
      apiUrl + '/v1/homes/' + homeId,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
      body: body
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> addHome(body) async {
    var response = await http.post(
      apiUrl + '/v1/homes',
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
      body: body
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 201) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> deleteHome(String homeId) async {
    var response = await http.delete(
      apiUrl + '/v1/homes/' + homeId,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token}
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }

  Future<dynamic> signin(String email, String password) async {
    var response = await http.post(
      apiUrl + '/v1/signin',
      body: {'email': email, 'password': password}
    );
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      throw(parsedJson['error']);
    }
    return parsedJson;
  }
}