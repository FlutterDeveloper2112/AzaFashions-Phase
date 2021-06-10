import 'dart:async';
import 'package:azaFashions/models/Login/BulletMenuList.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/models/Login/Registration.dart';
import 'package:azaFashions/models/Login/SocialLoginModel.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/networkprovider/LoginProvider.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginRepo{
  BuildContext context;

  LoginProvider _apiProvider = new LoginProvider();

  Future<IntroModelList> getIntroScreenRepo() =>  _apiProvider.getIntroScreenList(context);

  Future<UserLogin> geRegisCredentialsRepo(Registration registeration) =>  _apiProvider.registrationApi(context,registeration);

  Future<UserLogin> geLoginCredentialsRepo(String email,String password) =>  _apiProvider.loginWithCredentials(email, password, context);

  Future<SocialLoginModel> getFacebookLoginModelRepo() =>  _apiProvider.login_facebook(context);
  Future<SocialLoginModel> getAppleModelRepo() =>  _apiProvider.login_apple(context);
  Future<SocialLoginModel> getGoogleLoginModelRepo() =>  _apiProvider.login_google(context);
  Future<UserLogin> getSocialLogin(SocialLoginModel socialLoginModel) =>  _apiProvider.socialLoginApi(context,socialLoginModel);

  Future<ResponseMessage> getForgetPassRepo(String email,) =>  _apiProvider.forgetPasswordApi(context,email);

  Future<ResponseMessage> getOTPRepo(String intent,String mobileNo,String email,String cutomer_id ) =>  _apiProvider.sendOTP(context,intent,mobileNo,email,cutomer_id);
  Future<ResponseMessage> getVerifyOTPRepo(String intent,int otp,String mobileNo,String email,String customerId) =>  _apiProvider.verifyOTP(context,intent,otp,mobileNo,email,customerId);

  Future<dynamic> getLocationRepo(BuildContext context) =>  _apiProvider.getUserLocation(context);

  Future<BulletMenuList> getHomeApiRepo() =>  _apiProvider.homeApi(context);

  Future<ResponseMessage> logoutRepo(BuildContext context) => _apiProvider.logout(context);


}
