import 'dart:convert';
import 'dart:io';

import 'package:azaFashions/bloc/LoginBloc/RegisterationBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/bloc/PaymentBloc/PaymentBloc.dart';
import 'package:azaFashions/models/Payment/ShareFeedback.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/PROFILE/ProfileUI.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FeedBack extends StatefulWidget {
  @override
  FeedBackPage createState() => FeedBackPage();
}

class FeedBackPage extends State<FeedBack> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  String selectedOption="", suggestions = "", name, emailId, phoneNo;
  String answers="";
  UserLogin _userLogin = UserLogin();
  Map<String, String> map = {};
  String dialCode;
  bool validate = true;
  final connectivity = new ConnectivityService();
  var connectionStatus;
  String currencyCode;

  PhoneNumber number = PhoneNumber();
  String fNameError, emailError, mobError;

  int prevIndex = -1;
  List<bool> selected =[];
  @override
  void initState() {
    paymentBloc.getFeedback();
    regisBloc.clearData();
    beforeBuild();
    setState(() {
      currencyCode = IntroModelList.currency_iso_code;
      currencyCode == "INR"
          ? number =
          PhoneNumber(isoCode: "IN", dialCode: "+91", phoneNumber: phoneNo)
          : number = PhoneNumber();
    });
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("Feedback Page ");
    analytics.setCurrentScreen(screenName: "Feedback");

    super.initState();
  }

  beforeBuild() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userLogin = UserLogin.fromJson(jsonDecode(prefs.getString('userDetails')));
    setState(() {
      name = _userLogin.firstname + " " + _userLogin.lastname;
      emailId = _userLogin.email;
      phoneNo = _userLogin.mobile;
      print("Phone No $phoneNo");
      // phoneNo = "8879143993";

      if (phoneNo != "") {
        validate = true;
      }
      nameController = TextEditingController(text: name);
      emailController = TextEditingController(text: emailId);
      mobileController = TextEditingController(text: phoneNo);
    });
    print(name);
    print(emailId);
    print(phoneNo);
  }

  @override
  void dispose() {
    connectivity.dispose();
    paymentBloc.clearFeedback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS
        ? connectivity.checkConnectivity1()
        : Provider.of<ConnectivityStatus>(context);

    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar:
          AppBarWidget().myAppBar(context, "Give Us Feedback", scaffoldKey),
          drawer: Drawer(
              child: SideNavigation(
                title: "FeedBack",
              )),
          // resizeToAvoidBottomPadding: false,
          body: connectionStatus.toString() != "ConnectivityStatus.Offline"
              ? StreamBuilder<ShareFeedback>(
              stream: paymentBloc.fetchFeedback,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return ScrollConfiguration(
                      behavior: new ScrollBehavior()
                        ..buildViewportChrome(
                            context, null, AxisDirection.down),
                      child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 20),
                              child: Container(
                                width: double.infinity,
                                height: 250,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new CachedNetworkImageProvider(
                                            snapshot.data.bannerImage)
                                      //Can use CachedNetworkImage
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0))),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(top: 0, left: 20, right: 20),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      "At Aza, we are constantly trying to improve our merchandise and customer service. We would like to hear your feedback and any recommendations you may have on our online shopping experience. ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Helvetica",
                                          color: HexColor("#666666")))),
                            ),
                            Container(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.questions.length,
                                  itemBuilder: (context, int index) {
                                    return Column(
                                      children: [
                                        Column(
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 15,
                                                    bottom: 10),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: snapshot
                                                          .data
                                                          .questions[index]
                                                          .question,
                                                      // textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          fontFamily: "Helvetica",
                                                          color: Colors.black),
                                                      children: <TextSpan>[
                                                        index<3 || snapshot
                                                            .data
                                                            .questions[
                                                        index]
                                                            .field ==
                                                            "name" || snapshot
                                                            .data
                                                            .questions[
                                                        index]
                                                            .field ==
                                                            "email"?TextSpan(
                                                            text: '*',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                Colors.red)):TextSpan(),
                                                      ],
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   snapshot.data.questions[index]
                                                  //       .question,
                                                  //   textAlign: TextAlign.left,
                                                  //   style: TextStyle(
                                                  //       fontSize: 15,
                                                  //       fontWeight:
                                                  //           FontWeight.normal,
                                                  //       fontFamily: "Helvetica",
                                                  //       color: Colors.black),
                                                  // ),
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                  left: 5,
                                                  right: 5,
                                                ),
                                                child: (snapshot
                                                    .data
                                                    .questions[index]
                                                    .type ==
                                                    "radio")
                                                    ? ListView.builder(
                                                    physics:
                                                    NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data
                                                        .questions[index]
                                                        .answers
                                                        .length,
                                                    itemBuilder:
                                                        (context, int i) {
                                                      return Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            bottom: 5),
                                                        child: addRadioButton(
                                                            snapshot.data
                                                                .questions,
                                                            snapshot
                                                                .data
                                                                .questions[
                                                            index]
                                                                .answers,
                                                            snapshot
                                                                .data
                                                                .questions[
                                                            index]
                                                                .answers[i]
                                                                .id,
                                                            snapshot
                                                                .data
                                                                .questions[
                                                            index]
                                                                .answers[i]
                                                                .title,
                                                            index),
                                                      );
                                                    })
                                                    : snapshot
                                                    .data
                                                    .questions[index]
                                                    .type ==
                                                    "select"
                                                    ? Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          left: 15,
                                                          right:
                                                          15),
                                                      child: Container(
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width -
                                                            50,
                                                        padding: const EdgeInsets
                                                            .only(
                                                            left: 10.0,
                                                            right:
                                                            10.0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                6.0),
                                                            color: Colors
                                                                .transparent,
                                                            border: Border
                                                                .all()),
                                                        child:
                                                        DropdownButtonHideUnderline(
                                                          child:
                                                          new DropdownButton<
                                                              String>(
                                                            hint: selectedOption ==
                                                                null
                                                                ? Text(
                                                                'Please Select An Option')
                                                                : Text(
                                                              selectedOption,
                                                              style:
                                                              TextStyle(color: Colors.black),
                                                            ),
                                                            items: snapshot
                                                                .data
                                                                .questions[
                                                            index]
                                                                .answers
                                                                .map(
                                                                    (value) {
                                                                  return new DropdownMenuItem<
                                                                      String>(
                                                                    value: value
                                                                        .value,
                                                                    child: new Text(
                                                                        value.title),
                                                                  );
                                                                }).toList(),
                                                            onChanged:
                                                                (value) {
                                                              setState(
                                                                      () {
                                                                    selectedOption =
                                                                        value;
                                                                  });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                    : snapshot
                                                    .data
                                                    .questions[
                                                index]
                                                    .type ==
                                                    "textbox"
                                                    ? Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 15,
                                                      right:
                                                      15),
                                                  child: Container(
                                                    padding:
                                                    EdgeInsets
                                                        .all(0),
                                                    height: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .height *
                                                        0.09,
                                                    child:
                                                    TextFormField(
                                                      onChanged:
                                                          (String
                                                      value) {
                                                        suggestions =
                                                            value;
                                                      },
                                                      onFieldSubmitted:
                                                          (String
                                                      va) {
                                                        FocusScope.of(
                                                            context)
                                                            .requestFocus();
                                                      },
                                                      textInputAction:
                                                      TextInputAction
                                                          .done,
                                                      keyboardType:
                                                      TextInputType
                                                          .text,
                                                      maxLines: 3,
                                                      decoration:
                                                      InputDecoration(
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .black),
                                                        enabledBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              color: Colors.grey),
                                                        ),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              color: Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    : snapshot
                                                    .data
                                                    .questions[
                                                index]
                                                    .type ==
                                                    "text"
                                                    ? snapshot
                                                    .data
                                                    .questions[
                                                index]
                                                    .field ==
                                                    "name"
                                                    ? Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      left:
                                                      15,
                                                      right:
                                                      15),
                                                  child: Container(
                                                      height: MediaQuery.of(context).size.height * 0.05,
                                                      child: StreamBuilder<String>(
                                                          stream: regisBloc.name,
                                                          builder: (context, snapshot) {
                                                            fNameError = snapshot.error;
                                                            // print(fNameError);
                                                            return TextFormField(
                                                              controller: nameController,
                                                              onChanged: (String val) {
                                                                setState(() {
                                                                  ProfileUI.isEdited = true;
                                                                });
                                                                regisBloc.nameChanged(val);
                                                              },
                                                              inputFormatters: [
                                                                WhitelistingTextInputFormatter(
                                                                    RegExp(r"[a-zA-Z]+|\s"))
                                                              ],
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontFamily: "Helvetica",
                                                              ),
                                                              // initialValue: snapshot.data.questions[index].field == "name" ? name : "",
                                                              decoration: InputDecoration(
                                                                  enabledBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.black),
                                                                  ),
                                                                  focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.black),
                                                                  ),
                                                                  errorText: snapshot.error),
                                                            );
                                                          })),
                                                )
                                                    : snapshot.data.questions[index].field ==
                                                    "email"
                                                    ? Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15,
                                                      right: 15),
                                                  child: Container(
                                                      height: MediaQuery.of(context).size.height * 0.05,
                                                      child: StreamBuilder<String>(
                                                          stream: regisBloc.email,
                                                          builder: (context, snapshot) {
                                                            emailError = snapshot.error;
                                                            // print(emailError);
                                                            return TextFormField(
                                                              controller: emailController,
                                                              onChanged: (String val) {
                                                                setState(() {
                                                                  ProfileUI.isEdited = true;
                                                                });
                                                                regisBloc.emailChanged(val);
                                                              },
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontFamily: "Helvetica",
                                                              ),
                                                              decoration: InputDecoration(
                                                                  enabledBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.black),
                                                                  ),
                                                                  focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.black),
                                                                  ),
                                                                  errorText: snapshot.error),
                                                            );
                                                          })),
                                                )
                                                    : snapshot.data.questions[index].field ==
                                                    "phone_no"
                                                    ? Padding(
                                                  padding: const EdgeInsets.only(top: 20.0, left: 10),
                                                  child: InternationalPhoneNumberInput(
                                                    errorMessage: validate?null:"Invalid Phone Number",
                                                    onInputChanged: (PhoneNumber number) {
                                                      setState(() {
                                                        if (mobileController.text == "") {
                                                          currencyCode = "";
                                                          validate = true;
                                                          // FocusScope.of(context).requestFocus(FocusNode());
                                                        }
                                                        dialCode = number.dialCode;

                                                        SelectorConfig(
                                                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                                        );
                                                      });
                                                    },
                                                    onInputValidated: (bool value) {
                                                      print("Value $value");
                                                      setState(() {
                                                        if(mobileController.text=="" && value == false){
                                                          validate = true;
                                                          FocusScope.of(context).requestFocus(FocusNode());
                                                        }
                                                        else{
                                                          validate = value;
                                                        }
                                                      });

                                                      print(validate);
                                                    },
                                                    selectorConfig: currencyCode == ""
                                                        ? SelectorConfig(
                                                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                                    )
                                                        : SelectorConfig(
                                                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                                    ),
                                                    ignoreBlank: false,
                                                    onSubmit: () {
                                                      FocusScope.of(context).requestFocus(new FocusNode());
                                                    },
                                                    autoValidateMode: AutovalidateMode.onUserInteraction,
                                                    selectorTextStyle: TextStyle(color: Colors.black),
                                                    initialValue: number,
                                                    textFieldController: mobileController,
                                                    formatInput: false,

                                                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                                                    onSaved: (PhoneNumber number) {
                                                      print('On Saved: $number');
                                                    },
                                                  ),
                                                )
                                                    : Container()
                                                    : Container()),
                                          ],
                                        ),
                                        snapshot.data.questions[index].field !=
                                            "name" ||
                                            snapshot.data.questions[index]
                                                .field !=
                                                "email" ||
                                            snapshot.data.questions[index]
                                                .field !=
                                                "phone_no"
                                            ? Padding(
                                          padding: EdgeInsets.only(
                                              top: 20,
                                              left: 15,
                                              right: 15,
                                              bottom: 10),
                                          child: Divider(
                                            thickness: 1,
                                          ),
                                        )
                                            : Center(),
                                      ],
                                    );
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(snapshot.data.note,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Helvetica",
                                          color: HexColor("#666666")))),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: RichText(text: TextSpan(
                                    text: "(Note:  ",style: TextStyle(fontSize: 15.5,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Helvetica",
                                    color: HexColor("#666666")),
                                    children: [
                                      TextSpan(
                                          text: "*  ",style: TextStyle(color: Colors.red)
                                      ),
                                      TextSpan(
                                          text: "fields are mandatory fields)",style: TextStyle(fontSize: 15.5,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Helvetica",
                                          color: HexColor("#666666"))
                                      )
                                    ]
                                )),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 15,
                                  bottom: Platform.isIOS ? 25 : 10,
                                ),
                                child: Container(
                                    color: HexColor("#e0e0e0"),
                                    width: MediaQuery.of(context).size.width / 1,
                                    height: 43,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        snapshot.data.questions
                                            .forEach((element) {
                                          element.answers.forEach((elem) {
                                            if (elem.selectedValue != null) {
                                              answers = elem.selectedValue;
                                            }
                                          });
                                          print(element.answered);
                                          if (selected.length>2 && fNameError == null && emailError == null) {


                                            if (element.type == 'radio') {
                                              if(element.answered && answers!=""){
                                                map['${element.field}'] = answers;
                                              }
                                              else{
                                                map['${element.field}'] = "";
                                              }

                                            }
                                            if (element.type == "select") {
                                              map['${element.field}'] = selectedOption!=null?selectedOption:"";
                                            }
                                            if (element.type == "textbox") {
                                              map['${element.field}'] =
                                                  suggestions;
                                            }
                                            if (element.type == "text") {
                                              if (element.field == 'name') {
                                                map['${element.field}'] =
                                                    nameController.text;
                                              }
                                              if (element.field == 'email') {
                                                map['${element.field}'] =
                                                    emailController.text;
                                              }
                                              if (element.field == 'phone_no') {
                                                if (mobileController.text != "") {
                                                  if(currencyCode==""){
                                                    map['${element.field}'] = "${dialCode.replaceAll("+", "").trim()}${mobileController.text}";
                                                  }
                                                  else{
                                                    map['${element.field}'] = "${mobileController.text}";
                                                  }
                                                } else {
                                                  map['${element.field}'] = "";
                                                }
                                              }
                                            }

                                          } else {
                                            ToastMsg().getFailureMsg(context,
                                                "Please answer the mandatory fields");
                                          }
                                        });
                                        print(map);

                                        if (map.isNotEmpty) {
                                          paymentBloc.recordFeedback(map);
                                          paymentBloc.sendFeedback
                                              .listen((event) {
                                            if (event.success.isNotEmpty) {
                                              if (mounted) {
                                                Future.delayed(
                                                    Duration(seconds: 1), () {
                                                  Navigator.of(context).pop();
                                                });
                                              }
                                              WebEngagePlugin.trackEvent(
                                                  "Feedback Page => Status :${event.success}");
                                            }
                                          });
                                        }
                                      },
                                      child: Text(
                                        'SUBMIT',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ))),
                          ])));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
              : ErrorPage(
            appBarTitle: "You are offline.",
          )),
    );
  }

  Widget addRadioButton(List<Questions> questions, List<Answers> answers,
      int btnValue, String title, int index) {
    // print(btnValue);
    return Container(
      height: 40,
      child: RadioListTile(
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: "Helvetica",
              color: Colors.black),
        ),
        activeColor: Colors.black,
        value: questions[index].answers[btnValue].value,
        groupValue: questions[index].grpValue,
        onChanged: (value) {
          setState(() {

            if(index != prevIndex){
              if(index<3){
                selected.add(true);
              }
            }
            questions[index].grpValue = value;
            answers[index].selectedValue = value;
            questions[index].answered = true;
            print(index);
            prevIndex = index;
          });
          print(selected);
        },
      ),
    );
  }
}
