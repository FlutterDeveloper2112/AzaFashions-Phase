import 'dart:async';
import 'dart:io';

import 'package:azaFashions/bloc/LoginBloc/IntroScreenBloc.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HOME/IntroScreens/afss_start_shopping.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class Maintenance extends StatefulWidget {
  @override
  _MaintenanceState createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  FirebaseAnalytics analytics= new FirebaseAnalytics();
  List<IntroModel> introScreens;
  var connectionStatus;
  final connectivity = new ConnectivityService();

  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analytics.setCurrentScreen(screenName: "Maintenance");
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: (){
        return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
              title: Image.asset("images/splash_aza_logo.png",
                width: 60, height: 60,),
              centerTitle: true,
              leading: InkWell(
                onTap: (){
                  return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Platform.isAndroid?Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20
                ):Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
              )
            // automaticallyImplyLeading: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("images/under_maintenance.png",),
                Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                  width: double.infinity,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Under maintenance",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: "PlayfairDisplay",
                            fontSize: 25.0,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "We are currently undergoing maintenance",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: "Helvetica-Condensed",
                            fontSize: 15,
                            color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "This won't take long.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: "Helvetica-Condensed",
                            fontSize: 15,
                            color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }


}
