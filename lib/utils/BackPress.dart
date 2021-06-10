import 'package:flutter/material.dart';
class BackPress {
   Future<bool> willPop(BuildContext context) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/homePage', (Route<dynamic> route) => false);
      return Future.value(false);

   }
   Future<bool> popOut(BuildContext context) {
    Navigator.pop(context);
      return Future.value(false);

   }
}
final backPress  = BackPress();