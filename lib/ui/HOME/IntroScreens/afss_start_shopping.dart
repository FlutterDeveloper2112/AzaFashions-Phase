import 'dart:io';
import 'package:azaFashions/bloc/LoginBloc/LoginBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsi_signin.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsu_signup.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class StartShoppingUI extends StatefulWidget {
  @override
  StartShoppingState createState() {
    return new StartShoppingState();
  }
}

class StartShoppingState extends State<StartShoppingUI> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  SessionDetails _sessionDetails = SessionDetails();
  String image="";
  String content="";
  String header="";
  var connectionStatus;
  final connectivity=new ConnectivityService();

  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "Start Shopping Page");
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen('Start Shopping Screen');

    loginBloc.getGuestDetails(context);
    Future.delayed(Duration(seconds: 0),() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        image = prefs.getString("img");
        content = prefs.getString("content");
        header = prefs.getString("header");
      });

    });
  
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
    print(content);
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
           resizeToAvoidBottomInset: false,
          body: connectionStatus!=null && connectionStatus.toString()!="ConnectivityStatus.Offline"?SafeArea(
            top:true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                 Container(
                   height: MediaQuery.of(context).size.height*0.65,
                   width:414,

                   child: _buildImage(
                          context,
                          image),

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child:
                    Column(
                      children: <Widget>[
                        _buildTitle(
                            context,
                            header),
                        _buildDescription(
                            context,
                            content),
                        _buildButtons(context),
                        _buildBrowseasGuest()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ):ErrorPage(
        appBarTitle: "You are offline.",
      )


      ),
    );
  }

  _buildImage(BuildContext context, String image) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image:CachedNetworkImageProvider(image),

            //Can use CachedNetworkImage
          ),
        ),
      ),
    );
  }

  _buildTitle(BuildContext context,String header) {
    return new Container(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5),
      width: double.infinity,
      child: new Column(
        children: <Widget>[
          new Text(header,textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "PlayfairDisplay",fontSize: 26.0,color: Colors.black),)
        ],
      ),
    );
  }

  _buildDescription(BuildContext context, String content,) {
    return new Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: new Column(
        children: <Widget>[
          new Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize:15,fontFamily: "Helvetica", color: Colors.black),
          ),
        ],
      ),
    );
  }

  _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 10, top: 10, bottom: 5),
            child: Container(
                width: MediaQuery.of(context).size.width /3,
                height: 40,
                child: RaisedButton(
                  onPressed: () {
                    WebEngagePlugin.trackScreen(
                        'Pressed on Sign In Button');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                    _sessionDetails.browseAsGuest(false);

                  },
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.black,
                  color: HexColor("#e0e0e0"),
                  child: new Text("SIGN IN",
                      style:
                      TextStyle(color: Colors.black, fontFamily: "Helvetica",fontWeight: FontWeight.normal)),
                ))),
        Padding(
            padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
            child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 40,
                child: RaisedButton(
                  onPressed: () {
                    WebEngagePlugin.trackScreen(
                        'Pressed on Registration Button');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );

                    _sessionDetails.browseAsGuest(false);

                  },
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.black,
                  color: HexColor("#e0e0e0"),
                  child: new Text("REGISTER",
                      style:
                      TextStyle(color: Colors.black, fontFamily: "Helvetica",fontWeight: FontWeight.normal)),
                ))),
      ],
    );
  }

  _buildBrowseasGuest() {
    return new Container(
      padding: const EdgeInsets.only(top: 12.0, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: new Column(
        children: <Widget>[
          InkWell(
            child: new Text(
              "BROWSE AS A GUEST",
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Helvetica",
                  color: Colors.black),
            ),
            onTap: () async{
              WebEngagePlugin.trackScreen(
                  'Pressed on Browse As Guest Button');

              SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
              int counter=_sharedPreferences.getInt("guestCounter");
              _sessionDetails.browseAsGuest(true);
              if(counter!=null && counter==1){
                _sessionDetails.clearSessionDetails();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MainHome()));
              }
              else{
                _sessionDetails.clearSessionDetails();
                _sessionDetails.browseAsGuest(true);
                _sessionDetails.browseAsGuestCounter(1);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MainHome()));
              }


            },
          )
        ],
      ),
    );
  }
}
