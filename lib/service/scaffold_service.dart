import 'package:flutter/material.dart';

import 'getit_injector.dart';

ScaffoldService get scaffoldService => locate<ScaffoldService>();

class ScaffoldService {
  void showSnackBar({
    required BuildContext context,
    required String message,
    required bool error,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.greenAccent,
      ),
    );
  }
}
