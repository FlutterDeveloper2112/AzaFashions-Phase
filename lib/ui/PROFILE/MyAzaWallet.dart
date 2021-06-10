
import 'package:azaFashions/utils/CountryInfo.dart';
import 'dart:io';
import 'dart:async';

import 'package:azaFashions/bloc/LoginBloc/IntroScreenBloc.dart';
import 'package:azaFashions/bloc/ProfileBloc/PointsBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/models/Profile/Points.dart';
import 'package:azaFashions/networkprovider/ProfileProvider.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/HOME/IntroScreens/afss_start_shopping.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PROFILE/AzaPoints.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';



class AzaWallet extends StatefulWidget{
  @override
  AzaWalletState createState() => AzaWalletState();
}


class AzaWalletState extends State<AzaWallet> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final connectivity=new ConnectivityService();
  var connectionStatus;



  @override
  void initState() {
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("Aza Wallet Page");

    pointsBloc.fetchPoints();
    analytics.setCurrentScreen(screenName: "Aza Wallet");
    // TODO: implement initState
    super.initState();
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
          appBar:AppBarWidget().myAppBar(context, "My Aza Wallet",scaffoldKey),
          drawer: Drawer(
              child:SideNavigation(title: "My Aza Wallet",)
          ),
          body: connectionStatus.toString()!="ConnectivityStatus.Offline"?ScrollConfiguration(
              behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
              child:  StreamBuilder(
              stream: pointsBloc.pointFetchers,
              builder: (context, AsyncSnapshot<PointsList> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if(snapshot.data.point_model.length>0){
                    return   SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:Column(
                        children:<Widget> [
                          ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.all(10.0),
                            itemCount: snapshot.data.point_model.length,
                            itemBuilder: (BuildContext context, int index) {
                              if(snapshot.data.point_model[index].name=="AZA Wallet"){
                                WebEngagePlugin.trackEvent("Aza Wallet ",{"Amount": "${snapshot.data.point_model[index].wallet}}"});
                                return Column(
                                  children: [
                                    AzaPoints(
                                      designerImage:"${snapshot.data.bannerImage}" ,
                                      designertitle:"${snapshot.data.point_model[index].wallet}" ,
                                      patternName: "",
                                      designDescription: "${snapshot.data.point_model[index].name}",
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 5),
                                      child:Align(
                                        alignment: Alignment.center,
                                        child:Text('${snapshot.data.point_model[index].info}', textAlign:TextAlign.center,style: TextStyle(fontFamily: "Helvetica",color: Colors.black),),
                                        // ignore: missing_return
                                      ),
                                    ),
                                    Divider(thickness: 2,color: Colors.grey[200],)

                                  ],
                                );
                              }
                              else{
                                //AZA CREDITS
                                return
                                  Column(
                                    children:<Widget> [
                                      Padding(
                                        padding: EdgeInsets.only(top:10),
                                        child: Text("${CountryInfo.currencySymbol} ${snapshot.data.point_model[index].credit}",textAlign:TextAlign.center,style: TextStyle(fontFamily: "Helvetica",fontWeight:FontWeight.normal,fontSize :22,color: Colors.black),),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(top:10),
                                        child: Text("${snapshot.data.point_model[index].name}",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize :15, fontFamily: "PlayfairDisplay",color: Colors.black),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 5),
                                        child:Align(
                                          alignment: Alignment.center,
                                          child:Text('${snapshot.data.point_model[index].info}', textAlign:TextAlign.center,style: TextStyle(fontFamily: "Helvetica",color: Colors.black),),
                                        ),
                                      ),

                                    ],
                                  );


                              }
                            },

                            separatorBuilder: (context, index) {
                              return Center();
                            },
                          ),
                          howToRedeemPts(),

                        ]
                    )
                );;
                  }
                  else{
                    return Center();
                  }
                }
                else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

              }
          )):ErrorPage(appBarTitle: "You are offline.",)),
    );
  }

  Widget howToRedeemPts(){
    return Column(
      children: <Widget>[
        Divider(thickness: 2,color: Colors.grey[200],),
        Container(
            width: double.infinity,
            padding: EdgeInsets.only(top:20,right:10,left:10, bottom: Platform.isIOS?25:10,),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Divider(color: Colors.black,),
                  ),
                  Expanded(
                      flex:4,
                      child:Container(
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "How To Redeem Wallet", textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  fontFamily: "PlayfairDisplay",
                                  color: Colors.black),),
                          )
                      )),
                  Expanded(
                    child: Divider(color: Colors.black,),
                  ),
                ]
            )
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            width:double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300],
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child:  Column(
              children:<Widget> [
                Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left:10,top:10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("1) Points for Every Purchase",textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "PlayfairDisplay",fontSize :15,color: Colors.black),),
                        )),

                    Padding(
                        padding: EdgeInsets.only(left:25,right:20,top:5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Earn reward points every time you make a purchase. 10 Currency Units at the time of purchase = 1 Loyalty Point",textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "Helvetica",fontSize :13,color: Colors.black45),),
                        )),


                  ],
                ),
                Divider(),
                Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left:10,top:10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("2) Redeem Rewards",textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "PlayfairDisplay",fontSize :15,color: Colors.black),),
                        )),

                    Padding(
                        padding: EdgeInsets.only(left:25,right:20,top:5,bottom:10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("1000 Loyalty Points = 100 Currency Units that can be redeemed at the time of purchase in the checkout",textAlign:TextAlign.left,maxLines:2,overflow:TextOverflow.clip,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "Helvetica",fontSize :13,color: Colors.black45),),
                        )),


                  ],
                ),
              /*  Divider(),
                Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left:10,top:10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("3) Redeem Rewards",textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "PlayfairDisplay",fontSize :15,color: Colors.black),),
                        )),

                    Padding(
                        padding: EdgeInsets.only(left:20,right:25,top:5,bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("1000 Loyalty Points = 100 Currency Units that can be redeemed at the time of purchase in the checkout",textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "Helvetica",fontSize :13,color: Colors.black45),),
                        )),


                  ],
                ),*/

              ],
            ),
          ),
        )
      ],
    );
  }


}

