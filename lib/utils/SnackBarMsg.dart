
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarMsg{
BuildContext context;


  getSuccessSnack(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,String msg) {
    return scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text("$msg")));
  }

}