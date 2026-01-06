import 'package:flutter/material.dart';

class Toaster {
  static void showErrorToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        // action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );
  }

  static void showSuccessToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        // action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );
  }
}
