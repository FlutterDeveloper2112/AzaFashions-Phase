import 'dart:io';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PROFILE/WishlistItemDesignPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class MyWishList extends StatefulWidget {
  @override
  MyWishListState createState() => MyWishListState();
}

class MyWishListState extends State<MyWishList> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final connectivity=new ConnectivityService();
  var connectionStatus;

  @override
  void initState() {

    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("My Wishlist Page");
    analytics.setCurrentScreen(screenName: "My Wishlist");
    wishList.getWishList();

    // connectionStatus.toString()!="ConnectivityStatus.Offline"?  wishList.getWishList():"";


    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    print("DISPOSE CALLED");
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
          appBar: AppBarWidget().myAppBar(context, "My WishList", scaffoldKey,webview: ""),
          drawer: Drawer(
              child: SideNavigation(
                title: "My Aza Wallet",
              )),
          body:connectionStatus.toString()!="ConnectivityStatus.Offline"?Padding(
            padding:  EdgeInsets.only(bottom:20),
            child: WishlistItemDesignPage(),
          ):ErrorPage(appBarTitle: "You are offline.",)

      ),
    ) ;
  }
}
