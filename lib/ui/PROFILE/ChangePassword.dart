import 'dart:io';import 'package:azaFashions/bloc/LoginBloc/RegisterationBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afov_otpverification.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PROFILE/MyWishlist.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ChangePass extends StatefulWidget {
  @override
  ChangePassState createState() => ChangePassState();
}

class ChangePassState extends State<ChangePass> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  bool _passwordVisible,_oldPasswordVisible,_confirmPasswordVisible;
  TextEditingController passcontroller = new TextEditingController();
  final connectivity=new ConnectivityService();
  var connectionStatus;


  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    regisBloc.clearData();
    setState(() {
      _passwordVisible = false;
      _oldPasswordVisible = false;
      _confirmPasswordVisible = false;

    });
    analytics.setCurrentScreen(screenName: "Change Password");
    WebEngagePlugin.trackScreen("Change Password Page ");




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
          appBar:
          AppBarWidget().myAppBar(context, "Change Password", scaffoldKey),
          drawer: Drawer(
              child: SideNavigation(
                title: "Change Password",
              )),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  //OLD PASSWORD
                  Padding(
                      padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                      child: Column(children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Old Password*",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Helvetica",
                                color: Colors.black54),
                          ),
                        ),
                        StreamBuilder<String>(
                            stream: regisBloc.oldPassword,
                            builder: (context, snapshot) {
                              return TextFormField(
                                  maxLength: 14,
                                  obscureText: !_oldPasswordVisible,
                                  onChanged: regisBloc.oldPasswordChanged,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    counter: Offstage(),

                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    errorText: snapshot.error,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        if (_oldPasswordVisible == false) {
                                          setState(() {
                                            _oldPasswordVisible = true;
                                          });
                                        } else {
                                          setState(() {
                                            _oldPasswordVisible = false;
                                          });
                                        }
                                      },
                                      onLongPress: () {
                                        if (_oldPasswordVisible == false) {
                                          setState(() {
                                            _oldPasswordVisible = true;
                                          });
                                        } else {
                                          setState(() {
                                            _oldPasswordVisible = false;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        _oldPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ));
                            })
                      ])),

                  //NEW PASSWORD
                  Padding(
                      padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                      child: Column(children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "New Password* ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Helvetica",
                                color: Colors.black54),
                          ),
                        ),
                        StreamBuilder<String>(
                            stream: regisBloc.newPassword,
                            builder: (context, snapshot) => TextFormField(
                                maxLength: 14,
                                obscureText: !_passwordVisible,
                                onChanged: regisBloc.newPasswordChanged,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  counter: Offstage(),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  errorText: snapshot.error,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      if (_passwordVisible == false) {
                                        setState(() {
                                          _passwordVisible = true;
                                        });
                                      } else {
                                        setState(() {
                                          _passwordVisible = false;
                                        });
                                      }
                                    },
                                    onLongPress: () {
                                      if (_passwordVisible == false) {
                                        setState(() {
                                          _passwordVisible = true;
                                        });
                                      } else {
                                        setState(() {
                                          _passwordVisible = false;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black,
                                    ),
                                  ),
                                )))
                      ])),
                  StreamBuilder(
                    stream: regisBloc.newPassword,
                    builder: (context, snapshot) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              color: regisBloc.lengthValidate
                                  ? Colors.lightGreen[100]
                                  : Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                "8 characters",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: "Helvetica",
                                    color: regisBloc.lengthValidate
                                        ? Colors.lightGreen
                                        : Colors.grey[400]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              color: regisBloc.specialValidate
                                  ? Colors.lightGreen[100]
                                  : Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                "1 Special",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: "Helvetica",
                                    color: regisBloc.specialValidate
                                        ? Colors.lightGreen
                                        : Colors.grey[400]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              color: regisBloc.upperValidate
                                  ? Colors.lightGreen[100]
                                  : Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                "1 Uppercase",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: "Helvetica",
                                    color: regisBloc.upperValidate
                                        ? Colors.lightGreen
                                        : Colors.grey[400]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              color: regisBloc.numericValidate
                                  ? Colors.lightGreen[100]
                                  : Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                "1 Numeric",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: "Helvetica",
                                    color: regisBloc.numericValidate
                                        ? Colors.lightGreen
                                        : Colors.grey[400]),
                              ),
                            ),
                          )
                        ]),
                  ),

                  //CONFIRM PASSWORD
                  Padding(
                      padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                      child: Column(children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Confirm Password* ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Helvetica",
                                color: Colors.black54),
                          ),
                        ),
                        StreamBuilder<String>(
                            stream: regisBloc.confirmPassword,
                            builder: (context, snapshot) {
                              return TextFormField(
                                  maxLength: 14,
                                  obscureText: !_confirmPasswordVisible,
                                  onChanged: regisBloc.confirmPasswordChanged,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    counter: Offstage(),

                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    errorText: snapshot.error,

                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        if (_confirmPasswordVisible == false) {
                                          setState(() {
                                            _confirmPasswordVisible = true;
                                          });
                                        } else {
                                          setState(() {
                                            _confirmPasswordVisible = false;
                                          });
                                        }
                                      },
                                      onLongPress: () {
                                        if (_confirmPasswordVisible == false) {
                                          setState(() {
                                            _confirmPasswordVisible = true;
                                          });
                                        } else {
                                          setState(() {
                                            _confirmPasswordVisible = false;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        _confirmPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ));
                            })
                      ])),

                  Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 25, bottom: 25),
                      child: Container(
                          color: Colors.grey[400],
                          width: MediaQuery.of(context).size.width / 1,
                          height: 43,
                          child: StreamBuilder<bool>(
                            stream: regisBloc.passwordCheck,
                            builder: (context, snapshot) => RaisedButton(
                              onPressed: () {
                                if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                                  if (snapshot.hasData) {
                                    regisBloc.changePassword(context);
                                    regisBloc.fetchPassword.listen((value) {
                                    value.error.isNotEmpty
                                        ? print("ERROR ${value}")
                                        : Navigator.of(context).pop();


                                    });
                                  }
                                }
                                else{
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
                                }

                              },
                              child: Text(
                                'CHANGE PASSWORD',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ),
                          ))),
                ],
              ))),
      );
  }
}
