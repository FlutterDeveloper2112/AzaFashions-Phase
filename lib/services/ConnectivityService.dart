import 'dart:async';

import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  // Create our public controller
  StreamController<ConnectivityStatus> connectionStatusController= StreamController<ConnectivityStatus>() ;

  ConnectivityService() {
    checkConnectivity1();
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t
      if(!connectionStatusController.isClosed){
        print("CONNECTION STATUS: ${connectionStatusController.isClosed}");
        connectionStatusController.add(_getStatusFromResult(result));
      }
      else{
        print("ELSE CONNECTION STATUS: ${connectionStatusController.isClosed}");
        connectionStatusController= StreamController<ConnectivityStatus>();
      }

    });
  }

  Future<String> checkConnectivity1() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    var conn = _getStatusFromResult(connectivityResult);
    print('RESULT OF INTERNET : $conn');
    return conn.toString();

  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }

  }


  @override
  void dispose() {
    connectionStatusController.close();
    connectionStatusController= StreamController<ConnectivityStatus>() ;

  }
}
