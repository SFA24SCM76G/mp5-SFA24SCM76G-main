// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:battleships/helpers/api_helper.dart';
import 'package:battleships/main.dart';
import 'package:battleships/view_models/base_viewmodel.dart';
import 'package:battleships/views/home_screen.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends BaseViewModel {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool startUp = false;

  void startupInitialization() async {
    await loadAccessToken();
    Future.delayed(const Duration(seconds: 2), () {
      if (APIHelper.accesstoken.isNotEmpty) {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const Homescreen()));
      } else {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  void register() async {
    try {
      startUp = true;
      if (textValidations()) {
        dialogs.loader("Getting everything ready!");
        String response = await apiHelper.register(username.text, password.text);
        alerts.showSuccessAlert(response);
        await saveLocal();
        BaseViewModel.username = username.text;
        dialogs.closeLoader();
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const Homescreen()));
      }
    } catch (e) {
      alerts.showErrorAlert(e.toString());
      dialogs.closeLoader();

    }
    notifyListeners();
  }

  void login() async {
    try {
      startUp = true;
      if (textValidations()) {
        dialogs.loader("Getting everything ready!");
        String response = await apiHelper.login(username.text, password.text);
        alerts.showSuccessAlert(response);
        await saveLocal();
        BaseViewModel.username = username.text;
        dialogs.closeLoader();
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const Homescreen()));
      }
    } catch (e) {
      alerts.showErrorAlert(e.toString());
    }
    notifyListeners();
  }

  Future<void> saveLocal() async {
    pref = await SharedPreferences.getInstance();
    await pref.setString('access_token', APIHelper.accesstoken);
    await pref.setString('username', username.text);
    await pref.setString('password', password.text);
  }

  Future<void> loadAccessToken() async {
    pref = await SharedPreferences.getInstance();
    APIHelper.accesstoken = pref.getString('access_token') ?? "";
    BaseViewModel.username = pref.getString('username') ?? "";
  }

  bool textValidations() {
    try {
      if (startUp) {
        if (username.text.isEmpty) {
          // alerts.showErrorAlert("Please enter username");
          return false;
        }
        if (password.text.isEmpty) {
          // alerts.showErrorAlert("Please enter password");
          return false;
        }
        if (username.text.length < 2) {
          // alerts.showErrorAlert("Please enter little bigger username");
          return false;
        }
        if (password.text.length < 2) {
          // alerts.showErrorAlert("Please enter little bigger password");
          return false;
        }
      }
    } catch (e) {
      // rethrow;
    }
    return true;
  }
}