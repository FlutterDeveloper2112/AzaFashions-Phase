import 'dart:io';

import 'package:azaFashions/bloc/LoginBloc/RegisterationBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _passwordVisible;
  FirebaseAnalytics analytics = FirebaseAnalytics();
  var connectionStatus;
  final connectivity=new ConnectivityService();
  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "Reset Password");
    // ignore: unnecessary_statements

    connectivity.connectionStatusController;
    regisBloc.clearData();
    _passwordVisible = false;
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
        key:scaffoldKey,
        appBar: AppBarWidget().myAppBar(context, "Reset Password", scaffoldKey),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "New Password*",
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
                ],
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm Password*",
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
                            // onChanged: regisBloc.oldPasswordChanged,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              counter: Offstage(),
                              errorText: snapshot.error,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ));
                      })
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 25, bottom: 25),
                child: Container(
                    color: HexColor("#e0e0e0"),
                    width: MediaQuery.of(context).size.width / 1,
                    height: 50,
                    child: StreamBuilder<bool>(
                      stream: regisBloc.passwordCheck,
                      builder: (context, snapshot) => RaisedButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if(connectionStatus!=null && connectionStatus.toString()!="ConnectivityStatus.Offline"){
                            if (snapshot.hasData) {
                              regisBloc.changePassword(context);
                              regisBloc.fetchAllData.listen((value) {
                                if(value.error.isNotEmpty){
                                  scaffoldKey.currentState.removeCurrentSnackBar();
                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text("${value.error}"),
                                    duration: Duration(seconds: 1),
                                  ));
                                }
                                else{

                                  scaffoldKey.currentState.removeCurrentSnackBar();
                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text("Password Updated Successfully."),
                                    duration: Duration(seconds: 1),
                                  ));
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {return MainHome();}));
                                }
                              });
                            }
                            else{

                              scaffoldKey.currentState.removeCurrentSnackBar();
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Please Enter Your Email-Id."),
                                duration: Duration(seconds: 1),
                              ));
                            }
                          }
                          else{
                            scaffoldKey.currentState.removeCurrentSnackBar();
                            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No Internet Connection. Please Try Again.")));
                          }

                        },
                        child: Text(
                          'RESET PASSWORD',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
