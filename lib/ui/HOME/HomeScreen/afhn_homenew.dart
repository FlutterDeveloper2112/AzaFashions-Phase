import 'dart:io';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/CatalogueDetails/Catlogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeNew extends StatefulWidget {
  final ScrollController controller;

  const HomeNew({Key key, this.controller}) : super(key: key);

  @override
  HomeNewPageState createState() => HomeNewPageState();
}

class HomeNewPageState extends State<HomeNew> {
  static int count = 1;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  void initState() {
    analytics.setCurrentScreen(screenName: "New");
    super.initState();
    // ignore: unnecessary_statements
    WebEngagePlugin.trackScreen("Home New Screen");
  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body:  NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if ( notification is ScrollEndNotification &&
                notification.metrics.atEdge &&
                notification.metrics.maxScrollExtent ==
                    notification.metrics.pixels) {
              setState(() {
                count++;
              });
            }
            return false;
          },
          child: ScrollConfiguration(
              behavior: new ScrollBehavior()
                ..buildViewportChrome(context, null, AxisDirection.down),
              child: Catalogue(
                "NEW",
                "/new",
                "",
                "",
                count,
                controller: widget.controller,
              ),),
        )
      ),
    );
  }
}
