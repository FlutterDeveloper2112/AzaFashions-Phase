import 'dart:io';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/CatalogueDetails/Catlogue.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
class DetailPage extends StatefulWidget {
  String screenName;
  String url;

  // ignore: non_constant_identifier_names
  DetailPage(this.screenName, this.url,);

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController controller = ScrollController();
  bool isLoading = false;
  CatlogueDesignState catalogue = CatlogueDesignState();
  static int count = 1;

  final connectivity=new ConnectivityService();
  var connectionStatus;

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    WebEngagePlugin.trackScreen("Product Listing Screen: ${widget.screenName}");
    analytics.setCurrentScreen(screenName: "${widget.screenName}");
    connectivity.connectionStatusController;
  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);

    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar: AppBarWidget().myAppBar(
              context,
              widget.screenName,
              scaffoldKey,webview: ""),
          drawer: Drawer(
              child: SideNavigation(
                  title:
                  widget.screenName)),
          body:connectionStatus.toString()!="ConnectivityStatus.Offline"?NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if(Catalogue.count==1){
                print("Counter :$count");
              }
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
                child:  Padding(
                  padding:  EdgeInsets.only( bottom: Platform.isIOS?23:0,),
                  child: Catalogue(
                    widget.screenName, widget.url, "", "", count,controller: controller),
                )),
          ):ErrorPage(
            appBarTitle: "You are offline.",
          )),
    );
  }
}
