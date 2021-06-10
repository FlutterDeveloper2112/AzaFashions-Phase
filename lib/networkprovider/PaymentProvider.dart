
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'dart:convert' as JSON;
import 'dart:convert';
import 'package:azaFashions/models/Payment/PaymentOptions.dart';
import 'package:azaFashions/models/Payment/PaymentStatus.dart';
import 'package:azaFashions/models/Payment/ShareFeedback.dart';
import 'package:azaFashions/networkprovider/LoginProvider.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider {
  InternetConnection _internetConnection = new InternetConnection();
  ToastMsg _toastMsg = new ToastMsg();
  var _internetStatus;
  String currentLocation = "";
  LocationData curLocation;
  SessionDetails _sessionDetails = SessionDetails();
  SharedPreferences _sharedPreferences;


  Future<bool> getBrowseAsGuest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("browseAsGuest");
  }


  //Payment
  Future<PaymentOptions> getPaymentMode(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}checkout/payment-options";
      Response apiResponse;

      String body = '{"tnc_checked":  ${true}}';

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body: body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          return PaymentOptions.fromJson(jsonDecode(apiResponse.body));
        }
        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return PaymentOptions.withError("${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<ResponseMessage> getPaymentTransResp(BuildContext context,String transcId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}checkout/order-acknowledgement/${transcId}";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          print("PAYMENT TRANSC RESPONS: ${jsonDecode(apiResponse.body)["data"]["order"]}");
          return ResponseMessage.withSuccess(jsonDecode(apiResponse.body)["data"]["order"]);
        }
        else {
          _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ResponseMessage.withError("${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<PaymentStatus> getPaymentStatus(BuildContext context,String url,String transcId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = transcId==""?"https://dormammu.azafashions.com/v1${url}":"${HeaderFile().baseUrl}checkout/order-acknowledgement/${transcId}";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers);

        print("THANK YOU PAGE: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
         // LoginProvider().getBagCount(context);
          UserTrackingDetails().orderSuccess(jsonDecode(apiResponse.body)["data"]["order_id"].toString(),jsonDecode(apiResponse.body)["data"]["custom_order_id"].toString(),jsonDecode(apiResponse.body)["data"]["total_items"].toString(),jsonDecode(apiResponse.body)["data"]["total_discount"].toString(),jsonDecode(apiResponse.body)["data"]["total_amount_payable"].toString(),jsonDecode(apiResponse.body)["data"]["shipping_address"].toString(),jsonDecode(apiResponse.body)["data"]["billing_address"].toString());
          return PaymentStatus.fromJson(jsonDecode(apiResponse.body));
        }
        else {
          if(jsonDecode(apiResponse.body)["data"]["code"]==1914){
            return PaymentStatus.fromBlockerJson(jsonDecode(apiResponse.body));
          }
          else{
            _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
            return PaymentStatus.withError("${jsonDecode(apiResponse.body)["data"]["message"]}");
          }
          //1914
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print(Exception);
      return _toastMsg.getSomethingWentWrong(context);
    }
  }


  Future<PaymentStatus> getDirectPaymentStatus(BuildContext context) async {
    try {
      print("DIRECT PAYMENT STATUS CALLED");
      _sharedPreferences = await SharedPreferences.getInstance();
      String path ="https://dormammu.azafashions.com/v1/checkout/process-order";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers);

        print("THANK YOU PAGE: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          // LoginProvider().getBagCount(context);
          UserTrackingDetails().orderSuccess(jsonDecode(apiResponse.body)["data"]["order_id"].toString(),jsonDecode(apiResponse.body)["data"]["custom_order_id"].toString(),jsonDecode(apiResponse.body)["data"]["total_items"].toString(),jsonDecode(apiResponse.body)["data"]["total_discount"].toString(),jsonDecode(apiResponse.body)["data"]["total_amount_payable"].toString(),jsonDecode(apiResponse.body)["data"]["shipping_address"].toString(),jsonDecode(apiResponse.body)["data"]["billing_address"].toString());
          return PaymentStatus.fromJson(jsonDecode(apiResponse.body));
        }
        else {
          if(jsonDecode(apiResponse.body)["data"]["code"]==1914){
            return PaymentStatus.fromBlockerJson(jsonDecode(apiResponse.body));
          }
          else{
            _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
            return PaymentStatus.withError("${jsonDecode(apiResponse.body)["data"]["message"]}");
          }
          //1914
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print(Exception);
      return _toastMsg.getSomethingWentWrong(context);
    }
  }



  Future<ShareFeedback> feedback(context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}feedback-form";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);

        print(apiResponse.body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          return ShareFeedback.fromJson(jsonDecode(apiResponse.body)['data']);
        }
        else {
          _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ShareFeedback.withError("${jsonDecode(apiResponse.body)["data"]["message"]}");
          //1914
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print(Exception);
      return _toastMsg.getSomethingWentWrong(context);
    }
  }


  Future<ResponseMessage> sendFeedback(context,Map<String,String> body) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}record-feedback";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      print(JSON.jsonEncode(body));

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body: JSON.jsonEncode(body));
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          _toastMsg.getLoginSuccess(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ResponseMessage.withSuccess(JSON.jsonDecode(apiResponse.body)['data']['message']);
        }
        else {
          _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ResponseMessage.withError(JSON.jsonDecode(apiResponse.body));
          //1914
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print(Exception);
      return _toastMsg.getSomethingWentWrong(context);
    }
  }
  Future<ResponseMessage> recordOrderPlacedFeedback(context,int rating) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}record-feedback";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      String body= "{'rating' : $rating}";

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body: JSON.jsonEncode(body));
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          _toastMsg.getLoginSuccess(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ResponseMessage.withSuccess(JSON.jsonDecode(apiResponse.body)['data']['message']);
        }
        else {
          _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ResponseMessage.withError(JSON.jsonDecode(apiResponse.body));
          //1914
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print(Exception);
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

}







