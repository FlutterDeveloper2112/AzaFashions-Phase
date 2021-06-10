import 'dart:io';import 'dart:convert';
import 'package:azaFashions/bloc/LoginBloc/LoginBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/PROFILE/FeedBack.dart';
import 'package:azaFashions/ui/OrderModule/OrderScreen.dart';
import 'package:azaFashions/ui/PROFILE/ADDRESS/MyAddress.dart';
import 'package:azaFashions/ui/PROFILE/AccoutDetails.dart';
import 'package:azaFashions/ui/PROFILE/AzaLoyaltyPoints.dart';
import 'package:azaFashions/ui/PROFILE/ChangePassword.dart';
import 'package:azaFashions/ui/PROFILE/EmailSubscription.dart';
import 'package:azaFashions/ui/PROFILE/MyAzaWallet.dart';
import 'package:azaFashions/ui/PROFILE/MyMeasurements.dart';
import 'package:azaFashions/ui/PROFILE/MyWishlist.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ProfileUI extends StatefulWidget {
  final ScrollController controller;

  static bool isEdited=false;
  const ProfileUI({Key key, this.controller}) : super(key: key);
  @override
  _ProfileUIPageState createState() => _ProfileUIPageState();
}

class _ProfileUIPageState extends State<ProfileUI> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  String userName = "";
  bool guest = false;
  UserLogin _userLogin = UserLogin();
  SessionDetails sessionDetails = new SessionDetails();
  final connectivity=new ConnectivityService();
  var connectionStatus;


  Future<void> beforeBuild() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("browseAsGuest"));
    if (prefs.getBool("browseAsGuest")) {
      setState(() {
        guest = prefs.getBool("browseAsGuest");
      });
      CustomBottomSheet().getLoginBottomSheet(context);
      setState(() {
        userName = "Guest User";
      });
    } else {
      setState(() {
        _userLogin=UserLogin.fromJson(jsonDecode(prefs.getString('userDetails')));
        guest = prefs.getBool("browseAsGuest");
        userName = _userLogin.firstname + " " + _userLogin.lastname;
      });

    }
  }

  @override
  void dispose() {
    print("DISPOSE CALLED");
    connectivity.dispose();
    super.dispose();
  }


  @override
  void initState() {
  //  beforeBuild();
    super.initState();
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("Profile Page");
    analytics.setCurrentScreen(screenName: "Profile Page");

  }
  @override
  void didChangeDependencies() {
    beforeBuild();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ProfileUI oldWidget) {
    beforeBuild();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
      connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
      return RefreshIndicator(
      onRefresh: beforeBuild,
      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            // resizeToAvoidBottomPadding: false,
            body: Stack(
              children: [
                ListView(
                  controller: widget.controller,
                  children: <Widget>[
                    getListData(context),
                  ],
                ),
                if (guest)
                  Container(
                    // height: double.infinity,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.white.withOpacity(0.7),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                  )
              ],
            )),
      ),
    );
  }

  Widget getListData(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            color: Colors.grey[300],
            height: 65,
            child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Hi, $userName',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "PlayfairDisplay",
                          color: Colors.black)),
                ))),
        //Account Details
        InkWell(
            onTap: () async{
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){

                bool result= await Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new AccountDetails();
                }));
                if(result==true){
                  print("ACC RESULT: $result");
                  beforeBuild();
                }
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }
            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Account Details',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),
        //WIshlist
        InkWell(
            onTap: () {
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new MyWishList();
                }));
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }

            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('My Wishlist',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),
        //Orders
        InkWell(
            onTap: () {
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new OrderScreen();
                }));
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }

            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('My Orders',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),
        //Measurement
        InkWell(
            onTap: () {
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new MyMeasurements();
                }));
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }

            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('My Measurement',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),
        //Aza Wallet
        InkWell(
            onTap: () {
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new AzaWallet();
                }));
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }

            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('My Aza Wallet',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),
        //Aza Loyalty Points
        InkWell(
            onTap: () {
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new AzaLoyalty();
                }));
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }

            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Aza Loyalty Points',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),
        //Address
        InkWell(
            onTap: () {
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new MyAddress();
                }));
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }

            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('My Addresses',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),
        InkWell(
            onTap: () {
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new FeedBack();
                }));
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }

            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Share Feedback',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),
        //Invite Friends Phase II
        /* InkWell(
            onTap: () {

              Navigator.pop(context);
            },
            child: Container(
                padding: EdgeInsets.only(left:20,right: 15,top: 10,bottom: 5),
                height: 50,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Invite Friends',style:TextStyle(fontSize:15,fontFamily:"Helvetica" ,color:Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child:  new Icon(Icons.arrow_forward_ios,size: 15,color: Colors.grey[400],),
                    )
                  ],
                ))
        ),*/
        Padding(
          padding: EdgeInsets.all(5),
        ),
        //Settings
        InkWell(
            onTap: () {
              //  Navigator.pop(context);
            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('SETTINGS',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ],
                ))),
        //Push Notifications
      /*  InkWell(

            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Push Notifications',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),*/
        //Email SUbscription
        InkWell(
            onTap: () {
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new EmailSubscription();
                }));
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }
            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Email Subscription',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 10,
          child: Divider(),
        ),
        //CHange Password
        InkWell(
            onTap: () {
              if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new ChangePass();
                }));
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
              }

            },
            child: Container(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 5),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Change Password',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ))),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        //SHop Preference
        /*InkWell(
            onTap: () {
              *//*    Navigator.pop(context);*//*
            },
            child: Container(
                padding: EdgeInsets.only(left: 20, right: 15, top: 10),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('SHOP PREFERENCE',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Helvetica",
                              color: Colors.black)),
                    ),
                  ],
                ))),
        Padding(
            padding: EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            child: Row(children: <Widget>[
              addRadioButton(0, 'Women'),
              addRadioButton(1, 'Men'),
              addRadioButton(2, 'Show Me Everything')
            ])),
        */
        //SignOut

        Padding(
            padding: EdgeInsets.only(top:10,left:25,right:25,bottom:25),
            child: Container(

              width: double.infinity,
              height:45,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.grey[300],
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0))),
                onPressed: () {
                  if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                    loginBloc.getLogout(context);
                    loginBloc.fetchLogout.listen((event) async{
                      if (event.success!=null) {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("${event.success}")));
                        SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
                        int counter=_sharedPreferences.getInt("guestCounter");
                        _sharedPreferences.remove("XTrailId");
                        _sharedPreferences.remove("CustomerId");
                        sessionDetails.browseAsGuest(true);
                        BagCount.wishlistCount.value=0;
                        BagCount.bagCount.value=0;
                        if(counter!=null && counter==1){
                          sessionDetails.browseAsGuestCounter(counter+1);
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => MainHome()));
                        }
                        else{
                          sessionDetails.browseAsGuest(true);
                          sessionDetails.browseAsGuestCounter(1);
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => MainHome()));
                        }
/*
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        SystemNavigator.pop();
                      });*/
                      }
                      print(event);
                    });
                    sessionDetails.loginStatus(false);
                  }
                  else{
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
                  }


                },
                child: Text(
                  'SIGN OUT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Helvetica",
                      color: Colors.black,
                      fontSize: 15),
                ),
                color: Colors.grey[300],
              ),
            )),
        SizedBox(height: 50,)
      ],
    );
  }

  List gender = ["Women", "Men", "Show Me Everything"];

  String select;

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Colors.black,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(
          "$title",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 11,
              fontFamily: "Helvetica",
              color: Colors.black54),
        ),
      ],
    );
  }
}
