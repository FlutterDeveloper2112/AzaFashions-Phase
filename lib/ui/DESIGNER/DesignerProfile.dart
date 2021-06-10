import 'dart:io';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/CatalogueDetails/Catlogue.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/SHOPPINGCART/ShoppingBag.dart';
import 'package:azaFashions/ui/Search/SearchUI.dart';
import 'package:azaFashions/ui/Search/TransparentRoute.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class DesignerProfile extends StatefulWidget {
  final int id;
  final String title, url;


  // final bool isFollowing;

  DesignerProfile({this.title, this.id, this.url});

  @override
  DesignerPageState createState() => DesignerPageState();
}

class DesignerPageState extends State<DesignerProfile> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final connectivity = new ConnectivityService();
  var connectionStatus;
  final ScrollController controller = new ScrollController();
  static int count = 1;
  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    analytics.setCurrentScreen(screenName: "Designer Profile/${widget.id}");
    WebEngagePlugin.trackScreen("Designer Profile Screen :${widget.id} ");

  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);

    getAppBar(String title){
     return AppBar(
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {

                Navigator.of(context).pop();
             },
            child: Platform.isAndroid?Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ):Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Expanded(
              child: Center(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "$title",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "PlayfairDisplay",
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ))),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {Navigator.of(context).push(
                  TransparentRoute(builder: (BuildContext context) => SearchUI())
              );},
              child: Icon(
                Icons.search,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),

          Stack(
            alignment: Alignment.topRight,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (__) => new ShoppingBag()));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 15,right: 15),
                  child:ValueListenableBuilder(
                      valueListenable: BagCount.bagCount,
                      builder:(BuildContext context,int value,Widget child ) => BagCount.bagCount.value>0?Badge(
                        shape: BadgeShape.circle,
                        badgeColor: Colors.black,
                        alignment: Alignment.topLeft,
                        badgeContent: Text("${BagCount.bagCount.value}",style: TextStyle(
                            color: Colors.white,
                            fontSize:
                            BagCount.wishlistCount.value > 9
                                ? 10
                                : 12)),
                        child: GestureDetector(
                          onTap: ()async {
                            Navigator.push(context, new MaterialPageRoute(builder: (__) => new ShoppingBag()));
                          },
                          child: Image.asset(
                            "images/cart_icon.png",
                            width: 21,
                            height: 21,
                          ),
                        ),
                      ):
                      GestureDetector(
                        onTap: ()async {
                          Navigator.push(context, new MaterialPageRoute(builder: (__) => new ShoppingBag()));
                        },
                        child: Image.asset(
                          "images/cart_icon.png",
                          width: 20,
                          height: 20,
                        ),
                      )
                  ),
                ),
              ),

            ],

          ),
        ],
        backgroundColor: Colors.white,
      );
    }
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          key: scaffoldKey,
          appBar:getAppBar(widget.title),
          body:connectionStatus.toString()!="ConnectivityStatus.Offline"?NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if(Catalogue.count==1){

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
                "collection", widget.url, "", "", count,controller: controller,),
            )),
      ):ErrorPage(
        appBarTitle: "You are offline.",
      )),
    );










  }
}
