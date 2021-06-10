import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:azaFashions/bloc/LoginBloc/RegisterationBloc.dart';
import 'package:azaFashions/bloc/LoginBloc/SocialLoginBloc.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/models/Login/SocialLoginModel.dart';
import 'package:azaFashions/networkprovider/LoginProvider.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/HOME/IntroScreens/afss_start_shopping.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afov_otpverification.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsi_signin.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  bool _passwordVisible, _cpasswordVisible;
  TextEditingController passcontroller = new TextEditingController();
  LoginProvider apiProvider = new LoginProvider();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var connectionStatus;
  final connectivity = new ConnectivityService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'In';
  PhoneNumber number = PhoneNumber();
  String mob;
  String mobError="";
  SessionDetails sessionDetails = SessionDetails();
  bool validate = false;
  String currencyCode;
  String dialCode;
  bool isSuccess = false;
  @override
  void initState() {

    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    // connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    analytics.setCurrentScreen(screenName: "Sign Up");
    _passwordVisible = false;
    _cpasswordVisible = false;
    apiProvider.logout_google();
    apiProvider.logout_facebook();

    sessionDetails.browseAsGuest(false);
    setState(() {
      currencyCode=IntroModelList.currency_iso_code;
      number = currencyCode=="INR"?PhoneNumber(isoCode: "IN",dialCode: "+91"):PhoneNumber();
      // number.phoneNumber="+91";
      //   print("Number: ${number} ${number.phoneNumber}");
    });
    WebEngagePlugin.trackScreen("Sign Up Screen");
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }


    super.initState();
  }

  @override
  void dispose() {
    regisBloc.clearData();
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StartShoppingUI())),
      child:MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                upperHalf(context),
                Expanded(
                    flex: 7, child: Form(key: formKey, child: formUI(context))),
                Expanded(child: lowerHalf(context)),
              ],
            )),
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
        Center(
          child: Container(
              height: 100,
              padding: EdgeInsets.only(top: 15, left: 25),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                      fontFamily: "PlayfairDisplay",
                      color: Colors.black),
                ),
              )),
        )
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
                    "Already have an account? ",
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
                              builder: (BuildContext context) => LoginPage()));
                    },
                    child: Text(
                      " SIGN IN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontFamily: "Helvetica",
                          color: Colors.black),
                    ),
                  )
                ],
              )),
        ));
  }

  Widget formUI(BuildContext context) {
    return ScrollConfiguration(
        behavior: new ScrollBehavior()
          ..buildViewportChrome(context, null, AxisDirection.down),
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //UsernameField
                Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Name ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.grey[500]),
                        ),
                      ),
                      StreamBuilder<String>(
                          stream: regisBloc.name,
                          builder: (context, snapshot) => TextFormField(
                            onChanged: regisBloc.nameChanged,
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(
                                    RegExp(r"[a-zA-Z]+|\s"))
                              ],
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorText: snapshot.error),
                          ))
                    ])),
                //EmailField
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 25, right: 25),
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
                          stream: regisBloc.email,
                          builder: (context, snapshot) => TextFormField(
                            onChanged: regisBloc.emailChanged,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorText: snapshot.error),
                          ))
                    ])),
                //PasswordField
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 25, right: 25),
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
                          stream: regisBloc.newPassword,
                          builder: (context, snapshot) {
                            print(
                                "registration password ${regisBloc.upperValidate} ${regisBloc.specialValidate} ${regisBloc.numericValidate} ${regisBloc.lengthValidate}");
                            return TextFormField(
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
                                ));
                          })
                    ])),
                StreamBuilder(
                    stream: regisBloc.newPassword,
                    builder: (context, snapshot) {
                      return Row(
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
                                          : Colors.grey[500]),
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
                                          : Colors.grey[500]),
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
                                          : Colors.grey[500]),
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
                                          : Colors.grey[500]),
                                ),
                              ),
                            )
                          ]);
                    }),
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
                                obscureText: !_cpasswordVisible,
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
                                      if (_cpasswordVisible == false) {
                                        setState(() {
                                          _cpasswordVisible = true;
                                        });
                                      } else {
                                        setState(() {
                                          _cpasswordVisible = false;
                                        });
                                      }
                                    },
                                    onLongPress: () {
                                      if (_cpasswordVisible == false) {
                                        setState(() {
                                          _cpasswordVisible = true;
                                        });
                                      } else {
                                        setState(() {
                                          _cpasswordVisible = false;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      _cpasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black,
                                    ),
                                  ),
                                ));
                          })
                    ])),

                //MobileNoField
                Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mobile No. ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.grey[500]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0,left:10),
                        child: InternationalPhoneNumberInput(
                          // errorMessage: validate?null:"Invalid Phone Number",
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              currencyCode = "";
                              dialCode = number.dialCode;
                              // number.dialCode="+93";
                              SelectorConfig(
                                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              );
                            });
                            if (number.dialCode == "+91") {
                              setState(() {

                                currencyCode = "INR";
                              });
                            }
                          },
                          onInputValidated: (bool value) {
                            print("Value $value");
                            setState(() {
                              validate=value;
                            });
                          },
                          selectorConfig:currencyCode==""?SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ):SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          onSubmit: () {
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          selectorTextStyle: TextStyle(color: Colors.black),
                          initialValue: number,
                          textFieldController: controller,
                          formatInput: false,
                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),

                      )
                    ])),
                //TermsAndConditions
                Padding(
                    padding:
                    EdgeInsets.only(left: 25, right: 15, top: 10, bottom: 10),
                    child: Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "By creating an account you agree with our",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.grey[500]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            WebViewContainer(
                                                "https://www.azaFashions.com/terms-and-conditions?tag=web_view",
                                                "Terms & Conditions",
                                                "TERMS")));
                              },
                              child: Text(
                                "Terms & Conditions ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    fontFamily: "Helvetica",
                                    color: Colors.black),
                              ),
                            ),
                            Text(
                              "and ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Helvetica",
                                  color: Colors.grey[500]),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            WebViewContainer(
                                                "https://www.azaFashions.com/security-privacy?tag=web_view",
                                                "Privacy Policy",
                                                "POLICY")));
                              },
                              child: Text(
                                " Privacy Policy",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 15,
                                    fontFamily: "Helvetica",
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                    ])),
                //SignUpButton
                Padding(
                    padding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 25),
                    child: Container(
                        color: HexColor("#e0e0e0"),
                        width: MediaQuery.of(context).size.width / 1,
                        height: 40,
                        child: StreamBuilder<bool>(
                          stream: regisBloc.loginCheck,
                          builder: (context, snapshot) => RaisedButton(
                            onPressed: () async {
                              regisBloc.clearRegisterStream();
                              bool validationStatus = await regisBloc.validateBeforeSubmitting(context,validate);
                              print("snapshot data:$validationStatus");
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (validationStatus) {
                                if (connectionStatus.toString() !=
                                    "ConnectivityStatus.Offline") {
                                  print(snapshot.hasData);
                                  if (snapshot.hasData) {
                                    regisBloc.fetchAllRegisData("${dialCode.replaceAll("+", "").trim()}${controller.text}");
                                    regisBloc.fetchAllData.listen((value) {
                                      if (value.error!="" || value.error.isNotEmpty) {
                                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.error)));
                                      } else {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (BuildContext context) {
                                                  print("VALUE : SIGN TRUE ${value.error}");
                                                  return MainHome();
                                                }));
                                        /*Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext context) {
                                                  return OTP(value.mobile);
                                                }));*/
                                      }
                                    });
                                  }

                                } else {
                                  scaffoldKey.currentState.removeCurrentSnackBar();
                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                          "No Internet Connection. Please Try Again.")));
                                }
                              }
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
                                  color: Colors.grey),
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
                            padding: EdgeInsets.only(left: 10, top: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                //height: 50,
                                child: StreamBuilder<SocialLoginModel>(
                                    stream: null,
                                    builder: (context,
                                        AsyncSnapshot<SocialLoginModel> socialModel) =>
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
                                                    if(value.error==""){
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

                                                          sessionDetails.loginStatus(true);
                                                          scaffoldKey.currentState
                                                              .removeCurrentSnackBar();
                                                          scaffoldKey.currentState
                                                              .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Facebook Login Successful.")));

                                                          return changeThePage(context);
                                                        }
                                                      });
                                                    }
                                                    else{
                                                      scaffoldKey.currentState
                                                          .removeCurrentSnackBar();
                                                      scaffoldKey.currentState
                                                          .showSnackBar(SnackBar(
                                                          content: Text(
                                                              value.error)));

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
                                              // if (connectionStatus.toString() != "ConnectivityStatus.Offline") {
                                              //   print("ENTERED");
                                              //   SocialLoginModel login = SocialLoginModel();
                                              //   if (!(socialModel.hasData)) {
                                              //     sociallogin_bloc.fetchFacebookLoginData();
                                              //     sociallogin_bloc.fetchfbData.listen((value) {
                                              //       if (value.error.isNotEmpty) {
                                              //         scaffoldKey.currentState
                                              //             .showSnackBar(SnackBar(
                                              //           content: Text("Facebook Login Failed."),
                                              //         ));
                                              //       } else {
                                              //         setState(() {
                                              //           login = value;
                                              //         });
                                              //         sociallogin_bloc
                                              //             .fetchSocialData
                                              //             .listen((value) {
                                              //           if (value.error.isNotEmpty) {
                                              //             return scaffoldKey
                                              //                 .currentState
                                              //                 .showSnackBar(
                                              //                 SnackBar(
                                              //                   content: Text(
                                              //                       "Faceboook Login Failed."),
                                              //
                                              //                 ));
                                              //
                                              //           } else {
                                              //             scaffoldKey.currentState
                                              //                 .showSnackBar(SnackBar(
                                              //                 content: Text(
                                              //                     "Facebook Login Successful.")));
                                              //             sociallogin_bloc
                                              //                 .fetchSocialLoginData(
                                              //                 login);
                                              //             return changeThePage(
                                              //                 context);
                                              //           }
                                              //         });
                                              //       }
                                              //     });
                                              //   }
                                              //
                                              // }
                                              // else {
                                              //   scaffoldKey.currentState
                                              //       .removeCurrentSnackBar();
                                              //   scaffoldKey.currentState
                                              //       .showSnackBar(SnackBar(
                                              //       content: Text(
                                              //           "No Internet Connection. Please Try Again.")));
                                              // }
                                            },
                                            padding: EdgeInsets.all(0.0),
                                            child: Image.asset(
                                                "images/facebook.png"))))),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 5,
                              right: 10,
                            ),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 3,
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
                                                  sociallogin_bloc.fetchGoogleLoginData();
                                                  sociallogin_bloc.fetchgoogleData.listen((value) {
                                                    sociallogin_bloc.fetchSocialLoginData(value);
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
                                                        sessionDetails.loginStatus(true);
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
                                            child: Image.asset(
                                                "images/google.png"))))),
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
            )));
  }

  changeThePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return MainHome();
    }));
  }
}
