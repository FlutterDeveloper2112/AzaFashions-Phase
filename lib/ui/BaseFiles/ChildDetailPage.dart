import 'dart:io';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/CatalogueDetails/Catlogue.dart';
import 'package:azaFashions/ui/CatalogueDetails/ChildCatalogue.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class ChildDetailPage extends StatefulWidget {
  String screenName;
  String url;

  ChildDetailPage(this.screenName, this.url);

  @override
  CelebDetailPageState createState() => CelebDetailPageState();
}

class CelebDetailPageState extends State<ChildDetailPage> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController controller = ScrollController();
  bool isLoading = false;

  static int count = 1;

  final connectivity=new ConnectivityService();
  var connectionStatus;

  @override
  void initState() {
    super.initState();
    analytics.setCurrentScreen(screenName: "${widget.screenName}");
    WebEngagePlugin.trackScreen("Product Listing Screen: ${widget.screenName}");
  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar: AppBarWidget().myAppBar(
              context,
              widget.screenName!="SEARCH"?widget.screenName:"Collection",
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

                  child: ChildCatalogue(
                      widget.screenName, widget.url, "", "", count,controller: controller,),
                )),
          ):ErrorPage(
            appBarTitle: "You are offline.",
          )),
    );
  }
}
