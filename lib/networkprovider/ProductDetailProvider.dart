
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'dart:convert';
import 'package:azaFashions/models/ProductDetail/EmiDetails.dart';
import 'package:azaFashions/models/ProductDetail/ProductItemDetail.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailProvider{

  InternetConnection _internetConnection = new InternetConnection();
  ToastMsg _toastMsg = new ToastMsg();
  var _internetStatus;
  String currentLocation = "";
  LocationData curLocation;
  SessionDetails _sessionDetails = SessionDetails();
  SharedPreferences _sharedPreferences;



  Future<ProductItemDetail> getProductDetails(context,int productId,String url) async {
    print("Url: ${url}");
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = url!=null && url!=""?"${HeaderFile().baseUrl}${url.substring(1)}":"${HeaderFile().baseUrl}products/block-print-handloom-cotton-palazzo/$productId";
      print("Product Path Url: ${path}");
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print(jsonDecode(apiResponse.body)['data']);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          UserTrackingDetails().productViewed(jsonDecode(apiResponse.body)['data']['id'].toString(), jsonDecode(apiResponse.body)['data']['url'],jsonDecode(apiResponse.body)['data']['designer_name'],jsonDecode(apiResponse.body)['data']['category_id'].toString(),jsonDecode(apiResponse.body)['data']['you_pay'].toString());

    return ProductItemDetail.fromJson(jsonDecode(apiResponse.body)['data']);
        }
        else if(apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Blocker"){
          return ProductItemDetail.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ProductItemDetail.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
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
  Future<ResponseMessage> checkCODAvailability(context,String pinCode) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}cod/check-serviceability";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      Map<String,dynamic> body = {
        "postal_code": int.parse(pinCode)
      };

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body: json.encode(body));

        print(apiResponse.body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          print(apiResponse.body);
          if(jsonDecode(apiResponse.body)['data']['code']==608){
            return ResponseMessage.withSuccess(jsonDecode(apiResponse.body)['data']['message']);
          }
          else{
            return ResponseMessage.withError(jsonDecode(apiResponse.body)['data']['message']);
            // return ProductItemDetail.withError(jsonDecode(apiResponse.body)['data']['message']);
          }

        }
        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ResponseMessage.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
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

  Future<EmiDetails> getEmiDetails(BuildContext context,String amount) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}payments/emi-options?amount=$amount";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

   _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);

        print(apiResponse.body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          return EmiDetails.fromJson(jsonDecode(apiResponse.body)['data']);        }
        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return EmiDetails.fromJson(jsonDecode(apiResponse.body)['data']['message']);
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

  Future<ResponseMessage> customization(context,Map<String,dynamic> body,int productId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}products/164900/record-custom-measurement";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body: json.encode(body));

        print(apiResponse.body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {

          return ResponseMessage.withSuccess(jsonDecode(apiResponse.body)['message']);
        }
        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ResponseMessage.withError(jsonDecode(apiResponse.body)['message']);
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