
import 'dart:io';

import 'package:azaFashions/bloc/LoginBloc/LocationBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/networkprovider/LoginProvider.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/DESIGNER/afh_designerUI.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_categories.dart';
import 'package:azaFashions/ui/PROFILE/ProfileUI.dart';
import 'package:azaFashions/ui/PROFILE/WishlistItemDesignPage.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'afh_homeUI.dart';

class MainHome extends StatefulWidget {
  String title;

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController hideButtonController;
  var _isVisible;
  int _currentIndex, bagCounter = 1;
  Widget _currentPage;
  List<Widget> _pages = [];

  final connectivity=new ConnectivityService();
  var connectionStatus;
  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "Main Home Page");
    super.initState();
    IntroModelList.locationStatus==false?LoginProvider().getUserLocation(context):null;
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;

    LoginProvider().getBagCount(context);
    bottomNavigationController();

  }

  bottomNavigationController(){
    hideButtonController = new ScrollController(initialScrollOffset: 0.0);

    _isVisible = true;
    hideButtonController.addListener(() {
      hideButtonController.position.isScrollingNotifier.addListener(() {
        if(!hideButtonController.position.isScrollingNotifier.value) {
          print('scroll is stopped');
          if (!_isVisible)
            setState(() {
              _isVisible = true;
              print("**** $_isVisible up");
            });
        } else {
          if (_isVisible)
            setState(() {
              _isVisible = false;
              print("**** $_isVisible up");
            });
          print('scroll is started');
        }
      });
    });

  hideButtonController.addListener(() {
      if (hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse ||
          hideButtonController.position.userScrollDirection ==
              ScrollDirection.forward) {
        if (_isVisible)
          setState(() {
            _isVisible = false;
            print("**** $_isVisible up");
          });
      }
      if (hideButtonController.position.atEdge
&&
          hideButtonController.position.pixels == 0
) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
            print("**** $_isVisible down");
          });
      }
    });

    _pages = [
      HomeUI(controller: hideButtonController,),
      DesignerUI(),
      Categories(controller: hideButtonController,),
      WishlistItemDesignPage(controller: hideButtonController,),
      ProfileUI(controller: hideButtonController,),
    ];
    _currentIndex = 0;
    _currentPage = _pages[0];

    // handleDeepLinkLogic();
    // location_bloc.storeLocation();
  }

   @override
  void dispose() {
    super.dispose();
    connectivity.dispose();
   }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
      if(_currentIndex!=0){
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/homePage', (Route<dynamic> route) => false);
      }
      else{
        SystemNavigator.pop();
      }
      },
      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar:
            AppBarWidget().myAppBar(context, "AZA", scaffoldKey, webview: ""),
            drawer: Drawer(child: SideNavigation()),
            body:connectionStatus.toString()!="ConnectivityStatus.Offline"? _currentPage:ErrorPage(appBarTitle: "You are offline."),
            bottomNavigationBar: connectionStatus.toString()!="ConnectivityStatus.Offline"?Padding(
              padding: EdgeInsets.only(bottom:Platform.isIOS?22:0),
              child: _bottomNavigationData(context),
            ):ErrorPage(appBarTitle: "You are offline.")
        ),
      ),
    );
  }

  Widget _bottomNavigationData(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: _isVisible ? 60.0 : 0.0,
      child: _isVisible
          ? SingleChildScrollView(
        padding: EdgeInsets.only(top: 5),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: (index) => changeTab(index),
          currentIndex: _currentIndex,
          unselectedFontSize: 12,
          selectedFontSize: 14,
          items: [
            BottomNavigationBarItem(
              icon: new Image.asset("images/home_active_icon.png",
                  width: 20,
                  height: 20,
                  color: _currentIndex == 0 ? Colors.black : Colors.grey),
              title: new Text('Home',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Helvetica",
                      color: _currentIndex == 0
                          ? Colors.black
                          : Colors.grey)),
            ),
            BottomNavigationBarItem(
              icon: new Image.asset("images/hanger.png",
                  width: 20,
                  height: 20,
                  color: _currentIndex == 1 ? Colors.black : Colors.grey),
              title: new Text('Designers',
                  style: TextStyle(
                      fontFamily: "Helvetica",
                      fontSize: 12,
                      color: _currentIndex == 1
                          ? Colors.black
                          : Colors.grey)),
            ),
            BottomNavigationBarItem(
              icon: new Image.asset("images/categories.png",
                  width: 20,
                  height: 20,
                  color: _currentIndex == 2 ? Colors.black : Colors.grey),
              title: new Text('Categories',
                  style: TextStyle(
                      fontFamily: "Helvetica",
                      fontSize: 12,
                      color: _currentIndex == 2
                          ? Colors.black
                          : Colors.grey)),
            ),
            BottomNavigationBarItem(
              icon: ValueListenableBuilder(
                    valueListenable: BagCount.wishlistCount,
                    builder:(context,int value,Widget child ) =>BagCount.wishlistCount.value > 0
                        ?  Badge(
                    shape: BadgeShape.circle,
                    badgeColor: Colors.black,
                    alignment: Alignment.topRight,
                    badgeContent: Text(
                      "${BagCount.wishlistCount.value}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                            BagCount.wishlistCount.value > 9
                                ? 10
                                : 12)
                    ),
                    child: new Image.asset("images/wishlist_icon.png",
                        width: 20,
                        height: 20,
                        color: _currentIndex == 3
                            ? Colors.black
                            : Colors.grey))  : new Image.asset("images/wishlist_icon.png",
                  width: 20,
                  height: 20,
                  color: _currentIndex == 3
                      ? Colors.black
                      : Colors.grey),
                  ),

              title: new Text('Wishlist',
                  style: TextStyle(
                      fontFamily: "Helvetica",
                      fontSize: 11.5,
                      color: _currentIndex == 3
                          ? Colors.black
                          : Colors.grey)),
            ),
            BottomNavigationBarItem(
                icon: new Image.asset("images/profile_icon.png",
                    width: 20,
                    height: 20,
                    color:
                    _currentIndex == 4 ? Colors.black : Colors.grey),
                title: Text('Profile',
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        fontSize: 12,
                        color: _currentIndex == 4
                            ? Colors.black
                            : Colors.grey)))
          ],
        ),
      )
          : Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
