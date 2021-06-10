import 'dart:io';

import 'package:azaFashions/bloc/LandingPagesBloc/LandingPageData.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/LandingPages/BaseLandingPage.dart';
import 'package:azaFashions/bloc/LoginBloc/LoginBloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';


class HomeHome extends StatefulWidget {
  final ScrollController controller;

  const HomeHome({Key key, this.controller}) : super(key: key);
  @override
  _Home_HomePage createState() => _Home_HomePage(controller: controller);
}

class _Home_HomePage extends State<HomeHome> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String text;
  TextEditingController _controller = TextEditingController();
  final ScrollController controller;
  _Home_HomePage({this.controller});

  @override
  void initState() {
    landingPageData.fetchHomeLandingItems("home");
    analytics.setCurrentScreen(screenName: "Home");
    loginBloc.getLoginDetails(context,"home");
    // ignore: unnecessary_statements
    WebEngagePlugin.trackScreen("Home Screen");
    super.initState();

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    // connectionStatus.toString()!="ConnectivityStatus.Offline"?landingPageData.fetchHomeLandingItems("home"):"";

    // print(controller.position);
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          key:scaffoldKey,
          backgroundColor: Colors.white,
          // resizeToAvoidBottomPadding: false,
          body: ScrollConfiguration(
              behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
              child:SingleChildScrollView(
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  child:Column(
                    children: [
                      StreamBuilder(
                        stream: landingPageData.fetchHomeLandingPage,
                        builder: (context, AsyncSnapshot<LandingPage> snapshot) {
                          if(snapshot.connectionState==ConnectionState.active){
                            if(snapshot.data!=null){
                              return Column(children: snapshot.data.layout);
                            }
                          }
                          else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                      landingPageData.fetchHomeLandingPage.isEmpty != null?getInsiderWidget(context):Center(),
                      landingPageData.fetchHomeLandingPage.isEmpty != null?lowerBanner(context):Center()

                    ],
                  )
              ))),
    );
  }



  Widget getInsiderWidget(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
        child: Container(
            width: double.infinity,
            height: 130,
            color: Colors.grey[200],
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Get Insider Access",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "PlayfairDisplay",
                      color: Colors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                            height: 50,
                            color: Colors.white,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: _controller,
                                validator: (String value) {
                                  return validateEmail(value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Email to Subscribe",
                                  hintStyle: TextStyle(
                                      fontFamily: "Helvetica",
                                      color: Colors.grey[400],
                                      fontSize: 15),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey[200], width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey[200], width: 1.0),
                                  ),
                                ),
                              ),
                            ))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                        color: Colors.grey,
                        width: 40,
                        height: 49,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          iconSize: 25,
                          color: Colors.white,
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(FocusNode());
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              landingPageData.fetchSubscriptionData(_controller.text);
                              landingPageData.fetchSubscription.listen((event) {
                                if(event.error.isNotEmpty){
                                  scaffoldKey.currentState.removeCurrentSnackBar();
                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text("${event.error}"),
                                    duration: Duration(seconds: 2),
                                  ));
                                }
                                else{
                                  scaffoldKey.currentState.removeCurrentSnackBar();
                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text("${event.success}"),
                                    duration: Duration(seconds: 2),
                                  ));
                                  _controller.text="";
                                }
                              });


                            }

                          },
                        )),
                  )
                ],
              )
            ])));
  }

  validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null) {
      return Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            'Enter a valid email address',
          )));
      return;
    } else {
      return null;
    }
  }


  Widget lowerBanner(BuildContext context){
    return Padding(
        padding: EdgeInsets.only(top: 25,bottom: 70),
        child:  Container(
          width: double.infinity,
          height: 90 ,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: new AssetImage("images/shipping_banner.png")
                //Can use CachedNetworkImage
              ),
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0))),

        )
    )  ;


  }
}
