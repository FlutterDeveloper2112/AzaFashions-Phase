import 'dart:async';
import 'package:azaFashions/models/Payment/PaymentOptions.dart';
import 'package:azaFashions/models/Payment/PaymentStatus.dart';
import 'package:azaFashions/models/Payment/ShareFeedback.dart';
import 'package:azaFashions/networkprovider/PaymentProvider.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:flutter/cupertino.dart';

class PaymentRepo
{
  BuildContext context;

  PaymentProvider _apiProvider = new PaymentProvider();

  //Payment Repository
  Future<PaymentOptions> getpPaymentItemListRepo() =>  _apiProvider.getPaymentMode(context);
  Future<PaymentStatus> getPaymentStatusRepo(String url,String transID) =>  _apiProvider.getPaymentStatus(context,url,transID);
  Future<PaymentStatus> getDirectPaymentStatusRepo(BuildContext context) =>  _apiProvider.getDirectPaymentStatus(context);


  Future<ShareFeedback> feedback()=> _apiProvider.feedback(context);


  Future<ResponseMessage> sendFeedback(Map<String,String> body)=> _apiProvider.sendFeedback(context, body);
  Future<ResponseMessage> recordOrderPlacedFeedback(int body)=> _apiProvider.recordOrderPlacedFeedback(context, body);

}
