import 'package:battleships/view_models/base_viewmodel.dart';
import 'package:battleships/view_models/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var homeviewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeviewModel.showHistory = false;
    Future.delayed(Duration.zero, homeviewModel.showCompletedGames);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, viewModel, _) {
      return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("images/background.png"), fit: BoxFit.cover)),
                child: InkWell(
                  onTap: viewModel.showAtive,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                          child: Image.asset("images/title.png"),
                        ),
                        Text(
                          "Login as ${BaseViewModel.username}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    onTap: viewModel.newGame,
                    leading: Icon(
                      Icons.add_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text("New Game"),
                  ),
                  ListTile(
                    onTap: () => viewModel.newGamewithAI(mounted),
                    leading: FaIcon(FontAwesomeIcons.robot, color: Theme.of(context).primaryColor),
                    title: const Text("New Game (AI)"),
                  ),
                  ListTile(
                    onTap: viewModel.displayHistory,
                    leading: Icon(
                      Icons.list_alt_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text("History"),
                  ),
                  ListTile(
                    onTap: viewModel.logout,
                    leading: Icon(
                      Icons.logout_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text("Logout"),
                  ),
                ],
              ))
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Battleship",
            textAlign: TextAlign.center,
          ),
          actions: [IconButton(onPressed: viewModel.showCompletedGames, icon: const Icon(Icons.replay_rounded))],
        ),
        body: viewModel.gameModel.games.isEmpty
            ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: Text(
                            viewModel.showHistory
                                ? "Finish the battle, then you can make history"
                                : "Lets get into the battlefield",
                            style: const TextStyle(fontSize: 20))),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: viewModel.gameModel.games.length,
                itemBuilder: (context, index) {
                  var game = viewModel.gameModel.games[index];
                  var data = game.turn != 0
                      ? game.turn == game.position
                          ? "MyTurn"
                          : "OponentsTurn"
                      : game.status == game.position
                          ? "You Won"
                          : game.status == 0
                              ? "Finding your Opponent"
                              : "You Loose";
                  var listTile = ListTile(
                    onTap: () => viewModel.showGameStatus(index),
                    leading: Text(
                      "#${game.id}",
                    ),
                    title: Text("${game.player1} ${game.player2.isNotEmpty ? (" vs ${game.player2}") : ""}",
                        style: const TextStyle(fontSize: 18)),
                    trailing: Text(
                      data,
                      style: TextStyle(
                          fontSize: 18,
                          color: ["You Won", "MyTurn"].contains(data)
                              ? const Color.fromARGB(255, 196, 79, 20)
                              : data == "Finding your Opponent"
                                  ? const Color.fromARGB(255, 95, 41, 210)
                                  : const Color.fromARGB(255, 95, 54, 244)),
                    ),
                  );
                  return viewModel.showHistory
                      ? listTile
                      : Dismissible(
                          key: ValueKey(game.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: const Color.fromARGB(255, 101, 73, 214),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 12.0),
                                  child: Icon(Icons.delete_forever),
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) => viewModel.deleteGame(direction, game.id),
                          child: listTile,
                        );
                }),
      );
    });
  }
}