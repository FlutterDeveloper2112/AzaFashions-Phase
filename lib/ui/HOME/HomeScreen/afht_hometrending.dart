import 'dart:io';
import 'package:azaFashions/bloc/LandingPagesBloc/LandingPageData.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/LandingPages/BaseLandingPage.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TrendingScreen extends StatefulWidget {
  final ScrollController controller;

  const TrendingScreen({Key key, this.controller}) : super(key: key);
  @override
  TrendingScreenState createState() => TrendingScreenState();
}

class TrendingScreenState extends State<TrendingScreen> {
  FirebaseAnalytics analytics = FirebaseAnalytics();


@override
void initState() {
  super.initState();
  analytics.setCurrentScreen(screenName: "Trending");
  // ignore: unnecessary_statements
  landingPageData.fetchOffersLandingItems("on-sale");

  WebEngagePlugin.trackScreen("Trending Screen");
}

@override
void dispose() {

  super.dispose();
}

@override
  Widget build(BuildContext context) {
  landingPageData.fetchLandingItems("trending");
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          // resizeToAvoidBottomPadding: false,
          body: ScrollConfiguration(
              behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
              child:SingleChildScrollView(
                  controller: widget.controller,
                  scrollDirection: Axis.vertical,
                  child:Column(
                    children: [
                      StreamBuilder(
                        stream: landingPageData.fetchLandingPage,
                        builder: (context, AsyncSnapshot<LandingPage> snapshot) {
                          if(snapshot.connectionState==ConnectionState.active){
                            if(snapshot.data!=null){
                              return Padding(
                                padding:  EdgeInsets.only(bottom:40.0),
                                child: Column(children:snapshot.data.layout),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),

                    ],
                  )
              ))),
    );
  }




}