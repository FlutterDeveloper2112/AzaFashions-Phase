import 'dart:convert';

import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'package:azaFashions/models/Designer/DesignerModel.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesignerProvider {
  InternetConnection _internetConnection = new InternetConnection();
  ToastMsg _toastMsg = new ToastMsg();
  var _internetStatus;
  String currentLocation = "";
  LocationData curLocation;
  SessionDetails _sessionDetails = SessionDetails();
  SharedPreferences _sharedPreferences;

  //Listing API
  Future<DesignerModel> getDesigners(
      BuildContext context, String pageName, String id) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "";
      if (id != null) {
        pageName == "following-designers"
            ? path =
        "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/$pageName?category_id=$id"
            : path = "${HeaderFile().baseUrl}$pageName?category_id=$id";
      } else {
        pageName == "following-designers"
            ? path =
        "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/$pageName"
            : path = "${HeaderFile().baseUrl}$pageName";
      }

      Response apiResponse;

      print(path);
      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {
        headers = value;
      });

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {

        apiResponse = await get(Uri.parse(path), headers: headers);
        print("FEATURED DESIGN : ${jsonDecode(apiResponse.body)}");
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          if (jsonDecode(apiResponse.body)['data']['list'].isEmpty) {
            _toastMsg.getFailureMsg(context, "No Designers Found");
            return DesignerModel.withError("No Designers Found",id);
          } else {
            return DesignerModel.fromJson(json.decode(apiResponse.body),pageName);
          }
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return DesignerModel.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}","");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      print(Exception);
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<ResponseMessage> followDesigner(
      context, int designerId, String action) async {
    try {
      UserLogin _userLogin = UserLogin();
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}designers/$designerId/$action";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {
        headers = value;
      });

      _userLogin = UserLogin.fromJson(
          jsonDecode(_sharedPreferences.getString('userDetails')));

      Map<String, String> body = {"email": _userLogin.email};

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse =
        await post(Uri.parse(path), headers: headers, body: jsonEncode(body));
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {

          if(jsonDecode(apiResponse.body)["data"]['code']==1802){
            _toastMsg.getFailureMsg(
                context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
            return ResponseMessage.withError(
                jsonDecode(apiResponse.body)['data']['message']);
          }
          else{
            action=="follow"?UserTrackingDetails().followDesigner(_userLogin.email, designerId.toString()):UserTrackingDetails().unFollowDesigner(_userLogin.email, designerId.toString());
            _toastMsg.getLoginSuccess(
                context, jsonDecode(apiResponse.body)['data']['message']);
            return ResponseMessage.withSuccess(
                jsonDecode(apiResponse.body)['data']['message']);
          }

        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ResponseMessage.withError(
              jsonDecode(apiResponse.body)['data']['message']);
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      print(Exception);
      return _toastMsg.getSomethingWentWrong(context);
    }
  }
}
