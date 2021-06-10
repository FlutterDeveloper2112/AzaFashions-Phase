import 'dart:async';
import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart';
import 'package:azaFashions/bloc/LoginBloc/LoginBloc.dart';
import 'package:azaFashions/bloc/LoginBloc/SocialLoginBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/networkprovider/LoginProvider.dart';
import 'package:azaFashions/models/Login/SocialLoginModel.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/HOME/IntroScreens/afss_start_shopping.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/affp_fogotpassword.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsu_signup.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  bool _passwordVisible;
  bool checkedValue = true;
  LoginProvider apiProvider = new LoginProvider();
  SessionDetails sessionDetails = SessionDetails();
  SharedPreferences sharedPreferences;
  String savedEmail;
  String savedPassword;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var connectionStatus;
  final connectivity = new ConnectivityService();

  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "Sign In");
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    setState(() {
      checkedValue = true;
    });
    // checkLoggedInState();
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }

    _passwordVisible = false;
    Future.delayed(Duration(seconds: 0), () async {
      print("Entered Future");
      await getLoginData();
    });
    print("InitState called");

    apiProvider.logout_google();
    apiProvider.logout_facebook();
    sessionDetails.browseAsGuest(false);

    WebEngagePlugin.trackScreen("Sign In Screen");
    super.initState();
  }

  @override
  void dispose() {
    loginBloc.clearData();
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS
        ? connectivity.checkConnectivity1()
        : Provider.of<ConnectivityStatus>(context);
    print("connnextions :$connectionStatus");
    return WillPopScope(
      onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StartShoppingUI())),
      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: <Widget>[
              upperHalf(context),
              Expanded(
                  flex: 9,
                  child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: formUI(context))),
              Expanded(
                flex: 1,
                child: lowerHalf(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15, top: 15),
          child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  StartShoppingUI()));
                    },
                    child: Platform.isAndroid
                        ? Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 18,
                    )
                        : Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 18,
                    ),
                  ))),
        ),
        Container(
            height: 100,
            padding: EdgeInsets.only(top: 15, left: 25),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "PlayfairDisplay",
                    fontWeight: FontWeight.normal,
                    fontSize: 22,
                    color: Colors.black),
              ),
            ))
      ],
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don’t have an account? ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Helvetica",
                        color: Colors.grey[600]),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => SignUp()));
                    },
                    child: Text(
                      'SIGN UP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  )
                ],
              )),
        ));
  }

  Widget formUI(BuildContext context) {
    return Column(
      children: <Widget>[
        //UsernameField
        Padding(
            padding: EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 10),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Helvetica",
                      color: Colors.grey[500]),
                ),
              ),
              StreamBuilder<String>(
                  initialData: sharedPreferences.getString('UserEmail') != null
                      ? sharedPreferences.getString('UserEmail')
                      : "",
                  stream: loginBloc.email,
                  builder: (context, snapshot) {
                    return TextFormField(
                      key: Key(
                          sharedPreferences.getString('UserEmail').toString()),
                      initialValue: sharedPreferences.getString('UserEmail'),
                      onChanged: (String email) {
                        if (email == "") {
                          setState(() {
                            sharedPreferences.setString("UserEmail", "");
                            print(sharedPreferences
                                .getString('UserEmail')
                                .toString());
                          });
                        }
                        loginBloc.emailChanged(email);
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          errorText: snapshot.error),
                    );
                  })
            ])),
        //PasswordField
        Padding(
            padding: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Helvetica",
                      color: Colors.grey[500]),
                ),
              ),
              StreamBuilder<String>(
                  initialData: sharedPreferences.getString('UserPassword'),
                  stream: loginBloc.password,
                  builder: (context, snapshot) => TextFormField(
                      key: Key(sharedPreferences.getString('UserPassword')),
                      initialValue: sharedPreferences.getString('UserPassword'),
                      maxLength: 14,
                      obscureText: !_passwordVisible,
                      onChanged: (String password) {
                        if (password == "") {
                          setState(() {
                            sharedPreferences.setString("UserPassword", "");
                            print(sharedPreferences
                                .getString('UserPassword')
                                .toString());
                          });
                        }
                        loginBloc.passwordChanged(password);
                      },
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
        //ForgotPassword
        Padding(
            padding: EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 5),
                  child: new GestureDetector(
                    child: new Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: Colors.black,
                          value: checkedValue,
                          onChanged: (value) {
                            setState(() {
                              checkedValue = !checkedValue;
                            });
                          },
                        ),
                        new Text(
                          'Remember Me',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        print("checkValue: $checkedValue");
                        checkedValue = !checkedValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ForgotPassword()));
                  },
                  child: Padding(
                      padding: EdgeInsets.only(right: 10, top: 2, bottom: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      )),
                )
              ],
            )),
        //SignInButton
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 25),
            child: Container(
                color: HexColor("#e0e0e0"),
                width: MediaQuery.of(context).size.width / 1,
                height: 40,
                child: StreamBuilder<bool>(
                  stream: loginBloc.loginCheck,
                  builder: (context, snapshot) => RaisedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      print("COnnection Status:${connectionStatus.toString()}");
                      if (connectionStatus.toString() !=
                          "ConnectivityStatus.Offline") {
                        if ((sharedPreferences.getString('UserEmail') != null &&
                            sharedPreferences.getString('UserEmail') !=
                                "") &&
                            (sharedPreferences.getString('UserPassword') !=
                                null &&
                                sharedPreferences.getString('UserPassword') !=
                                    "")) {
                          await loginBloc.fetchAllLoginData(
                              sharedPreferences.getString('UserEmail'),
                              sharedPreferences.getString('UserPassword'),
                              checkedValue);
                          loginBloc.fetchAllData.listen((value) {
                            if (value.error.isNotEmpty && value.error != "") {
                              print("SIGN IN ${value.error}");
                              ToastMsg()
                                  .getLoginSuccess(context, "${value.error}");

                              //   sessionDetails.clearLoginDetails();
                            } else {
                              ToastMsg().getLoginSuccess(
                                  context, "Login Successful.");

                              sessionDetails.loginStatus(true);

                              if (mounted) {
                                Future.delayed(Duration(seconds: 1), () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            print("VALUE : SIGN TRUE ${value.error}");
                                            return MainHome();
                                          }));
                                });
                              }
                            }
                          });
                        } else {
                          bool validationStatus =
                          await loginBloc.validateBeforeSubmitting(context);

                          if (validationStatus) {
                            if (snapshot.hasData) {
                              await loginBloc.fetchAllLoginData(
                                  "", "", checkedValue);
                              loginBloc.fetchAllData.listen((value) {
                                if (value.error.isNotEmpty) {
                                  ToastMsg()
                                      .getFailureMsg(context, "${value.error}");
                                } else {
                                  ToastMsg().getFailureMsg(
                                      context, "Login Successful");
                                  sessionDetails.loginStatus(true);
                                  Future.delayed(Duration(seconds: 1), () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              print("VALUE : SIGN TRUE ${value.error}");
                                              return MainHome();
                                            }));
                                    ;
                                  });
                                }
                              });
                            }
                          }
                        }
                      } else {
                        scaffoldKey.currentState.removeCurrentSnackBar();
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                "No Internet Connection. Please Try Again.")));
                      }
                    },
                    child: Text(
                      'SIGN IN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ))),
        //ContinueWith
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            child: Divider(
              color: Colors.black,
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Or continue with",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Helvetica",
                          color: Colors.grey[500]),
                    ),
                  ))),
          Expanded(
            child: Divider(
              color: Colors.black,
            ),
          ),
        ]),
        //SocialLoginButtons
        Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 5, top: 5),
                    child: Container(
                        width: Platform.isIOS
                            ? MediaQuery.of(context).size.width / 3.5
                            : MediaQuery.of(context).size.width / 3,
                        //height: 50,
                        child: StreamBuilder<SocialLoginModel>(
                            stream: null,
                            builder: (context,
                                AsyncSnapshot<SocialLoginModel>
                                socialModel) =>
                                FlatButton(
                                    onPressed: () {
                                      if (connectionStatus.toString() !=
                                          "ConnectivityStatus.Offline") {
                                        print("ENTERED");
                                        if (!(socialModel.hasData)) {
                                          sociallogin_bloc
                                              .fetchFacebookLoginData();
                                          sociallogin_bloc.fetchfbData
                                              .listen((value) {
                                            print('VALUE ${value.error}');
                                            if (value.error == "") {
                                              sociallogin_bloc
                                                  .fetchSocialLoginData(value);
                                              sociallogin_bloc.fetchSocialData
                                                  .listen((value) {
                                                if (value.error.isNotEmpty) {
                                                  scaffoldKey.currentState
                                                      .removeCurrentSnackBar();
                                                  scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "${value.error}")));
                                                } else {
                                                  sessionDetails
                                                      .loginStatus(true);
                                                  scaffoldKey.currentState
                                                      .removeCurrentSnackBar();
                                                  scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Facebook Login Successful.")));

                                                  return changeThePage(context);
                                                }
                                              });
                                            } else {
                                              scaffoldKey.currentState
                                                  .removeCurrentSnackBar();
                                              scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                  content:
                                                  Text(value.error)));
                                            }
                                          });
                                        }
                                      } else {
                                        scaffoldKey.currentState
                                            .removeCurrentSnackBar();
                                        scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "No Internet Connection. Please Try Again.")));
                                      }
                                    },
                                    padding: EdgeInsets.all(0.0),
                                    child:
                                    Image.asset("images/facebook.png"))))),
                Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      right: 10,
                    ),
                    child: Container(
                        padding: EdgeInsets.only(left: 5),
                        width: Platform.isIOS
                            ? MediaQuery.of(context).size.width / 3.5
                            : MediaQuery.of(context).size.width / 3,
                        //  height: 50,
                        child: StreamBuilder<SocialLoginModel>(
                            stream: null,
                            builder: (context,
                                AsyncSnapshot<SocialLoginModel>
                                socialModel) =>
                                FlatButton(
                                    onPressed: () {
                                      if (connectionStatus.toString() !=
                                          "ConnectivityStatus.Offline") {
                                        if (!(socialModel.hasData)) {
                                          sociallogin_bloc
                                              .fetchGoogleLoginData();
                                          sociallogin_bloc.fetchgoogleData
                                              .listen((value) {
                                            sociallogin_bloc
                                                .fetchSocialLoginData(value);
                                            sociallogin_bloc.fetchSocialData
                                                .listen((value) {
                                              if (value.error.isNotEmpty) {
                                                scaffoldKey.currentState
                                                    .removeCurrentSnackBar();
                                                scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Google Login Failed.")));
                                              } else {
                                                sessionDetails
                                                    .loginStatus(true);
                                                scaffoldKey.currentState
                                                    .removeCurrentSnackBar();
                                                scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Google Login Successful.")));
                                                return changeThePage(context);
                                              }
                                            });
                                          });
                                        }
                                      } else {
                                        scaffoldKey.currentState
                                            .removeCurrentSnackBar();
                                        scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "No Internet Connection. Please Try Again.")));
                                      }
                                    },
                                    padding: EdgeInsets.all(0.0),
                                    child: Image.asset("images/google.png"))))),
              ],
            )),
         Platform.isIOS? Padding(
            padding: EdgeInsets.only(left: 90,right: 90),
            child: Container(

                width: MediaQuery.of(context).size.width /1,
                height: 35,
                child: StreamBuilder<SocialLoginModel>(
                    stream: null,
                    builder: (context,
                        AsyncSnapshot<SocialLoginModel> socialModel) =>

                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          child:
                          Image.asset("images/apple.png"),
                          onPressed: () {
                            if (connectionStatus.toString() !=
                                "ConnectivityStatus.Offline") {
                              sociallogin_bloc.disposeApple();
                              sociallogin_bloc.fetchAppleLoginData();

                              sociallogin_bloc.fetchAppleData.listen((event) {
                                if (event.error == null || event.error == "") {
                                  sociallogin_bloc.fetchSocialLoginData(event);

                                  sociallogin_bloc.fetchSocialData
                                      .listen((value) {
                                    if (value.error.isNotEmpty) {
                                      scaffoldKey.currentState
                                          .removeCurrentSnackBar();
                                      scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text("${value.error}")));
                                    } else {
                                      sessionDetails.loginStatus(true);
                                      scaffoldKey.currentState
                                          .removeCurrentSnackBar();
                                      scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Apple Login Successful.")));

                                      return changeThePage(context);
                                    }
                                  });
                                } else {
                                  scaffoldKey.currentState
                                      .removeCurrentSnackBar();
                                  scaffoldKey.currentState.showSnackBar(
                                      SnackBar(content: Text(event.error)));
                                }
                              });
                            } else {
                              scaffoldKey.currentState
                                  .removeCurrentSnackBar();
                              scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "No Internet Connection. Please Try Again.")));
                            }
                          },

                        )))) :Center(),
      ],
    );
  }

  getLoginData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (sharedPreferences.getBool("Remember") != false &&
          sharedPreferences.getBool("Remember") != null) {
        savedEmail = sharedPreferences.getString('UserEmail');
        savedPassword = sharedPreferences.getString('UserPassword');
        checkedValue = sharedPreferences.getBool("Remember");
        print(savedEmail);
        print(savedPassword);
      } else {
        checkedValue = true;
        savedEmail = "";
        savedPassword = "";
      }
    });
  }

  changeThePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return MainHome();
    }));
  }


}
