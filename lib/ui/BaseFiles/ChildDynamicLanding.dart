import 'dart:io';
import 'package:azaFashions/bloc/LandingPagesBloc/LandingPageData.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/LandingPages/ChildLandingPage.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/home_menuoptions.dart';
import 'package:azaFashions/utils/BackPress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class ChildDynamicLanding extends StatefulWidget{
  String url;
  String screen_name;

  ChildDynamicLanding(this.url,this.screen_name);
  @override
  LandingPageState createState() => LandingPageState();
}


class LandingPageState extends State<ChildDynamicLanding> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String screen_title="";

  final connectivity=new ConnectivityService();
  var connectionStatus;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
    analytics.setCurrentScreen(screenName: "${widget.screen_name}");
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("Product Listing Screen: ${widget.screen_name}");

  }

  @override
  void dispose() {
    Options.menu="";
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    connectionStatus.toString()!="ConnectivityStatus.Offline"? landingPageData.fetchChildLandingItems("${widget.url}") : "";

     return WillPopScope(
      onWillPop:()=> backPress.popOut(context),
      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar:AppBarWidget().myAppBar(context, "${widget.screen_name}",scaffoldKey,webview: ""),
            drawer: Drawer(
                child:SideNavigation(title: "$screen_title",)
            ),
            body:connectionStatus.toString()!="ConnectivityStatus.Offline"? ScrollConfiguration(
                behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
                child:SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child:StreamBuilder(
                          stream: landingPageData.fetchChildLandingPage,
                          builder: (context, AsyncSnapshot<ChildLandingPage> snapshot) {
                            if(snapshot.connectionState==ConnectionState.active){
                              if(snapshot.data!=null){
                                return Column(children:snapshot.data.other_layout);
                              }
                            }
                            else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        )
                    )
                )):
            ErrorPage(
              appBarTitle: "You are offline.",
            )),
      ),
    );
  }


}
