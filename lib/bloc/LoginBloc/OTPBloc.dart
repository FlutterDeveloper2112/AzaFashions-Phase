

import 'dart:convert';

import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/repository/LoginRepo.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:azaFashions/validator/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPBloc extends Object with Validators{
  BuildContext context;
  final repository=  LoginRepo();
  final sendotpFecther = PublishSubject<ResponseMessage>();
  final verifyotpFecther = PublishSubject<ResponseMessage>();
  final _otpcontroller =  BehaviorSubject<String>();

  Stream<ResponseMessage> get sentOtp => sendotpFecther.stream;
  Stream<ResponseMessage> get verifyOtp => verifyotpFecther.stream;



  Function(String) get otpChanged => _otpcontroller.sink.add;
  //Stream<String> get otp => _otpcontroller.stream.transform(otpValidator);

 // Stream<bool> get otpCheck => Rx.combineLatest2(otp, otp, (e, p)=>true);

  fetchOTP(String intent,String mobile) async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    Map userMap = jsonDecode(sharedPreferences.getString('userDetails'));
    UserLogin userLogin = UserLogin.fromJson(userMap);
    var otp_response = await repository.getOTPRepo(intent,userLogin.mobile,userLogin.email,userLogin.customer_id);
    sendotpFecther.add(otp_response);
  }

  fetchVerifyOTP(int otpValue,String intent) async {
    if (otpValue != null) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Map userMap = jsonDecode(sharedPreferences.getString('userDetails'));
      UserLogin userLogin = UserLogin.fromJson(userMap);
      var otp_response = await repository.getVerifyOTPRepo(intent, otpValue, userLogin.mobile, userLogin.email, userLogin.customer_id);
      verifyotpFecther.add(otp_response);
    }
    else{
      ToastMsg toastMsg = new ToastMsg();
      toastMsg.getFailureMsg(context, "Please Enter the OTP");
    }
  }

  void dispose(){
    verifyotpFecther.close();
    sendotpFecther.close();
  }

}

final otp_bloc=OTPBloc();