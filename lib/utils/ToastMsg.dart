import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMsg{
/*
  bool isShowToast=false;
  cancelToast(BuildContext context) async{
    isShowToast=false;
    await Fluttertoast.cancel();
  }
*/

  //Success MSG
  getLoginSuccess(BuildContext context,String msg) {
      return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,

      );

  }

  getSuccFeedbackSubmit(BuildContext context) {

      return Fluttertoast.showToast(
          msg: "Feedback Submitted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );


  }



  //Failure MSGS
  getFailureMsg(BuildContext context,String msg){
      return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );


  }
//Failure MSGS
  getInternetFailureMsg(BuildContext context){
    return Fluttertoast.showToast(
      msg: "No Internet Connection!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  getStartDate(BuildContext context){
    return Fluttertoast.showToast(
      msg: "Start Date cannot be equal to or later than today's date!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  getEndDate(BuildContext context){
    return Fluttertoast.showToast(
      msg: "End Date cannot be later than today's date!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  getComparision(BuildContext context){
    return Fluttertoast.showToast(
      msg: "Start Date & End Date should not be less than 6 months!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }




  getFailFeedbackSubmit(BuildContext context) {
    return Fluttertoast.showToast(
        msg: "Feedback Submittion Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  getNoDataFoundMsg(BuildContext context) {
    return Fluttertoast.showToast(
        msg: "No data found!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0

    );
  }
  getSomethingWentWrong(BuildContext context) {
    return Fluttertoast.showToast(
        msg: "Something Went Wrong. Please try after some time!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0

    );
  }
  getFiftyChars(BuildContext context) {
    return Fluttertoast.showToast(
        msg: "Comments should be less than 50 characters.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0

    );
  }

  getAuthenticationMsg(BuildContext context){
    return Fluttertoast.showToast(
        msg: "Authentication Failed. Please Login Again!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0

    );
  }

  getUserNamePass(BuildContext context) {
    return Fluttertoast.showToast(
        msg: "Please  Enter Details!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0

    );
  }

  getEmptyUserName(BuildContext context) {
    return Fluttertoast.showToast(
        msg: "Please  Enter Username!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0

    );
  }
  getEmptyPassword(BuildContext context) {
    return Fluttertoast.showToast(
        msg: "Please  Enter Password!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0

    );
  }

}