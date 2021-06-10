import 'dart:io';
import 'dart:convert';
import 'package:azaFashions/bloc/ProfileBloc/MeasurementBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Profile/MeasurementList.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/PROFILE/Measurements/NewMeasurements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'ProfileUI.dart';

class MyMeasurements extends StatefulWidget {
  @override
  _MyMeasurementsState createState() => _MyMeasurementsState();
}

class _MyMeasurementsState extends State<MyMeasurements> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserLogin _userLogin;
  String genderValue;
  final connectivity = new ConnectivityService();
  var connectionStatus;

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    measurementBloc.clearMeasurementData();
    measurementBloc.getMeasurements();
    setState(() {
      getUserDetails();
    });
    analytics.setCurrentScreen(screenName: "My Measurement");
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("MEASUREMENT JSON: ${prefs.getString('userDetails').toString()}");
    _userLogin = UserLogin.fromJson(jsonDecode(prefs.getString('userDetails')));
  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS
        ? connectivity.checkConnectivity1()
        : Provider.of<ConnectivityStatus>(context);
    // connectionStatus.toString() != "ConnectivityStatus.Offline"
    //     ? measurementBloc.getMeasurements()
    //     : "";
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar:
          AppBarWidget().myAppBar(context, "My Measurements", scaffoldKey),
          drawer: Drawer(
              child: SideNavigation(
                title: "My Measurements",
              )),
          body: connectionStatus.toString() != "ConnectivityStatus.Offline"
              ? RefreshIndicator(
              child: StreamBuilder<MeasurementList>(
                  stream: measurementBloc.measurementDetails,
                  builder:
                      (context, AsyncSnapshot<MeasurementList> snapshot) {
                    print("Connection State ${snapshot.connectionState}");
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data.measurements.isNotEmpty) {
                        return Padding(
                            padding: EdgeInsets.all(2),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount:
                                    snapshot.data.measurements.length,
                                    itemBuilder: (context, index) {
                                      MaleMeasurement maleMeasurement;
                                      FrontMeasurements frontMeasurement;
                                      BackMeasurements backMeasurement;
                                      if (snapshot.data.measurements[index]
                                          .gender ==
                                          "Male") {
                                        maleMeasurement = snapshot
                                            .data
                                            .measurements[index]
                                            .maleMeasurement;
                                        print(maleMeasurement);
                                      } else {
                                        frontMeasurement = snapshot
                                            .data
                                            .measurements[index]
                                            .measurementDetails
                                            .frontBody;
                                        backMeasurement = snapshot
                                            .data
                                            .measurements[index]
                                            .measurementDetails
                                            .backBody;
                                      }

                                      return SingleChildScrollView(
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        child: ExpansionTile(
                                          title: Text(
                                            snapshot.data.measurements[index]
                                                .title ??
                                                "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: "Helvetica"),
                                          ),
                                          onExpansionChanged:
                                              (bool expand) {},
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      color: Colors.grey[350],
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(5.0),
                                                        child: Text(
                                                          "Front Measurements (in inches)",
                                                          style: TextStyle(
                                                              fontSize: 15.5,
                                                              fontFamily:
                                                              "Helvetica",
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            snapshot.data.measurements[index]
                                                .gender ==
                                                "Male"
                                                ? GridView.count(
                                              childAspectRatio: 3 / 2,
                                              crossAxisCount: 3,
                                              shrinkWrap: true,
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              children: [
                                                buildCell(
                                                    "Chest",
                                                    maleMeasurement
                                                        .chest),
                                                buildCell(
                                                    "Front Neck ",
                                                    maleMeasurement
                                                        .waist
                                                        .toString()),
                                                buildCell(
                                                    "Shoulder Length",
                                                    maleMeasurement.hips
                                                        .toString()),
                                                buildCell(
                                                    "Short Sleeve Length",
                                                    maleMeasurement
                                                        .shoulderLength
                                                        .toString()),
                                              ],
                                            )
                                                : GridView.count(
                                              childAspectRatio: 3 / 2,
                                              crossAxisCount: 3,
                                              shrinkWrap: true,
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              children: [
                                                buildCell(
                                                    "Cap Sleeve Length",
                                                    frontMeasurement
                                                        .capSleeveLength
                                                        .toString()),
                                                buildCell(
                                                    "Front Neck ",
                                                    frontMeasurement
                                                        .frontNeck
                                                        .toString()),
                                                buildCell(
                                                    "Shoulder Length",
                                                    frontMeasurement
                                                        .shoulderLength
                                                        .toString()),
                                                buildCell(
                                                    "Short Sleeve Length",
                                                    frontMeasurement
                                                        .shortSleeveLength
                                                        .toString()),
                                                buildCell(
                                                    "Bust",
                                                    frontMeasurement
                                                        .bust
                                                        .toString()),
                                                buildCell(
                                                    "Under-Bust",
                                                    frontMeasurement
                                                        .underBust
                                                        .toString()),
                                                buildCell(
                                                    "Sleeve Length",
                                                    frontMeasurement
                                                        .sleeveLength
                                                        .toString()),
                                                buildCell(
                                                    "Waist",
                                                    frontMeasurement
                                                        .waist
                                                        .toString()),
                                                buildCell(
                                                    "Hips",
                                                    frontMeasurement
                                                        .hips
                                                        .toString()),
                                              ],
                                            ),
                                            if (snapshot
                                                .data
                                                .measurements[index]
                                                .gender !=
                                                "Male")
                                              Wrap(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                            color: Colors
                                                                .grey[350],
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  8.0),
                                                              child: Text(
                                                                "Back Measurements (in inches)",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    fontFamily:
                                                                    "Helvetica",
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                  GridView.count(
                                                    childAspectRatio: 3 / 2,
                                                    crossAxisCount: 3,
                                                    shrinkWrap: true,
                                                    physics:
                                                    NeverScrollableScrollPhysics(),
                                                    children: [
                                                      buildCell(
                                                          "Neck",
                                                          backMeasurement.neck
                                                              .toString()),
                                                      buildCell(
                                                          "Shoulder to Apex ",
                                                          backMeasurement
                                                              .shoulderApex
                                                              .toString()),
                                                      buildCell(
                                                          "Back Neck Depth",
                                                          backMeasurement
                                                              .backNeckDepth
                                                              .toString()),
                                                      buildCell(
                                                          "Bicep",
                                                          backMeasurement
                                                              .bicep
                                                              .toString()),
                                                      buildCell(
                                                          "Elbow Round",
                                                          backMeasurement
                                                              .elbowRound
                                                              .toString()),
                                                      buildCell(
                                                          "Knee Length",
                                                          backMeasurement
                                                              .kneeLength
                                                              .toString()),
                                                      buildCell(
                                                          "Bottom Length",
                                                          backMeasurement
                                                              .bottomLength
                                                              .toString()),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      await measurementBloc
                                                          .removeMeasurement(
                                                          snapshot
                                                              .data
                                                              .measurements[
                                                          index]
                                                              .id);
                                                      await refreshData();
                                                    },
                                                    child: Text(
                                                      "REMOVE",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                          "Helvetica",
                                                          fontWeight:
                                                          FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 10),
                                                    child: Container(
                                                      color: Colors.black,
                                                      height: 18,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 10),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await Navigator
                                                            .push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    NewMeasurement(
                                                                      isEdit:
                                                                      true,
                                                                      measurements:
                                                                      snapshot.data.measurements[index],
                                                                      userlogin:
                                                                      _userLogin,
                                                                    )));
                                                        await refreshData();
                                                      },
                                                      child: Text(
                                                        "EDIT",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                            "Helvetica",
                                                            fontWeight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                lowerHalf(context)
                              ],
                            ));
                      } else {
                        return Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.2),
                                child: ErrorPage(
                                  appBarTitle: "No Measurements Found!",
                                )),
                            Center(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 45,
                                          right: 45,
                                          top: 15,
                                          bottom: 25),
                                      child: Container(
                                        color: HexColor("#e0e0e0"),
                                        width:
                                        MediaQuery.of(context).size.width / 1,
                                        height: 40,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            await Navigator.of(context)
                                                .push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                                  return NewMeasurement(
                                                    isEdit: false,
                                                    userlogin: _userLogin,
                                                  );
                                                }));
                                             await refreshData();
                                          },
                                          child: Text(
                                            'ADD NEW MEASUREMENT',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Helvetica",
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                      )),
                                ))
                          ],
                        );
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              onRefresh: refreshData)
              : ErrorPage(
            appBarTitle: "You are offline.",
          )),
    );
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    if (mounted) {
      setState(() {
        setState((){
          ProfileUI.isEdited=false;
        });
        measurementBloc.getMeasurements();
      });
    }
  }

  Widget lowerHalf(BuildContext context) {
    return Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
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
                    await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return NewMeasurement(
                        isEdit: false,
                        userlogin: _userLogin,
                      );
                    }));
                    await refreshData();
                  },
                  child: Text(
                    'ADD NEW MEASUREMENT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              )),
        ));
  }

  Container buildCell(String title, String measurement) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xfff5f5f5),
          border: Border.all(color: Colors.grey[300], width: 0.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Helvetica"),
          ),
          Text(
            measurement,
            style: TextStyle(fontFamily: "Helvetica", color: Colors.black),
          )
        ],
      ),
    );
  }
}
