import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:azaFashions/bloc/LoginBloc/IntroScreenBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HOME/IntroScreens/afss_start_shopping.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class IntroScreensUI extends StatefulWidget {
  @override
  IntroScreensState createState() {
    return new IntroScreensState();
  }
}

class IntroScreensState extends State<IntroScreensUI> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  SessionDetails _sessionDetails = SessionDetails();
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  List<IntroModel> introScreens;
  var connectionStatus;
  final connectivity=new ConnectivityService();

  @override
  void initState() {
    super.initState();
    analytics.setCurrentScreen(screenName: "Introductory Screens");
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  getDetails(){
    Future.delayed(Duration(seconds: 0), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.get("introScreens") != "" && prefs.get("introScreens") != null) {
        setState(() {
          introScreens = List<IntroModel>();
          jsonDecode(prefs.get("introScreens")).forEach((v) {
            introScreens.add(new IntroModel.fromJson(v));
          });
        });
      }
      else {
  //      bloc.fetchAllIntroData();

      }
    });
  }



  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    print("CONNECTION STATUS widget: $connectionStatus");
    connectionStatus!=null && connectionStatus.toString()!="ConnectivityStatus.Offline"?getDetails():"";
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
           resizeToAvoidBottomInset: false,
          body: connectionStatus!=null && connectionStatus.toString()!="ConnectivityStatus.Offline"?(introScreens!= null && introScreens.length>0)?SafeArea(
            top: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    height:MediaQuery.of(context).size.height,
                    child: PageView.builder(
                        itemCount: introScreens.length - 1,
                        controller: _pageController,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              Container(
                                  child: _buildImage(
                                      context, introScreens[index]),
                                ),

                              Container(

                                child: Column(
                                  children: <Widget>[
                                    _buildTitle(context, introScreens[index]),
                                    _buildDescription(context, introScreens[index]),
                                    _buildCircleIndicator(introScreens.length - 1),
                                    _buildSkipText(context)
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        onPageChanged: (int index) {
                          if (index == introScreens.length - 2) {
                            WebEngagePlugin.userLogin('Shravu');
                            _currentPageNotifier.value = index;
                            Timer(Duration(seconds: 2), () {
                              _sessionDetails.clearIntroScreens();
                              _sessionDetails.skippedIntro(true);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          StartShoppingUI()));
                            });
                          } else {
                            print(
                                "Index: $index ${introScreens.length - 1}");
                            _currentPageNotifier.value = index;
                          }
                        }),
                  ),

                ],
              ),
            ),
          ):
          StreamBuilder(
           stream: bloc.fetchAllData,
           builder: (context, AsyncSnapshot<IntroModelList> snapshot) {
             if (snapshot.hasData) {
              return Column(
                 children: <Widget>[
                   Expanded(
                     child:PageView.builder(
                         itemCount: snapshot.data.intro_model.length-1,
                         controller: _pageController,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                             children: <Widget>[
                               Container(
                                   child: _buildImage(context, snapshot.data.intro_model[index]),
                                 ),

                                 Container(
                                   child: Column(
                                     children: <Widget>[
                                       _buildTitle(context,snapshot.data.intro_model[index]),
                                       _buildDescription(context, snapshot.data.intro_model[index]),
                                       _buildCircleIndicator( snapshot.data.intro_model.length-1),
                                       _buildSkipText(context)
                                     ],
                                   ),
                                 ),

                             ],
                           );

                         },
                         onPageChanged: (int index) {
                           if(index==snapshot.data.intro_model.length-2){
                             _currentPageNotifier.value = index;
                             Timer(Duration(seconds: 2), () {
                             _sessionDetails.skippedIntro(true);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StartShoppingUI()));
                           });
                           }
                           else {
                             print("Index: $index ${snapshot.data.intro_model.length - 1}");
                             _currentPageNotifier.value = index;
                           }

                         }),            ),


                ],
              );
            }
           else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ):
          ErrorPage(
            appBarTitle: "You are offline.",
          ),
      ),
    );
  }

  _buildCircleIndicator(int count) {
    return Padding(
      padding: const EdgeInsets.only(top:5.0),
      child: CirclePageIndicator(
        selectedBorderColor: Colors.black,
        selectedDotColor: Colors.black,
        borderWidth: 1.5,
        borderColor: Colors.black,
        dotColor: Colors.white,
        itemCount: count,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

  _buildImage(BuildContext context, IntroModel _introModel) {

    return Align(
    alignment: Alignment.topCenter,
    child: Container(
      width: 414,
      height: MediaQuery.of(context).size.height*0.65,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: CachedNetworkImageProvider(_introModel.image),
          //Can use CachedNextworkImage
        ),
      ),
    ));
  }

  _buildTitle(BuildContext context, IntroModel _introModel) {
    return new Container(
      padding: const EdgeInsets.only(top: 10.0,bottom: 5),
      width: double.infinity,
      child: new Column(
        children: <Widget>[
          new Text(
            _introModel.header,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: "PlayfairDisplay",
                fontSize: 25.0,
                color: Colors.black),
          )
        ],
      ),
    );
  }

  _buildDescription(BuildContext context, IntroModel _introModel) {
    return new Container(
      padding: const EdgeInsets.only(top:8,bottom:8),
      width: MediaQuery.of(context).size.width * 0.85,
      child: new Column(
        children: <Widget>[
          new Text(
            _introModel.content,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: "Helvetica",
                fontSize: 14.5,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

  _buildSkipText(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      width: MediaQuery.of(context).size.width * 0.7,
      child: new Column(
        children: <Widget>[
          InkWell(
              child: Text(
                "SKIP INTRO",
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontFamily: "Helvetica",
                    color: Colors.black),
              ),
              onTap: () {


                WebEngagePlugin.trackScreen(
                    'Pressed on Skipped Button');

                _sessionDetails.clearIntroScreens();
                _sessionDetails.skippedIntro(true);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => StartShoppingUI()));
              }),
        ],
      ),
    );
  }
}
