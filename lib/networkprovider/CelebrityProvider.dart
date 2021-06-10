import 'dart:convert';

import 'package:azaFashions/models/CelebrityList.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

class CelebrityProvider{


  InternetConnection _internetConnection = new InternetConnection();
  ToastMsg _toastMsg = new ToastMsg();
  var _internetStatus;
  String currentLocation = "";
  LocationData curLocation;
  String baseUrl ="https://dormammu.azafashions.com/v1";
  //String baseUrl ="http://qapi.azaonline.in/v1";

  // SessionDetails _sessionDetails = SessionDetails();
  // SharedPreferences _sharedPreferences;

  Future<CelebrityList> celebrityStyle(
      BuildContext context, String url, String sortOption,String filterApplied,int pageLinks) async {
    print("URL: $url");
    try {
      String path ="";

      if (sortOption != null && sortOption != "") {
        print("SORT URL: $url");
        path = "$baseUrl$url"+(url.contains("p=")?"":"&p=$pageLinks");
      }
      if (filterApplied != null && filterApplied != "") {
        url=url==null||url==""?"/celebrity-style":url;
        print("FILTER URL:  $url" );
        String urlPath= url.contains("?")?"${url.replaceRange(url.lastIndexOf("?") ,url.trim().length,"" )}?":"$url?";
        String urlDomain =url.contains("/")?"$baseUrl$urlPath":"$baseUrl/$urlPath" ;
        print("FILTER URL:  $urlDomain" );
        urlDomain=urlDomain+filterApplied.trim()+(sortOption==null || sortOption==""?"":"&sort=$sortOption");
        String finalPath=urlDomain.trim()+"&p=$pageLinks";
        print("FILTER URL: $finalPath $url" );
        path =finalPath;
      }
      if(MyFilter.isClear==true && filterApplied==""){
        url=url==null||url==""?"/celebrity-style":url;
        path = "$baseUrl/celebrity-style";
        print("FILTER URL: $path $url" );
      }

      else if((sortOption == null || sortOption == "") && (filterApplied == null || filterApplied == "")) {
        url=url==null||url==""?"/celebrity-style":url;
        String urlPath= url.contains("?")?"${url.trim()}&p=$pageLinks":"${url.trim()}?p=$pageLinks";
         path = url.contains("/")?"$baseUrl$urlPath":"$baseUrl/$urlPath";
      }

      print("Filter PATH: $path");

      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);

        print(jsonDecode(apiResponse.body));
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return CelebrityList.fromJson(jsonDecode(apiResponse.body)['data'],pageLinks);
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return CelebrityList.withError(
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

  /* Future<CelebrityList> celebrityStyle(BuildContext context,) async {
    try {

      String path = "${HeaderFile().baseUrl}celebrity-style";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);

        print(jsonDecode(apiResponse.body));
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return CelebrityList.fromJson(jsonDecode(apiResponse.body)['data'],2);
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return CelebrityList.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }
*/


}