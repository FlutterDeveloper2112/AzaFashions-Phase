import 'dart:io';
import 'dart:convert';

import 'package:azaFashions/bloc/LandingPagesBloc/LandingPageData.dart';
import 'package:azaFashions/bloc/ProfileBloc/LoyaltyBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/models/Profile/Points.dart';
import 'package:azaFashions/networkprovider/LoginProvider.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsi_signin.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PROFILE/AzaPoints.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';



class EmailSubscription extends StatefulWidget{
  @override
  EmailSubscriptionState createState() => EmailSubscriptionState();
}


class EmailSubscriptionState extends State<EmailSubscription> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSwitched;
  UserLogin _userLogin = UserLogin();
  final connectivity=new ConnectivityService();
  var connectionStatus;

  bool isLoading;
  @override
  void initState() {
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;

    setState(() {
      isLoading = true;
    });
    getUserDetails();
    analytics.setCurrentScreen(screenName: "Email Subscription");
    WebEngagePlugin.trackScreen("Email Subscription Page");

    super.initState();
  }

  getUserDetails()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await LoginProvider().getBagCount(context);
    _userLogin=UserLogin.fromJson(jsonDecode(prefs.getString('userDetails')));
    setState(() {
      isLoading = false;
    });
  }


  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      isSwitched=BagCount.news_letter;
      print(isSwitched);
    });
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar:AppBarWidget().myAppBar(context, "Email Subscription",scaffoldKey),
          body: isLoading?Center(child: CircularProgressIndicator(),):  Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 5),
                      child:Align(
                        alignment: Alignment.center,
                        child:Text('Newsletter Subscription Status', textAlign:TextAlign.center,style: TextStyle(fontSize:18,fontFamily: "Helvetica",color: Colors.black),),
                        // ignore: missing_return
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:20.0),
                      child: CustomSwitch(
                        value: isSwitched,
                        onChanged: (value){
                          print(connectionStatus.toString());
                          if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                            setState(() {
                              isSwitched=value;
                              if(isSwitched){
                                landingPageData.fetchSubscriptionData(_userLogin.email);
                                landingPageData.fetchSubscription.listen((event) {
                                  if(event.error.isNotEmpty){
                                    scaffoldKey.currentState.removeCurrentSnackBar();
                                    scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("${event.error}"),
                                      duration: Duration(seconds: 1),
                                    ));

                                  }
                                  else{
                                    scaffoldKey.currentState.removeCurrentSnackBar();
                                    scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("${event.success}"),
                                      duration: Duration(seconds: 1),
                                    ));

                                  }
                                });
                              }
                              else{
                                landingPageData.fetchUnSubscriptionData(_userLogin.email);
                                landingPageData.fetchUnSubscription.listen((event) {
                                  if(event.error.isNotEmpty){
                                    scaffoldKey.currentState.removeCurrentSnackBar();
                                    scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("${event.error}"),
                                      duration: Duration(seconds: 1),
                                    ));
                                  }
                                  else{
                                    scaffoldKey.currentState.removeCurrentSnackBar();
                                    scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("${event.success}"),
                                      duration: Duration(seconds: 1),
                                    ));

                                  }
                                });
                              }

                              print(isSwitched);
                            });
                          }
                          else{
                            value=!value;
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
                          }

                        },
                        activeColor: Colors.lightGreen,
                      ),
                    ),


                  ],
                ),
              ),
            ],
          )),
    );
  }


}
