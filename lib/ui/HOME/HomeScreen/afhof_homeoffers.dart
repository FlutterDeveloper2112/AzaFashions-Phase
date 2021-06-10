import 'dart:io';

import 'package:azaFashions/bloc/LandingPagesBloc/LandingPageData.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/LandingPages/BaseLandingPage.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class HomeOffers extends StatefulWidget{
  final ScrollController controller;

  const HomeOffers({Key key, this.controller}) : super(key: key);
  @override
  HomeOffersPageState createState() => HomeOffersPageState();
}


class HomeOffersPageState extends State<HomeOffers> {
final connectivity=new ConnectivityService();
var connectionStatus;
FirebaseAnalytics analytics = FirebaseAnalytics();
@override
void initState() {
  super.initState();
  analytics.setCurrentScreen(screenName: "Offers");
  // ignore: unnecessary_statements
  connectivity.connectionStatusController;
  WebEngagePlugin.trackScreen("Home Offers Screen");
}

@override
void dispose() {
  connectivity.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    connectionStatus.toString()!="ConnectivityStatus.Offline"? landingPageData.fetchOffersLandingItems("on-sale"):"";

    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ScrollConfiguration(
              behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
              child:connectionStatus.toString()!="ConnectivityStatus.Offline"?SingleChildScrollView(
                  controller: widget.controller,
                  scrollDirection: Axis.vertical,
                  child:StreamBuilder(
                    stream: landingPageData.fetchOffersLandingPage,
                    builder: (context, AsyncSnapshot<LandingPage> snapshot) {
                      if(snapshot.connectionState==ConnectionState.active){
                        if(snapshot.data!=null){
                          return Padding(
                            padding:  EdgeInsets.only( bottom: Platform.isIOS?23:40,),
                            child: Column(children:snapshot.data.layout),
                          );
                        }
                      }
                      else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  )
              ):ErrorPage(appBarTitle: "You are offline.",))),
    );
  }




}
