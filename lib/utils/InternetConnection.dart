

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class InternetConnection {
  checkInternet(BuildContext context) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    else{
      return false;
    }
  }
}