// ignore_for_file: use_build_context_synchronously

import 'package:battleships/main.dart';
import 'package:battleships/models/games_model.dart';
import 'package:battleships/view_models/base_viewmodel.dart';
import 'package:battleships/views/game_screen.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends BaseViewModel {
  GameModel gameModel = GameModel.fromMap({"games": []});
  List<Game> completedGames = [], activeGames = [];
  bool showHistory = false;

  void newGame() {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const GameScreen(isNewGame: true)));
  }

  void newGamewithAI(bool mounted) async {
    try {
      String option = await dialogs.pickAIType(options) ?? "";
      if (option.isNotEmpty && mounted) {
        BaseViewModel.aiOption = option;
        Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const GameScreen(isNewGame: true)));
      }
    } catch (e) {
      alerts.showErrorAlert(e.toString());
    }
  }

  void logout() async {
    pref = await SharedPreferences.getInstance();
    pref.remove("access_token");
    pref.remove("username");
    pref.remove("password");
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
  }

  void showGameStatus(index) async {
    try {
      BaseViewModel.gameDetailsResponse = await apiHelper.gameDetails(gameModel.games[index].id);
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const GameScreen(isNewGame: false)));
    } catch (e) {
      alerts.showErrorAlert(e.toString());
    }
  }

  Future<void> showCompletedGames() async {
    try {
      dialogs.loader("Updating your battlefields status");
      gameModel = await apiHelper.getAllGames();
      completedGames = gameModel.games.where((element) => element.status == 1 || element.status == 2).toList();
      activeGames = gameModel.games.where((element) => element.status == 0 || element.status == 3).toList();
      if (showHistory) {
        gameModel = gameModel.copyWith(games: completedGames);
      } else {
        gameModel = gameModel.copyWith(games: activeGames);
      }
      dialogs.closeLoader();
    } catch (e) {
      dialogs.closeLoader();
      alerts.showErrorAlert(e.toString());
    }
    notifyListeners();
  }

  void displayHistory() async {
    showHistory = true;
    await showCompletedGames();
    Navigator.pop(context);
  }

  void showAtive() async {
    showHistory = false;
    await showCompletedGames();
    Navigator.pop(context);
  }

  void deleteGame(DismissDirection direction, int id) async {
    try {
      dialogs.loader("Updating game status");
      await apiHelper.deleteGame(id);
      gameModel.games.removeWhere((element) => element.id == id);
      alerts.showErrorAlert("We forfeited the battlefield", isImage: true);
      dialogs.closeLoader();
    } catch (e) {
      alerts.showErrorAlert(e.toString());
    }
  }
}