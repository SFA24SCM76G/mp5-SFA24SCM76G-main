// ignore_for_file: use_build_context_synchronously

import 'package:battleships/main.dart';
import 'package:battleships/models/place_shot_response.dart';
import 'package:battleships/models/set_game_response.dart';
import 'package:battleships/view_models/base_viewmodel.dart';
import 'package:battleships/views/home_screen.dart';
import 'package:flutter/cupertino.dart';

class GameViewModel extends BaseViewModel {
  bool visibleSubmitbtn = true;
  List<String> shipSpots = [];
  List<String> shipSunk = [];
  List<String> shipWrek = [];
  List<String> shots = [];
  String selectedShot = "";
  SetGameResponse setGameResponse = SetGameResponse.fromMap({});
  PlaceShotResponse placeShotResponse = PlaceShotResponse.fromMap({});

  void newGame() {
    visibleSubmitbtn = true;
    shipSpots = [];
    shipSunk = [];
    shipWrek = [];
    shots = [];
    selectedShot = "";
  }

  void updateGameDetails() {
    shipSpots = BaseViewModel.gameDetailsResponse.ships;
    shipSunk = BaseViewModel.gameDetailsResponse.sunk;
    shipWrek = BaseViewModel.gameDetailsResponse.wrecks;
    shots = BaseViewModel.gameDetailsResponse.shots;
    visibleSubmitbtn = BaseViewModel.gameDetailsResponse.status == 3 &&
        (BaseViewModel.gameDetailsResponse.turn == BaseViewModel.gameDetailsResponse.position);
  }

  void btnSubmitTapped() async {
    try {
      if (shipSpots.length < 5) {
        alerts.showErrorAlert("You have to place all five ships in battlefield");
        return;
      }
      dialogs.loader("Updating the ships location");
      setGameResponse = await apiHelper.setGame(shipSpots, BaseViewModel.aiOption);
      BaseViewModel.aiOption = '';
      dialogs.closeLoader();
      Navigator.of(context)
          .pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const Homescreen()), (route) => false);
    } catch (e) {
      alerts.showErrorAlert(e.toString());
    }
  }

  void shoot(String shot) async {
    try {
      if (shot.isEmpty) {
        alerts.showErrorAlert("Choose the shot to destroy opponent ship");
        return;
      }
      dialogs.loader("Burning the spot");
      placeShotResponse = await apiHelper.placeShot(BaseViewModel.gameDetailsResponse.id, shot);
      if (placeShotResponse.sunkShip) {
        shipSunk.add(shot);
      } else {
        shots.add(shot);
      }
      BaseViewModel.gameDetailsResponse = await apiHelper.gameDetails(BaseViewModel.gameDetailsResponse.id);
      updateGameDetails();

      if (BaseViewModel.gameDetailsResponse.status == BaseViewModel.gameDetailsResponse.position) {
        await dialogs.winnerPopUp(true);
      } else if (BaseViewModel.gameDetailsResponse.status != BaseViewModel.gameDetailsResponse.position &&
          BaseViewModel.gameDetailsResponse.status != 3) {
        await dialogs.winnerPopUp(false);
      }
      dialogs.closeLoader();
      selectedShot = '';
    } catch (e) {
      alerts.showErrorAlert(e.toString());
    }
    notifyListeners();
  }

  void chooseShot(String shot) {
    if (shots.contains(shot)) {
      alerts.showErrorAlert("You are already shot at that place");
      return;
    }
    selectedShot = shot;
    notifyListeners();
  }

  void placeShips(String spots) {
    if (!shipSpots.contains(spots)) {
      if (shipSpots.length < 5) {
        shipSpots.add(spots);
      } else {
        alerts.showErrorAlert("You have placed all five ships");
      }
    } else {
      shipSpots.remove(spots);
    }
    notifyListeners();
  }
}