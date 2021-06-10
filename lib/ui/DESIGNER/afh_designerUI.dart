import 'dart:io';

import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/DESIGNER/AllDesigner.dart';
import 'package:azaFashions/ui/DESIGNER/FeaturedDesigner.dart';
import 'package:azaFashions/ui/DESIGNER/MyDesigner.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class DesignerUI extends StatefulWidget {
  @override
  _DesignerUIPageState createState() => _DesignerUIPageState();
}

class _DesignerUIPageState extends State<DesignerUI> {
  final connectivity=new ConnectivityService();
  var connectionStatus;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
     super.initState();
     // ignore: unnecessary_statements
     connectivity.connectionStatusController;
     WebEngagePlugin.trackScreen("Designers Screen");
     analytics.setCurrentScreen(screenName: "Designer Page");


  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);

  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);

    return connectionStatus.toString()!="ConnectivityStatus.Offline"?DefaultTabController(
        length: 3,
        child: MediaQuery(
          data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
              appBar: _appBarData(context),
              body: TabBarView(
                children: [
                  AllDesigner("child"),
                  FeaturedDesigner(),
                  MyDesigner()
                  // MyDesignerPage(), //HomeOffersTwo()
                ],
              )),
        )):ErrorPage(appBarTitle: "You are offline.");
  }

  Widget _appBarData(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: new Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12, width: 1),
              )),
          //color: Colors.white,
          height: 70.0,
          child: new TabBar(
            isScrollable: false,
            indicatorColor: Colors.grey,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("ALL",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "PlayfairDisplay", fontSize: 12)))),
              Tab(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("FEATURED",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "PlayfairDisplay", fontSize: 12)))),
              Tab(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("MY DESIGNER",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "PlayfairDisplay", fontSize: 12)))),
            ],
          ),
        ));
  }
}
