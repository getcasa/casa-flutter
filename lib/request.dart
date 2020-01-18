import 'dart:async';

import 'package:casa/structs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

class Request {
  static final Request _singleton = new Request._internal();
  SharedPreferences prefs;
  List<String> tokens;
  List<String> ips;
  int selectedEnv;

  factory Request() {
    return _singleton;
  }

  Future<Null> init() async {
    prefs = await SharedPreferences.getInstance();
    tokens = prefs.getStringList('tokens') != null ? prefs.getStringList('tokens') : [];
    ips = prefs.getStringList('ips') != null ? prefs.getStringList('ips') : [];
    selectedEnv = prefs.getInt('selectedEnv') != null ? prefs.getInt('selectedEnv') : 0;

    return;
  }

  Request._internal();

  Future<dynamic> editAutomation(String homeId, String automationId, dynamic body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/automations/' + automationId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> editDevice(String homeId, String roomId, String deviceId, dynamic body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/devices/' + deviceId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> deleteAutomation(String homeId, String automationId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.delete(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/automations/' + automationId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]
        }
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

    Future<dynamic> deleteDevice(String homeId, String roomId, String deviceId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.delete(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/devices/' + deviceId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]
        }
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> addAutomation(String homeId, dynamic body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.post(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/automations',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 201) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getAutomations(String homeId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/automations',
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> callAction(String homeId, String roomId, String deviceId, dynamic body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.post(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/devices/' + deviceId + '/actions',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> addDevice(String homeId, String roomId, dynamic body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.post(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/devices',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 201) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getDiscoveredDevices(String homeId, String pluginName) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/gateways/discover/' + pluginName,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getDeviceDatas(String homeId, String roomId, String deviceId, String field) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/devices/' + deviceId + '/datas?field=' + field,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getAvailablePlugins(String homeId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/plugins',
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getDevices(String homeId, String roomId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/devices',
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> deleteRoom(String homeId, String roomId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.delete(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> editRoom(String homeId, String roomId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> editRoomMember(String homeId, String roomId, String userId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/members/' + userId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getRoomMembers(String homeId, String roomId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/members',
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> editDeviceMember(String homeId, String roomId, String userId, String deviceId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/devices/' + deviceId + '/members/' + userId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getDeviceMembers(String homeId, String roomId, String deviceId) async {
    var completer = new Completer();
    var response;

    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms/' + roomId + '/devices/' + deviceId + '/members',
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) { 
      completer.completeError(e);
      return completer.future;
    }
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> updateUserPassword(String userId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/users/' + userId + '/password',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> updateUserEmail(String userId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/users/' + userId + '/email',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> updateUserProfil(String userId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/users/' + userId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getUser(String userId) async {
    var completer = new Completer();
    if (userId == '') {
      userId = 'me';
    }
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/users/' + userId,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]},
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }
    var _user = User(parsedJson);
    completer.complete(_user);
    return completer.future;
  }

  Future<dynamic> editHomeMember(String homeId, String userId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/members/' + userId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> removeHomeMember(String homeId, String userId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.delete(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/members/' + userId,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]},
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> addHomeMember(String homeId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.post(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/members',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 201) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getHomeMembers(String homeId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/members',
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getRooms(String homeId) async {

    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms',
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> addRoom(String homeId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.post(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId + '/rooms',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 201) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getHome(String homeId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]},
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> getHomes() async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/v1/homes',
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]},
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> editHome(String homeId, body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.put(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> addHome(body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.post(
        'http://' + ips[selectedEnv] + '/v1/homes',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv],
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 201) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> deleteHome(String homeId) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.delete(
        'http://' + ips[selectedEnv] + '/v1/homes/' + homeId,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> signout() async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.post(
        'http://' + ips[selectedEnv] + '/v1/signout',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer '+tokens[selectedEnv]
        },
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    tokens[selectedEnv] = "";
    await prefs.setStringList('tokens', tokens);

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> signup(body) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.post(
        'http://' + ips[selectedEnv] + '/v1/signup',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(body)
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }
    
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 201) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> signin(String email, String password) async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.post(
        'http://' + ips[selectedEnv] + '/v1/signin',
        body: {'email': email, 'password': password}
      );
    } catch (e) {
      completer.completeError(e);
      return completer.future;
    }
    
    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }

  Future<dynamic> checkServer() async {
    var completer = new Completer();
    var response;
  
    try {
      response = await http.get(
        'http://' + ips[selectedEnv] + '/casa'
      );
    } catch (err) {
      completer.completeError(err);
      return completer.future;
    }

    var parsedJson = json.decode(response.body);
    if (response.statusCode != 200) {
      completer.completeError(parsedJson['message']);
      return completer.future;
    }

    completer.complete(parsedJson);
    return completer.future;
  }
}