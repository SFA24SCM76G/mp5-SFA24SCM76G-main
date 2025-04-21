import 'dart:convert';

import 'package:battleships/models/game_detail_response.dart';
import 'package:battleships/models/games_model.dart';
import 'package:battleships/models/place_shot_response.dart';
import 'package:battleships/models/set_game_response.dart';
import 'package:http/http.dart' as http;

class APIHelper {
  String baseURL = 'https://battleships-app.onrender.com/';
  static String accesstoken = '';
  Map<String, String> get headers => {"Content-Type": "application/json"};
  Map<String, String> get headerswithAuth =>
      {"Content-Type": "application/json", "Authorization": 'Bearer $accesstoken'};

  Future<String> register(String username, String password) async {
    Map<String, String> body = {"username": username, "password": password};
    try {
      var response = await http.post(Uri.parse("$baseURL/register"), body: jsonEncode(body), headers: headers);
      var parsedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        accesstoken = parsedResponse['access_token'];
        return parsedResponse["message"];
      } else {
        throw parsedResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> login(String username, String password) async {
    Map<String, String> body = {"username": username, "password": password};
    try {
      var response = await http.post(Uri.parse("$baseURL/login"), body: jsonEncode(body), headers: headers);
      var parsedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        accesstoken = parsedResponse['access_token'];
        return parsedResponse["message"];
      } else {
        throw parsedResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GameModel> getAllGames() async {
    try {
      var response = await http.get(Uri.parse("$baseURL/games"), headers: headerswithAuth);
      if (response.statusCode == 200) {
        return GameModel.fromJson(response.body);
      } else {
        tokenExpire(response);
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SetGameResponse> setGame(List<String> ships, String ai) async {
    try {
      Map<String, dynamic> body = {"ships": ships};
      if (ai.isNotEmpty) body['ai'] = ai.toLowerCase();
      var response = await http.post(Uri.parse("$baseURL/games"), headers: headerswithAuth, body: jsonEncode(body));
      if (response.statusCode == 200) {
        return SetGameResponse.fromJson(response.body);
      } else {
        tokenExpire(response);
        throw jsonDecode(response.body)['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteGame(int gamerId) async {
    try {
      var response = await http.delete(Uri.parse("$baseURL/games/$gamerId"), headers: headerswithAuth);
      var parsedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return parsedResponse["message"];
      } else {
        tokenExpire(response);
        throw parsedResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PlaceShotResponse> placeShot(int gamerId, String shot) async {
    try {
      Map<String, String> body = {"shot": shot};
      var response =
          await http.put(Uri.parse("$baseURL/games/$gamerId"), body: jsonEncode(body), headers: headerswithAuth);
      var parsedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return PlaceShotResponse.fromMap(parsedResponse);
      } else {
        tokenExpire(response);
        throw parsedResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GameDetailsResponse> gameDetails(int gamerId) async {
    try {
      var response = await http.get(Uri.parse("$baseURL/games/$gamerId"), headers: headerswithAuth);
      if (response.statusCode == 200) {
        return GameDetailsResponse.fromJson(response.body);
      } else {
        tokenExpire(response);
        throw "${response.statusCode} ${response.reasonPhrase}";
      }
    } catch (e) {
      rethrow;
    }
  }

  tokenExpire(http.Response response) {
    try {
      if (response.reasonPhrase!.toLowerCase() == "unauthorized") {
        throw "We have situation. our session is expired.Please try relogin";
      }
    } catch (e) {
      rethrow;
    }
  }
}