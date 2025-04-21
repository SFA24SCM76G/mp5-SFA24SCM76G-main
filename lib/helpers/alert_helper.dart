import 'package:battleships/main.dart';
import 'package:flutter/material.dart';

class AlertHelper {
  void showErrorAlert(String message, {IconData icon = Icons.remove_circle_outline, bool isImage = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isImage
                ? Image.asset('images/bang-black.png', color: Colors.white, height: 25)
                : Icon(icon, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              message,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 54, 27, 100)));
  }

  void showSuccessAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        content: Text(
          message,
          maxLines: 2,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 78, 21)));
  }
}