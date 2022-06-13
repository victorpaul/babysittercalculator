import 'package:flutter/material.dart';

class NotificationService {
  static final snackBarMessangerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String message) {
    var snackBar = SnackBar(
      content: Text(message),

    );

    snackBarMessangerKey.currentState?.clearSnackBars();
    snackBarMessangerKey.currentState?.showSnackBar(snackBar);
  }
}
