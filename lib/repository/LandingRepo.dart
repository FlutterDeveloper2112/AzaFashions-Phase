import 'dart:async';
import 'package:azaFashions/models/LandingPages/ChildLandingPage.dart';
import 'package:azaFashions/models/LandingPages/BaseLandingPage.dart';
import 'package:azaFashions/networkprovider/LandingProvider.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:flutter/cupertino.dart';

class LandingRepo{
  BuildContext context;

  LandingProvider _apiProvider = new LandingProvider();

  Future<LandingPage> getBaseLandingDetails(String pageName) =>  _apiProvider.getBaseLandingPageDetails(context,pageName);
  Future<ChildLandingPage> getChildLandingDetails(String pageName) =>  _apiProvider.getChildLandingPageDetails(context,pageName);

  Future<LandingPage> getSubscriptionDetails(String email) =>  _apiProvider.getSubscription(context,email);
  Future<LandingPage> getUnSubscriptionDetails(String email) =>  _apiProvider.getUnSubscription(context,email);

  Future<ResponseMessage> weddingBlock(String email,String mobile,String message,String url)=>_apiProvider.weddingBlock(context, email, mobile, message,url);

}

