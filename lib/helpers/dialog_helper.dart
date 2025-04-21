import 'package:battleships/main.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static int loaderCount = 0;
  Future<String?> pickAIType(List<String> options) async => await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Lets play against?"),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                // separatorBuilder: (context, index) => const Divider(),
                // itemCount: options.length,
                children: options
                    .map<Widget>((index) => ListTile(
                          title: Text(index),
                          onTap: () => Navigator.pop(context, index),
                        ))
                    .toList()),
          ));

  Future<void> winnerPopUp(bool weWon) async => await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: weWon?const Text("Winner!!!"):const Text("Lost!!"),
          content: weWon
              ? const Text(
                  "You Won!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 18),
                )
              : const Text(
                  "We tried out best, But we Lost",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
        ),
      );

  Future<void> loader(String message) async => (DialogHelper.loaderCount++ == 0)
      ? await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.square(dimension: 25, child: CircularProgressIndicator.adaptive(strokeWidth: 3)),
                const SizedBox(width: 10),
                Flexible(child: Text(message, style: const TextStyle(fontSize: 16)))
              ],
            ),
          ),
        )
      : null;

  void closeLoader() {
    if (DialogHelper.loaderCount-- > 0) {
      Navigator.pop(context);
    }
  }
}