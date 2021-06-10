import 'dart:io';
import 'package:azaFashions/bloc/ProfileBloc/LoyaltyBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Profile/Points.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PROFILE/AzaPoints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import 'package:firebase_analytics/firebase_analytics.dart';


class AzaLoyalty extends StatefulWidget{
  @override
  AzaLoyaltyState createState() => AzaLoyaltyState();
}


class AzaLoyaltyState extends State<AzaLoyalty> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final connectivity=new ConnectivityService();
  var connectionStatus;



  @override
  void initState() {
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("Aza Loyalty Page");
    analytics.setCurrentScreen(screenName: "Aza Loyalty");

    loyaltyBloc.fetchPoints();

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
        resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar:AppBarWidget().myAppBar(context, "Aza Loyalty Points",scaffoldKey),
          drawer: Drawer(
              child:SideNavigation(title: "My Loyalty Points",)
          ),
          body: connectionStatus.toString()!="ConnectivityStatus.Offline"?ScrollConfiguration(
              behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
              child:  StreamBuilder(
                  stream: loyaltyBloc.pointFetchers,
                  builder: (context, AsyncSnapshot<PointsList> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      WebEngagePlugin.trackEvent("Aza Loyalty Points",{"Points": "${snapshot.data.point_model[0].loyalty}}"});

                      if(snapshot.data.point_model.length>0){
                        return   SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child:Column(
                                children:<Widget> [
                                  Column(
                                    children: [
                                      AzaPoints(
                                        designerImage:"${snapshot.data.bannerImage}" ,
                                        designertitle:"${snapshot.data.point_model[0].loyalty}" ,
                                        patternName: "",
                                        designDescription: "${snapshot.data.point_model[0].name}",
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 5),
                                        child:Align(
                                          alignment: Alignment.center,
                                          child:Text('${snapshot.data.point_model[0].info}', textAlign:TextAlign.center,style: TextStyle(fontFamily: "Helvetica",color: Colors.black),),
                                          // ignore: missing_return
                                        ),
                                      ),
                                      howToRedeemPts(),
                                    ],
                                  )


                                ]
                            )
                        );
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
            padding: EdgeInsets.only(top:20,right:10,left:10),
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
                              "How To Redeem Loyalty Points", textAlign: TextAlign.center,
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
                          child: Text("Earn reward points every time you make a purchase. 10 Currency Units at the time of purchase = 1 Loyalty Point which is added to your account after payment is processed.",textAlign:TextAlign.left,maxLines:2,overflow:TextOverflow.clip,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "Helvetica",fontSize :13,color: Colors.black45),),
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
                        padding: EdgeInsets.only(left:25,right:20,top:5,bottom: 10),
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
                          child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit",textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "Helvetica",fontSize :13,color: Colors.black45),),
                        )),


                  ],
                ),
*/
              ],
            ),
          ),
        )
      ],
    );
  }

}
