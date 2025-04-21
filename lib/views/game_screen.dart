import 'package:battleships/view_models/game_viewmodel.dart';
import 'package:battleships/view_models/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  final bool isNewGame;

  const GameScreen({super.key, required this.isNewGame});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Use context.read here because it's being used inside initState which is allowed
    final viewModel = context.read<GameViewModel>();
    if (!widget.isNewGame) {
      viewModel.updateGameDetails();
    } else {
      viewModel.newGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    int rowCount = 6;
    int columnCount = 6;
  
    return WillPopScope(
      
      onWillPop: () async {
        await context.read<HomeViewModel>().showCompletedGames();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.isNewGame ? "Place Ships" : "Play Game",
            textAlign: TextAlign.center,
          ),
          actions: [
            Consumer<GameViewModel>(
              builder: (context, viewModel, _) {
                return viewModel.visibleSubmitbtn
                    ? TextButton(
                        onPressed: widget.isNewGame
                            ? viewModel.btnSubmitTapped
                            : () => viewModel.shoot(viewModel.selectedShot),
                        child: Row(
                          children: [
                            widget.isNewGame
                                ? const Icon(Icons.play_arrow_rounded, color: Color.fromARGB(255, 231, 15, 15))
                                : Image.asset('images/bang-black.png', color: const Color.fromARGB(255, 172, 243, 7), height: 20),
                            const SizedBox(width: 5),
                            Text(
                              widget.isNewGame ? "Play" : "Shoot",
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        ))
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("images/background.png"), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Expanded(
                child: buildGridRows(context, rowCount, columnCount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridRows(BuildContext context, int rowCount, int columnCount) {
    List<String> rowLabels = ['A', 'B', 'C', 'D', 'E'];
    List<int> columnValues = [1, 2, 3, 4, 5];

    double itemSize = MediaQuery.of(context).size.width / columnCount;
    double itemHeight = MediaQuery.of(context).size.height / rowCount;

    List<Widget> rows = List.generate(rowCount, (rowIndex) {
      List<Widget> columns = List.generate(columnCount, (colIndex) {
        return buildCell(context, rowIndex, colIndex, rowLabels, columnValues, itemSize, itemHeight);
      });

      return Flexible(
        child: Row(
          children: columns,
        ),
      );
    });

    return Column(
      children: rows,
    );
  }

  Widget buildCell(BuildContext context, int rowIndex, int colIndex, List<String> rowLabels,
      List<int> columnValues, double itemSize, double itemHeight) {
    if (rowIndex == 0 && colIndex == 0) {
      // Display the top-left cell with an empty container
      return SizedBox(
        width: itemSize,
        height: itemHeight,
      );
    } else if (rowIndex == 0) {
      // Display the first row with values 1-5
      return Container(
        width: itemSize,
        height: itemHeight,
        decoration: BoxDecoration(border: Border.all()),
        child: Center(
          child: Text(
            '${columnValues[colIndex - 1]}',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else if (colIndex == 0) {
      // Display the first column with values A-E
      return Container(
        width: itemSize,
        height: itemHeight,
        decoration: BoxDecoration(border: Border.all()),
        child: Center(
          child: Text(
            rowLabels[rowIndex - 1],
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      // Display the remaining cells with the combination of column and row values
      return Consumer<GameViewModel>(
        builder: (context, viewModel, _) {
          var spots = '${rowLabels[rowIndex - 1]}${columnValues[colIndex - 1]}';
          return InkWell(
            onTap: () {
              // Handle click for other cells
              widget.isNewGame ? viewModel.placeShips(spots) : viewModel.chooseShot(spots);
              print('Clicked on $spots');
            },
            child: buildGridCell(spots, itemSize, itemHeight, viewModel),
          );
        },
      );
    }
  }

  Widget buildGridCell(String spots, double itemSize, double itemHeight, GameViewModel viewModel) {
    return Container(
      width: itemSize,
      height: itemHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(),
        color: viewModel.selectedShot == spots ? Colors.blue.shade100 : Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (viewModel.shipSpots.contains(spots))
            const Icon(Icons.directions_boat, color: Colors.grey),
          if (viewModel.shipSunk.contains(spots))
            const Icon(Icons.cancel, color: Colors.red),
          if (viewModel.shots.contains(spots) && !viewModel.shipSunk.contains(spots))
            const Icon(Icons.circle, color: Colors.black),
        ],
      ),
    );
  }
}
