
import 'package:azaFashions/bloc/LoginBloc/OTPBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/ORDERSUCCESS/ThankYou.dart';
import 'package:countdown/countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:webengage_flutter/webengage_flutter.dart';



class OTP extends StatefulWidget {
  String mobileNo="";
  OTP(this.mobileNo);
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTP> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  bool _isLoading = false;
  bool _isResendEnable = false;
  int otpValue;
  int timerValue;
  String otpWaitTimeLabel = "";

  final _teOtpDigitOne = TextEditingController();
  final _teOtpDigitTwo = TextEditingController();
  final _teOtpDigitThree = TextEditingController();
  final _teOtpDigitFour = TextEditingController();
  final _teOtpDigitFive = TextEditingController();
  final _teOtpDigitSix = TextEditingController();


  FocusNode _focusNodeDigitOne = FocusNode();
  FocusNode _focusNodeDigitTwo = FocusNode();
  FocusNode _focusNodeDigitThree = FocusNode();
  FocusNode _focusNodeDigitFour = FocusNode();
  FocusNode _focusNodeDigitFive = FocusNode();
  FocusNode _focusNodeDigitSix = FocusNode();
  OTPBloc otp_bloc =OTPBloc();
  final connectivity=new ConnectivityService();
  var connectionStatus;


  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "OTP Verification");
    super.initState();
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("Cash On Delivery Screen.");


    if(mounted){startTimer();}

    changeFocusListener(_teOtpDigitOne, _focusNodeDigitTwo);
    changeFocusListener(_teOtpDigitTwo, _focusNodeDigitThree);
    changeFocusListener(_teOtpDigitThree, _focusNodeDigitFour);
    changeFocusListener(_teOtpDigitFour, _focusNodeDigitFive);
    changeFocusListener(_teOtpDigitFive, _focusNodeDigitSix);

    otp_bloc.fetchOTP("cod",widget.mobileNo);
    otp_bloc.sendotpFecther.first.then((value) => print("OTP VALUE IS: $value"));
  }

  @override
  void dispose() {
    connectivity.dispose();
    otp_bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBarWidget().myAppBar(context, "Mobile Verification", scaffoldKey),
        backgroundColor: Colors.white,
        // resizeToAvoidBottomPadding : false,
        body:connectionStatus.toString()!="Connection.Offline"?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child:_buildBody(context),
            )
          ],
        ):ErrorPage(appBarTitle: "You are offline.",),
      ),
    );
  }




  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top:30),
        ),
        //OTPNumber
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child:Align(
                      alignment: Alignment.center,
                      child: Text("OTP sent to mobile no : ${widget.mobileNo} ",textAlign:TextAlign.start,style: TextStyle(fontSize:16,fontFamily: "Helvetica",color: Colors.grey[500]))
                  )
              ),
            ]),

        //OTPValue
        otpBox(context),

        //OTPTimer
        Padding(
            padding: EdgeInsets.only(left: 25,right: 25, top:25),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child:
                    Text("OTP Timer :  ",textAlign:TextAlign.start,style: TextStyle(fontSize:16,fontFamily: "Helvetica",color: Colors.grey[500]),),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child:
                    Text(" $otpWaitTimeLabel ",textAlign:TextAlign.start,style: TextStyle(fontSize:16,fontFamily: "Helvetica",color: Colors.black),),
                  ),

                ])),


        //SignInButton
        Padding(
            padding: EdgeInsets.only(left:20,right: 20,top: 30),
            child:Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),

              ),
              width: MediaQuery.of(context).size.width/1  ,
              height: 45,

              child:StreamBuilder(
                stream:null,
                builder: (context,snapshot)=>FlatButton(

                  onPressed: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if( connectionStatus.toString()!="ConnectivityStatus.Offline"){
                      otpValue= int.parse(_teOtpDigitOne.text + _teOtpDigitTwo.text + _teOtpDigitThree.text + _teOtpDigitFour.text+ _teOtpDigitFive.text + _teOtpDigitSix.text);
                      print("OTPVALUE: $otpValue");
                      if(otpValue!=0 ){
                        otp_bloc.fetchVerifyOTP(otpValue,"cod");
                        otp_bloc.verifyotpFecther.listen((value) {
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
                              content: Text("Verfication Completed Successfully."),
                              duration: Duration(seconds: 1),
                            ));

                            changeThePage(context);
                          }
                        });
                      }
                      else{

                        scaffoldKey.currentState.removeCurrentSnackBar();
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Please Enter the OTP."),
                          duration: Duration(seconds: 1),
                        ));
                      }
                    }
                    else{
                      scaffoldKey.currentState.removeCurrentSnackBar();
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No Internet Connection. Please Try Again.")));
                    }},
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.red[600],
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),


                  child: Text('VERIFY', textAlign:TextAlign.center,style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Helvetica",
                      color: Colors.white,
                      fontSize: 15),),
                  color: HexColor("#ad2810"),),
              ),
            )

        ),

        //OTPTimer
        Padding(
            padding: EdgeInsets.only(left: 25,right: 25,top:30),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder(
                    stream: null,
                    builder: (context,snapshot)=>InkWell(
                        onTap:(){
                          FocusScope.of(context).requestFocus(FocusNode());
                          if( connectionStatus.toString()!="ConnectivityStatus.Offline"){
                            if(timerValue==0.0){
                              if(_isResendEnable==true) {
                                clearData();
                                otp_bloc.fetchOTP("cod",widget.mobileNo);
                                otp_bloc.sendotpFecther.listen((value) {
                                  if(value.error.isNotEmpty){
                                    scaffoldKey.currentState.removeCurrentSnackBar();
                                    scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("${value.error}"),
                                      duration: Duration(seconds: 1),
                                    ));
                                  }
                                  else{
                                    startTimer();
                                  }
                                });

                              }
                            }
                          }
                          else{
                            scaffoldKey.currentState.removeCurrentSnackBar();
                            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No Internet Connection. Please Try Again.")));
                          }



                        },
                        child:Align(
                          alignment: Alignment.center,
                          child: Text("RESEND OTP",textAlign:TextAlign.center,style: TextStyle(decoration: TextDecoration.underline,fontSize:15,fontFamily: "Helvetica",color: timerValue==0.0?Colors.black:Colors.grey[300]),),
                        )),
                  ),


                ])),


      ],
    );
  }


  void startTimer() {
    if (mounted) {
      otpWaitTimeLabel = "";
      setState(() {
        _isResendEnable = false;
      });

      var sub = CountDown(new Duration(minutes: 1)).stream.listen(null);

      sub.onData((Duration d) {
        if(mounted) {
          setState(() {
            int sec = d.inSeconds % 60;
            timerValue = sec;
            otpWaitTimeLabel = d.inMinutes.toString() + ":" + sec.toString();
          });
        }
      });

      sub.onDone(() {
        setState(() {
          _isResendEnable = true;
          clearData();
        });
      });
    }
  }

  changeThePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return MainHome();
    }));
  }

  //OTP WIDGETS
  Widget otpBox(BuildContext context){
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            inputBox(_teOtpDigitOne, _focusNodeDigitOne),
            SizedBox(
              width: 10.0,
            ),
            inputBox(_teOtpDigitTwo, _focusNodeDigitTwo),
            SizedBox(
              width: 10.0,
            ),
            inputBox(_teOtpDigitThree, _focusNodeDigitThree),
            SizedBox(
              width: 10.0,
            ),
            inputBox(_teOtpDigitFour, _focusNodeDigitFour),
            SizedBox(
              width: 10.0,
            ),
            inputBox(_teOtpDigitFive, _focusNodeDigitFive),
            SizedBox(
              width: 10.0,
            ),
            inputBox(_teOtpDigitSix, _focusNodeDigitSix),
          ],
        ));
  }
  Widget inputBox(TextEditingController teOtpDigitOne, FocusNode focusNodeDigitOne) {
    return Container(
        height: 50,
        width: 30,
        child:TextField(
            enableInteractiveSelection: false,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                )),
            textAlign: TextAlign.center,
            controller: teOtpDigitOne,
            focusNode: focusNodeDigitOne,
            keyboardType: TextInputType.number,
            maxLines: 1,
            style:TextStyle(fontFamily: "Helvetica",color: Colors.black,fontSize:20))
    ) ;

  }
  void clearData(){
    otpWaitTimeLabel="";
    otpValue=null;
    _teOtpDigitOne.clear();
    _teOtpDigitTwo.clear();
    _teOtpDigitThree.clear();
    _teOtpDigitFour.clear();
    _teOtpDigitFive.clear();
    _teOtpDigitSix.clear();
    FocusScope.of(context).requestFocus(_focusNodeDigitOne);
  }
  void changeFocusListener(TextEditingController teOtpDigitOne, FocusNode focusNodeDigitTwo) {
    teOtpDigitOne.addListener(() {
      if (teOtpDigitOne.text.length > 0 && focusNodeDigitTwo != null) {
        FocusScope.of(context).requestFocus(focusNodeDigitTwo);
      }
      setState(() {});
    });
  }



}