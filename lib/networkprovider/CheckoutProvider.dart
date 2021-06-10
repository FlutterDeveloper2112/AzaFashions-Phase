
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'dart:convert';
import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Checkout/CheckOutListing.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutProvider {
  InternetConnection _internetConnection = new InternetConnection();
  ToastMsg _toastMsg = new ToastMsg();
  var _internetStatus;
  String currentLocation = "";
  LocationData curLocation;
  SessionDetails _sessionDetails = SessionDetails();
  SharedPreferences _sharedPreferences;
  static String tag="";
  static String error = "";
  Future<CartListing> coupon(BuildContext context, String coupon,String action) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}checkout/coupon/${action}";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      String body = jsonEncode({"coupon": coupon});
      print(
        _sharedPreferences.getString("XTrailId"),
      );
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        print(path);
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return CartListing.fromJson(jsonDecode(apiResponse.body));
        } else {
          return CartListing.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {

      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<CartListing> redeemItems(BuildContext context,String action,String type,int amount) async {

    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      String path="";
      action!="add"? path = "${HeaderFile().baseUrl}checkout/redeem-item/$action":path="${HeaderFile().baseUrl}checkout/redeem-item";

      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      String body = jsonEncode({ "type" : type, "amount" : amount});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        print(path);
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return CartListing.fromJson(jsonDecode(apiResponse.body));
        } else {
          tag = type;
          error = jsonDecode(apiResponse.body)["data"]["message"];
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return CartListing.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      print(Exception);
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<CheckoutListing> getCheckoutItemList(BuildContext context,bool is_gift,String gift_instr,bool is_orderInst, String orderIns) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}checkout/summary";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      String body;
      if(is_gift==true && is_orderInst==true){
        body='{"is_gift": ${is_gift},"gift_message": ${gift_instr},"order_instructions": ${orderIns}}';
      }
      else{
        if(is_gift==true){
          body='{"is_gift":  $is_gift,"gift_message": $gift_instr}';
        }
        else if(is_orderInst==true){
          body='{"order_instructions": ${orderIns}}';
        }
        else{
          body="";
        }
      }

      print("API CHECKBOX: $body");

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = body!=""?await post(Uri.parse(path), headers: headers,body: body ):await post(Uri.parse(path), headers: headers );
        print("API CHECKBOX: ${apiResponse.body}");

        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {

          UserTrackingDetails().checkoutStarted(jsonDecode(apiResponse.body)["data"]["total_items"].toString(),jsonDecode(apiResponse.body)["data"]["total_amount_payable"].toString(),jsonDecode(apiResponse.body)["data"]["shipping_address"].toString(),jsonDecode(apiResponse.body)["data"]["billing_address"].toString(),jsonDecode(apiResponse.body)["data"]["total_discount"].toString());
          return CheckoutListing.fromJson(jsonDecode(apiResponse.body));
        }
        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return CheckoutListing.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
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

  Future<CheckoutListing> getSelectedAddress(BuildContext context,int addressId,String selection_type) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}checkout/address/select";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      Map<String, String> requestBody =  {
        "address_id":"$addressId",
        "selection_type":"$selection_type"
      };

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body:jsonEncode(requestBody));
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          _toastMsg.getLoginSuccess(context, "Address Selected Successfully.");


          return CheckoutListing.withSuccess("${jsonDecode(apiResponse.body)["message"]}");

        }
        else {

          return CheckoutListing.withError(
              "${jsonDecode(apiResponse.body)["message"]}");
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





}
