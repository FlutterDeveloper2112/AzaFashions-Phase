import 'dart:convert' as JSON;
import 'dart:convert';
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/models/LandingPages/ChildLandingPage.dart';
import 'package:azaFashions/models/LandingPages/BaseLandingPage.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingProvider {
  InternetConnection _internetConnection = new InternetConnection();
  ToastMsg _toastMsg = new ToastMsg();
  var _internetStatus;
  String currentLocation = "";
  LocationData curLocation;
  SessionDetails _sessionDetails = SessionDetails();
  SharedPreferences _sharedPreferences;

  //Listing API
  Future<LandingPage> getBaseLandingPageDetails(BuildContext context,String pageName) async {
    _internetStatus = await _internetConnection.checkInternet(context);

    if (_internetStatus) {
      try {
        _sharedPreferences = await SharedPreferences.getInstance();

        String path = pageName.contains("/") ? "${HeaderFile().baseUrl}${pageName.substring(1)}" : "${HeaderFile().baseUrl}$pageName";
        Response apiResponse;

        Map<String, String> headers;
        await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

        print(path);

        if (_internetStatus) {
          apiResponse = await get(Uri.parse(path), headers: headers);
          if (apiResponse.statusCode == 200 &&
              jsonDecode(apiResponse.body)["message"] == "Success") {
            _sharedPreferences.getBool("browseAsGuest")==true? _sessionDetails.saveTrailId(apiResponse.headers["x-trail-id"].toString(),""):null;

            print("HEADERS: ${apiResponse.headers.toString()}");
            return LandingPage.fromJson(jsonDecode(apiResponse.body), pageName == "on-sale" ? "Offers" : pageName);
          }
          else {
            _toastMsg.getFailureMsg(
                context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
            return LandingPage.withError(
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
    else {
      return _toastMsg.getInternetFailureMsg(context);
    }
  }
  Future<ChildLandingPage> getChildLandingPageDetails(BuildContext context,String pageName) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      String path = pageName.contains("/")?"${HeaderFile().baseUrl}${pageName.substring(1)}": "${HeaderFile().baseUrl}$pageName";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      print(path);
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print(jsonDecode(apiResponse.body));
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          _sharedPreferences.getBool("browseAsGuest")==true? _sessionDetails.saveTrailId(apiResponse.headers["x-trail-id"].toString(),""):null;
          return ChildLandingPage.fromJson(jsonDecode(apiResponse.body),pageName=="on-sale"? "offers":pageName);
        }
        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ChildLandingPage.withError(
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
 Future<LandingPage> getSubscription(BuildContext context,String email) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      String path ="${HeaderFile().baseUrl}newsletter/subscribe";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      Map<String, String> requestBody =  {
        "email":"$email"
      };
      print(path);
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body:JSON.jsonEncode(requestBody));

        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          UserTrackingDetails().emailSubscription(email);
         /* _toastMsg.getLoginSuccess(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
         */ return LandingPage.withSuccess(jsonDecode(apiResponse.body)["data"]["message"]);

        }
        else {
    /*      _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
     */     return LandingPage.withError(
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
 Future<LandingPage> getUnSubscription(BuildContext context,String email) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      String path ="${HeaderFile().baseUrl}newsletter/unsubscribe";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      Map<String, String> requestBody =  {
        "email":"$email"
      };
      print(path);
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body:JSON.jsonEncode(requestBody));

        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          BagCount.news_letter=false;
          UserTrackingDetails().emailUnsubscription(email);
         /* _toastMsg.getLoginSuccess(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
         */ return LandingPage.withSuccess(jsonDecode(apiResponse.body)["data"]["message"]);

        }
        else {
    /*      _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
     */     return LandingPage.withError(
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
  Future<ResponseMessage> weddingBlock(BuildContext context,String email,String mobile,String message,String url) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = url.contains("/")?"${HeaderFile().baseUrl}${url.substring(1)}": "${HeaderFile().baseUrl}$url";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      Map<String, String> requestBody =  {
        "email":"$email",
        "mobile" : mobile,
        "message" : message
      };
      print(path);
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await http.post(Uri.parse(path), headers: headers,body:JSON.jsonEncode(requestBody));
        print(jsonDecode(apiResponse.body));
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          return ResponseMessage.withSuccess(jsonDecode(apiResponse.body)["message"]);
        }
        else {
          return ResponseMessage.withError(
              "${jsonDecode(apiResponse.body)['message']}");
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







