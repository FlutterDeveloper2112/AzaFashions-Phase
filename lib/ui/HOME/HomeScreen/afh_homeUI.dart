import 'dart:io';
import 'package:azaFashions/bloc/LoginBloc/HomeApiBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Login/BulletMenuList.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afhh_homehome.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afhn_homenew.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afhof_homeoffers.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afht_hometrending.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class HomeUI extends StatefulWidget {
  final ScrollController controller;

  const HomeUI({Key key, this.controller}) : super(key: key);
  @override
  _HomeUIPageState createState() => _HomeUIPageState();
}

class _HomeUIPageState extends State<HomeUI> {
  //final DynamicLinkService _service = new DynamicLinkService();
  int topMenu_length = 0;

  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  void initState() {

    super.initState();
    // ignore: unnecessary_statements

    // handleDeepLinkLogic();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

   return  DefaultTabController(

          length: 4,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _appBarData(context),
            body:
            TabBarView(

              children: [
                HomeHome(controller:widget.controller,),
                HomeNew(controller: widget.controller,),
                TrendingScreen(controller: widget.controller,),
                HomeOffers(controller: widget.controller,),
              ],
            ),
          ),
   );
  }


  Widget _appBarData(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: new Container(
          decoration: BoxDecoration(

              border: Border(
                bottom: BorderSide(color: Colors.black12, width: 3),
              )),
          //color: Colors.white,
          height: 70.0,
          child: new TabBar(

              indicatorColor: Colors.grey,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
              tabs: [
                Tab(child: Align(
                    alignment: Alignment.center,
                    child: Text("Home", textAlign: TextAlign.center,
                        style: TextStyle(fontWeight:FontWeight.bold,fontFamily:"PlayfairDisplay",fontSize: 15)))),
                Tab(child: Align(
                    alignment: Alignment.center,
                    child: Text("New", textAlign: TextAlign.center,
                        style: TextStyle(fontWeight:FontWeight.bold,fontFamily:"PlayfairDisplay",fontSize: 15)))),
                Tab(child: Align(
                    alignment: Alignment.center,
                    child: Text("Trending", textAlign: TextAlign.center,
                        style: TextStyle(fontWeight:FontWeight.bold,fontFamily:"PlayfairDisplay",fontSize: 15)))),
                Tab(child: Align(
                    alignment: Alignment.center,
                    child: Text("Offers", textAlign: TextAlign.center,
                        style: TextStyle(fontWeight:FontWeight.bold,fontFamily:"PlayfairDisplay",fontSize: 15))))
              ]
          ),
        ));
  }

}