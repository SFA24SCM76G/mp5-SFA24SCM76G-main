import 'package:battleships/helpers/alert_helper.dart';
import 'package:battleships/helpers/api_helper.dart';
import 'package:battleships/helpers/dialog_helper.dart';
import 'package:battleships/models/game_detail_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseViewModel extends ChangeNotifier {
  final apiHelper = APIHelper();
  final alerts = AlertHelper();
  final dialogs = DialogHelper();
  late SharedPreferences pref;
  List<String> options = ["Random", "Perfect","oneship"];
  static String username = "";
  static String aiOption = "";
  static int gamerId = 0;
  static GameDetailsResponse gameDetailsResponse = GameDetailsResponse.fromMap({});
}