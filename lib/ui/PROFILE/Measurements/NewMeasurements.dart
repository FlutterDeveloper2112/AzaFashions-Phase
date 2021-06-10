import 'package:azaFashions/bloc/ProfileBloc/MeasurementBloc.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/models/Profile/MeasurementList.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PROFILE/ProfileUI.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/SupportDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

class NewMeasurement extends StatefulWidget {
  final Measurements measurements;
  UserLogin userlogin = UserLogin();
  final bool isEdit;

  NewMeasurement({Key key, this.measurements, this.isEdit, this.userlogin})
      : super(key: key);

  @override
  _NewMeasurementState createState() => _NewMeasurementState();
}

class _NewMeasurementState extends State<NewMeasurement> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String genderValue="";
  String select;

  String selectType;
  String measurementSelected;
  String error;
  List<String> gender = ["", "Male", "Female"];
  List<String> type = ["inch","centimeters"];

  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "New Measurements");
    setState(() {
      ProfileUI.isEdited =false;
    });
    if (widget.measurements != null) {
      setState(() {
        genderValue = gender.indexOf(widget.measurements.gender).toString();
        select = widget.measurements.gender;
      });
    } else {
      setState(() {
        print("MEASUREMENT GENDER: ${widget.userlogin.gender}");
        if (widget.userlogin.gender != "") {
          select = gender[int.parse(widget.userlogin.gender)];
          genderValue = gender.indexOf(select).toString();
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    measurementBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        appBar: AppBarWidget().myAppBar(context, "Add Measurements", scaffoldKey),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Measurement for",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontFamily: "Helvetica"),
                    ),
                  ),
                  StreamBuilder<String>(
                      initialData: widget.measurements != null
                          ? widget.measurements.title
                          : widget.userlogin != null
                          ? "${widget.userlogin.firstname}  ${widget.userlogin.lastname}"
                          : "",
                      stream: measurementBloc.measurementFor,
                      builder: (context, snapshot) {
                        return TextFormField(
                          initialValue: widget.measurements != null
                              ? widget.measurements.title
                              : widget.userlogin != null
                              ? "${widget.userlogin.firstname}  ${widget.userlogin.lastname}"
                              : "",
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontFamily: "Helvetica", color: Colors.black),
                          onChanged: (String val){
                            setState(() {
                              ProfileUI.isEdited = true;
                            });
                            measurementBloc.measurementForChanged(val);
                          },
                          enabled: widget.isEdit ? false : true,
                          decoration: InputDecoration(
                            errorText: snapshot.error,
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        );
                      }),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                    top: 15.0,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        addRadioButton(1, 'Male'),
                        addRadioButton(2, 'Female'),
                      ])),
            Padding(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Measurements are in inches.",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Helvetica",
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),

                  ],
                ),
              ),
              (genderValue != "1")?  Padding(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("FRONT MEASUREMENT GUIDE",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Helvetica",
                            color: Colors.black,
                            fontWeight: FontWeight.normal)),
                    Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            CustomBottomSheet().getMeasurementBottomSheet(
                                context,
                                "FRONT MEASUREMENT GUIDE",
                                "https://static3.azafashions.com/tr:w-200,dpr-2,e-sharpen/uploads/banner_templates/womenswear_front_new.jpg");
                          },
                        ))
                  ],
                ),
              ):Padding(
        padding: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("FRONT MEASUREMENT GUIDE",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Helvetica",
                    color: Colors.black,
                    fontWeight: FontWeight.normal)),
            Padding(
                padding: const EdgeInsets.only(left: 1),
                child: IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    CustomBottomSheet().getMeasurementBottomSheet(
                        context,
                        "FRONT MEASUREMENT GUIDE",
                        "https://static3.azafashions.com/tr:w-200,dpr-2,e-sharpen/uploads/banner_templates/menswear_front_new.jpg");
                  },
                ))
          ],
        ),
      ),
              if(genderValue=="1")
                menMeasurements(context),
              if(genderValue=="2")
                ...womenFrontMeasurement(context),
              if (genderValue != "1")
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("BACK MEASUREMENT GUIDE",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Helvetica",
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      Padding(
                          padding: const EdgeInsets.only(left: 1),
                          child: IconButton(
                            icon: Icon(Icons.info_outline),
                            onPressed: () {
                              CustomBottomSheet().getMeasurementBottomSheet(
                                  context,
                                  "BACK MEASUREMENT GUIDE",
                                  "https://static3.azafashions.com/tr:w-200,dpr-2,e-sharpen/uploads/banner_templates/womenswear_back_new.jpg");
                            },
                          ))
                    ],
                  ),
                ),
              if(genderValue=="2")...womenBackMeasurements(context),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 90,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey[400], width: 15)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                      "I need your help in my measurements.",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "PlayFairDisplay"),
                                      textAlign: TextAlign.center,
                                    )),
                                InkWell(
                                  onTap: () async {
                                    var whatsApp =
                                    await SupportDetails()
                                        .getWhatsAppDetails();
                                    // print(whatsApp);
                                    await launch(whatsApp);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    height: 40,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 2)),
                                    child: Center(
                                        child: Text(
                                          "CONTACT ME",
                                          style: TextStyle(fontFamily: "Helvetica"),
                                          textAlign: TextAlign.values[2],
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        StreamBuilder<bool>(
                            stream: genderValue == "1"
                                ? measurementBloc.maleMeasurements
                                : measurementBloc.measurements,
                            builder: (context, snapshot) {
                              return Container(
                                height: 43,
                                width: double.infinity,
                                child: RaisedButton(
                                  color: const Color(0xeee0e0e0),
                                  onPressed: () {
                                    print("DATa");
                                    print(snapshot.hasData);
                                    print(error);
                                    if (widget.isEdit) {
                                      if (error == null) {
                                        if (gender[int.parse(genderValue)] ==
                                            "Male") {
                                          measurementBloc.updateMeasurement(
                                              gender[int.parse(genderValue)],
                                              widget.measurements.id,
                                              widget.measurements.title,
                                              measurement: widget
                                                  .measurements.maleMeasurement);
                                        } else {
                                          print(gender[int.parse(genderValue)]
                                              .toLowerCase());
                                          measurementBloc.updateMeasurement(
                                              gender[int.parse(genderValue)]
                                                  .toLowerCase(),
                                              widget.measurements.id,
                                              widget.measurements.title,
                                              fMeasurements: widget.measurements
                                                  .measurementDetails.frontBody,
                                              bMeasurements: widget.measurements
                                                  .measurementDetails.backBody);

                                        }
                                        Navigator.pop(context);

                                      } else {
                                        scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Please Enter Details Properly")));
                                      }

                                    }
                                    else {

                                     /* if (error==null) {*/

                                       measurementBloc.addMeasurement(context,
                                            gender[int.parse(genderValue)],
                                            " ${widget.userlogin.firstname}  ${widget.userlogin.lastname}");
                                        WebEngagePlugin.trackEvent("My Measurement Page => Measurement Added : ${ gender[int.parse(genderValue)]},${widget.userlogin.firstname}");

                                        MeasurementBloc.errorMsg==""?Navigator.pop(context):null;

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
                              );
                            })
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFields(
      context, String text, stream, Function onChanged, initialData) {

    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.33,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontFamily: "Helvetica"),
            ),
          ),
          StreamBuilder<String>(
              initialData: initialData.toString(),
              stream: stream,
              builder: (context, snapshot) {
                error = snapshot.error;
                print(snapshot.error);
                return TextFormField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp(r'(^\-?\d*\.?\d*)')),
                    //  FilteringTextInputFormatter(RegExp(r'(^\d{0,3}(\.\d{1,2})?$)'),allow: true),
                  ],
                  initialValue: widget.measurements != null
                      ? initialData.toString()
                      : null,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  onChanged: (String val){
                    setState(() {
                      ProfileUI.isEdited = true;
                    });
                    onChanged(val);
                  },
                  maxLength: 5,
                  decoration: InputDecoration(
                    counter: Offstage(),
                    errorText: snapshot.error,
                    hintStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget menMeasurements(context){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTextFields(
                  context,
                  "Chest",
                  measurementBloc.chest,
                  measurementBloc.chestChanged,
                  widget.measurements != null
                      ? widget.measurements.maleMeasurement?.chest
                      : null),
              buildTextFields(
                  context,
                  "Waist",
                  measurementBloc.waist,
                  measurementBloc.waistChanged,
                  widget.measurements != null
                      ? widget.measurements.maleMeasurement?.waist
                      : null),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTextFields(
                  context,
                  "Hips",
                  measurementBloc.hips,
                  measurementBloc.hipsChanged,
                  widget.measurements != null
                      ? widget.measurements.maleMeasurement?.hips
                      : null),
              buildTextFields(
                  context,
                  "Shoulder Length",
                  measurementBloc.shoulderLength,
                  measurementBloc.shoulderLengthChanged,
                  widget.measurements != null
                      ? widget.measurements.maleMeasurement?.shoulderLength
                      : null),
            ],
          ),
        ),
      ],
    );

  }
  List<Widget> womenFrontMeasurement(context) {
    return[
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            buildTextFields(
                context,
                "Cap Sleeve Length",
                measurementBloc.capSleeveLength,
                measurementBloc.capSleeveLengthChanged,
                widget.measurements?.measurementDetails?.frontBody
                    ?.capSleeveLength ??
                    null),
            buildTextFields(
                context,
                "Front Neck",
                measurementBloc.frontNeck,
                measurementBloc.frontNeckChanged,
                widget.measurements?.measurementDetails?.frontBody
                    ?.frontNeck ??
                    null),
            // buildText(),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextFields(
                context,
                "Shoulder Length",
                measurementBloc.shoulderLength,
                measurementBloc.shoulderLengthChanged,
                widget.measurements?.measurementDetails?.frontBody
                    ?.shoulderLength ??
                    null),
            buildTextFields(
              context,
              "Short sleeve length",
              measurementBloc.shortSleeveLength,
              measurementBloc.shortSleeveLengthChanged,
              widget
                  .measurements
                  ?.measurementDetails
                  ?.frontBody
                  ?.shortSleeveLength ??
                  "",),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextFields(
                context,
                "Bust Size",
                measurementBloc.bustSize,
                measurementBloc.bustSizeChanged,
                widget.measurements?.measurementDetails?.frontBody?.bust ??
                    null),
            buildTextFields(
                context,
                "Under Bust Size",
                measurementBloc.underBustSize,
                measurementBloc.underBustSizeChanged,
                widget.measurements?.measurementDetails?.frontBody
                    ?.underBust ??
                    null),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextFields(
                context,
                "Sleeve length",
                measurementBloc.sleeveLength,
                measurementBloc.sleeveLengthChanged,
                widget.measurements?.measurementDetails?.frontBody
                    ?.sleeveLength ??
                    null),
            buildTextFields(
                context,
                "Waist",
                measurementBloc.waist,
                measurementBloc.waistChanged,
                widget.measurements?.measurementDetails?.frontBody?.waist ??
                    null),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextFields(
                context,
                "Hips",
                measurementBloc.hips,
                measurementBloc.hipsChanged,
                widget.measurements?.measurementDetails?.frontBody?.hips ??
                    null),
          ],
        ),
      )
    ];
  }

  List<Widget> womenBackMeasurements(context) {
    return [
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            buildTextFields(
                context,
                "Neck",
                measurementBloc.neck,
                measurementBloc.backNeckChanged,
                widget.measurements?.measurementDetails?.backBody?.neck ??
                    null),
            buildTextFields(
                context,
                "Shoulder to Apex",
                measurementBloc.shoulderApex,
                measurementBloc.shoulderApexChanged,
                widget.measurements?.measurementDetails?.backBody
                    ?.shoulderApex ??
                    null),
            // buildText(),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextFields(
                context,
                "Back neck depth",
                measurementBloc.backNeckDepth,
                measurementBloc.backNeckDepthChanged,
                widget.measurements?.measurementDetails?.backBody
                    ?.backNeckDepth ??
                    null),
            buildTextFields(
                context,
                "Biceps",
                measurementBloc.biceps,
                measurementBloc.bicepsChanged,
                widget.measurements?.measurementDetails?.backBody?.bicep ??
                    null),
            // buildText(),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextFields(
                context,
                "Elbow round",
                measurementBloc.elbowRound,
                measurementBloc.elbowChanged,
                widget.measurements?.measurementDetails?.backBody
                    ?.elbowRound ??
                    null),
            buildTextFields(
                context,
                "Knee length",
                measurementBloc.kneeLength,
                measurementBloc.kneeLengthChanged,
                widget.measurements?.measurementDetails?.backBody
                    ?.kneeLength ??
                    null),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextFields(
                context,
                "Bottom Length",
                measurementBloc.bottomLength,
                measurementBloc.bottomLengthChanged,
                widget.measurements?.measurementDetails?.backBody
                    ?.bottomLength ??
                    null),
          ],
        ),
      )
    ];
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
            if (!widget.isEdit) {
              setState(() {
                ProfileUI.isEdited = true;
                print(value);
                select = value;
                genderValue = btnValue.toString();
              });

            } else {}
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "$title",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 15,
                fontFamily: "Helvetica",
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }

  Row measurementType(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Colors.black,
          value: type[btnValue],
          groupValue: selectType,
          onChanged: (String value) {
            if (!widget.isEdit) {
              setState(() {
                selectType = value;
                measurementSelected = btnValue.toString();
              });
            } else {}
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "$title",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 15,
                fontFamily: "Helvetica",
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}
