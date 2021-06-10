import 'dart:io';
import 'package:azaFashions/bloc/ProfileBloc/ProfileBloc.dart';
import 'package:azaFashions/bloc/LoginBloc/RegisterationBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PROFILE/ProfileUI.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AccountDetails extends StatefulWidget {
  @override
  AccountDetailsState createState() => AccountDetailsState();
}

class AccountDetailsState extends State<AccountDetails> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  String fName;
  String lName;
  String email;
  String mob;
  String dob = "";
  String genderValue;
  String select;
  List<String> gender = ["Others", "Male", "Female"];

  String fNameError, lNameError, emailError, mobError;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final connectivity = new ConnectivityService();
  var connectionStatus;
  bool isEditable =true;

  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "Account Details");
    setState(() {
      isEditable=true;
      ProfileUI.isEdited = false;
    });
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("Account Details Page");
    profilebloc.getAccountDetails();

    super.initState();
  }

  @override
  void dispose() {
    regisBloc.fetchAccountData.drain();
    regisBloc.clearData();
    connectivity.dispose();
    super.dispose();
  }

  getDetails() {
    profilebloc.accountDetails.listen((event) {
      if (mounted) {
        setState(() {
          fName = event.firstname;
          lName = event.lastname;
          email = event.email;
          mob = event.mobile;
          if (event.dob == "0000-00-00") {
            dob = "";
          } else {
            dob = event.dob;
          }

          print("GENDER: ${event.gender}");
          select = gender[int.parse(event.gender)];
          genderValue = gender.indexOf(select).toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    getDetails();
    connectionStatus = Platform.isIOS
        ? connectivity.checkConnectivity1()
        : Provider.of<ConnectivityStatus>(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (ProfileUI.isEdited) {
          bool res = await CustomBottomSheet().saveChanges(context);
          if (res) {
            Navigator.of(context).pop(true);
          }
        }
        else{
          Navigator.of(context).pop(true);
        }
      },

      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,

            // resizeToAvoidBottomPadding: true,
            key: scaffoldKey,
            appBar:
            AppBarWidget().myAppBar(context, "Account Details", scaffoldKey),
            drawer: Drawer(
                child: SideNavigation(
                  title: "Account Details",
                )),
            body: StreamBuilder<UserLogin>(
                stream: profilebloc.accountDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return Column(children: <Widget>[
                      Expanded(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(children: <Widget>[
                                //Name
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 25, top: 15),
                                    child: Column(children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'First Name',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Helvetica",
                                                color: Colors.black54),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                        //
                                        // child: Text(
                                        //   "First Name *",
                                        //   textAlign: TextAlign.start,
                                        //   style: TextStyle(
                                        //       fontSize: 15,
                                        //       fontFamily: "Helvetica",
                                        //       color: Colors.black54),
                                        // ),
                                      ),
                                      StreamBuilder<String>(
                                          initialData: snapshot.data.firstname,
                                          stream: regisBloc.name,
                                          builder: (context, snapshot) {
                                            fNameError = snapshot.data;
                                            return TextFormField(
                                              key: Key(fName.toString()),
                                              initialValue: fName,
                                              onChanged: (String val) {
                                                setState(() {
                                                  ProfileUI.isEdited = true;
                                                });
                                                regisBloc.nameChanged(val);
                                              },
                                              keyboardType: TextInputType.text,
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter(
                                                    RegExp(r"[a-zA-Z]+|\s"))
                                              ],
                                              // controller: fNme,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  errorText: snapshot.error),
                                            );
                                          })
                                    ])),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 25, top: 5),
                                    child: Column(children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Last Name',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Helvetica",
                                                color: Colors.black54),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      StreamBuilder<String>(
                                          initialData: snapshot.data.lastname,
                                          stream: regisBloc.lastName,
                                          builder: (context, snapshot) {
                                            lNameError = snapshot.data;
                                            return TextFormField(
                                              key: Key(lName.toString()),
                                              initialValue: lName,
                                              onChanged: (String val) {
                                                setState(() {
                                                  ProfileUI.isEdited = true;
                                                });
                                                regisBloc.lastNameChanged(val);
                                              },
                                              keyboardType: TextInputType.text,
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter(
                                                    RegExp(r"[a-zA-Z]+|\s"))
                                              ],
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  errorText: snapshot.error),
                                            );
                                          })
                                    ])),
                                //Mobile No
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 25, top: 5),
                                    child: Column(children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Mobile No.',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Helvetica",
                                                color: Colors.black54),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      StreamBuilder<String>(
                                          initialData: snapshot.data.mobile,
                                          stream: regisBloc.mobile,
                                          builder: (context, snapshot) {
                                            mobError = snapshot.data;
                                            return TextFormField(
                                              initialValue: mob,
                                              onChanged: (String val) {
                                                setState(() {
                                                  ProfileUI.isEdited = true;
                                                });
                                                regisBloc.mobileChanged(val);
                                              },
                                              keyboardType: TextInputType.number,

                                              inputFormatters: [
                                                WhitelistingTextInputFormatter(
                                                    RegExp(r"[0-9]"))
                                              ],
                                              // initialValue: mob,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  errorText: snapshot.error),
                                            );
                                          })
                                    ])),
                                //EMAIL
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 20, right: 25),
                                    child: Column(children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Email',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Helvetica",
                                                color: Colors.black54),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      StreamBuilder<String>(
                                          initialData: snapshot.data.email,
                                          stream: regisBloc.email,
                                          builder: (context, snapshot) {
                                            emailError = snapshot.data;
                                            return TextFormField(
                                              initialValue: email,
                                              onChanged: (String val) {
                                                setState(() {
                                                  ProfileUI.isEdited = true;
                                                });
                                                regisBloc.emailChanged(val);
                                              },
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  errorText: snapshot.error),
                                            );
                                          })
                                    ])),
                                //Date OF Birth
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 25, left: 20, right: 25),
                                    child: Column(children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Date of Birth   (Optional)",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Helvetica",
                                              color: Colors.black54),
                                        ),
                                      ),
                                      StreamBuilder(
                                          initialData: snapshot.data.dob,
                                          stream: regisBloc.dateOfBirth,
                                          builder: (context, snapshot) {
                                            return TextFormField(
                                              initialValue:
                                              dob == "0000-00-00" ? "" : dob,
                                              onChanged: (String val) {
                                                setState(() {
                                                  ProfileUI.isEdited = true;
                                                });
                                                regisBloc.dob(val);
                                              },
                                              keyboardType: TextInputType.datetime,
                                              decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "Helvetica",
                                                      color: Colors.black54),
                                                  hintText: "Format : YYYY-MM-DD ",
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  focusedBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  errorText: snapshot.error),
                                            );
                                          })
                                    ])),
                                //Gender
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 25, left: 20, right: 25),
                                    child: Column(children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Gender',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Helvetica",
                                                color: Colors.black54),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ])),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, top: 5, right: 10),
                                    child: Row(children: <Widget>[
                                      addRadioButton(1, 'Male'),
                                      addRadioButton(2, 'Female'),
                                      addRadioButton(0, 'Other')
                                    ])),
                                Padding(
                                    padding: EdgeInsets.only(left: 20, right: 25),
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    )),
                              ]))),
                      lowerHalf(context),
                    ]);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
      ),
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Colors.black,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (String value) {
            setState(() {
              ProfileUI.isEdited = true;
              select = value;
              genderValue = btnValue.toString();
            });
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "$title",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 15, fontFamily: "Helvetica", color: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget lowerHalf(BuildContext context) {
    return StreamBuilder<bool>(
        stream: regisBloc.detailsCheck,
        builder: (context, snapshot) {
          return Center(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 25,
                        bottom: Platform.isIOS ? 25 : 10,
                      ),
                      child: Container(
                          color: Colors.grey[400],
                          width: MediaQuery.of(context).size.width / 1,
                          height: 43,
                          child: StreamBuilder<bool>(
                            stream: regisBloc.detailsCheck,
                            builder: (context, snapshot) => RaisedButton(
                              onPressed: () {
                                if(isEditable){
                                  setState((){
                                    isEditable=false;
                                  });
                                  regisBloc.clearAccountStream();
                                  if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    if (fNameError == null && lNameError == null && mobError == null && emailError == null) {
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content:
                                          Text("All fields are mandatory.")));
                                    }
                                    else if(fNameError == null){
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content:
                                          Text("Please enter your first name.")));
                                    }
                                    else if(lNameError == null){
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content:
                                          Text("Please enter your last name.")));
                                    }
                                    else if(mobError == null){
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content:
                                          Text("Please enter your mobile number.")));
                                    }
                                    else if(emailError == null){
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content:
                                          Text("Please enter your email address.")));
                                    }

                                    else {
                                      UserLogin userLogin = UserLogin(
                                          firstname: fName,
                                          lastname: lName,
                                          mobile: mob,
                                          email: email,
                                          dob: dob,
                                          gender: genderValue);
                                      regisBloc.updateUserDetails(userLogin);
                                      regisBloc.fetchAccountData.listen((event) {
                                        print(event.success);
                                        if (event.error.isNotEmpty) {
                                          setState((){
                                          isEditable=true;
                                          });
                                          }
                                          else{
                                            setState((){
                                              isEditable=false;
                                            });

                                          WebEngagePlugin.setUserFirstName(fName);
                                          WebEngagePlugin.setUserLastName(lName);
                                          WebEngagePlugin.setUserEmail(email);
                                          WebEngagePlugin.setUserPhone(mob);
                                          Navigator.of(context).pop(true);

                                        }
                                      });
                                    }
                                  }
                                  else{
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
                                  }
                                }

                              },
                              child: Text(
                                'SAVE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ),
                          ))),
                ),
              ));
        });
  }
}
