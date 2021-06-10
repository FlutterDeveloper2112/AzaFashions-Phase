
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'dart:convert' as JSON;
import 'dart:convert';
import 'package:azaFashions/models/CategoryModel.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/models/Search/SearchModel.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingProvider {
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
  //String baseUrl ="https://dormammu.azafashions.com/v1";
  String baseUrl ="http://qapi.azaonline.in/v1";



  //Listing API
  Future<ListingModel> getListingDetails(
    BuildContext context, String url, String sortOption,String filterApplied,int pageLinks) async {

    print("LISTING URL: $url");
    try {
      String path ="";
      if (sortOption != null && sortOption != "") {
        print("SORT URL: $url");
        path = "$baseUrl$url"+(url.contains("p=")?"":"&p=$pageLinks");
      }
      if (filterApplied != null && filterApplied != "") {
        print("FILTER URL:  $url" );
        String urlPath= url.contains("?")?"${url.replaceRange(url.lastIndexOf("?") ,url.trim().length,"" )}?":"$url?";
        String urlDomain ="$baseUrl$urlPath" ;
        print("FILTER URL:  $urlDomain" );
        urlDomain=urlDomain+filterApplied.trim()+(sortOption==null || sortOption==""?"":"&sort=$sortOption");
        String finalPath=urlDomain.trim()+"&p=$pageLinks";
        print("FILTER URL: $finalPath $url" );
        path =finalPath;
      }
      if(MyFilter.isClear==true && filterApplied==""){
        String urlDomain ="${url.replaceRange(url.lastIndexOf("?") ,url.trim().length,"" )}?";
        print(" isClear FILTER URL: $url $urlDomain ${MyFilter.isClear}");
        path = "$baseUrl${urlDomain.trim()}"+(sortOption==null || sortOption==""?"":"sort=$sortOption")+"&p=$pageLinks";
        print("FILTER URL: $path $url" );
      }

      else if((sortOption == null || sortOption == "") && (filterApplied == null || filterApplied == "")) {
        String urlPath= url.contains("?")?"${url.trim()}&p=$pageLinks":"${url.trim()}?p=$pageLinks";
       /* print("FILTER URL: $urlPath");
        String urlDomain= urlPath+(urlPath.contains("p=")?urlPath.replaceRange(urlPath.indexOf("p="), urlPath.length,"p=$pageLinks"):urlPath.contains("&")?"&p=$pageLinks":"p=$pageLinks");
        print("FILTER URL: $url");
        path = "$baseUrl$urlDomain";*/
        path = "$baseUrl$urlPath";
      }

      print("Filter PATH: $path");

      Response apiResponse;
      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path.trim()), headers: headers);
        print("Listing API RESPONSE: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          if(jsonDecode(apiResponse.body)["data"]["code"]==905){
            return ListingModel.withSuccess("${jsonDecode(apiResponse.body)["data"]["message"]}");
          }
          else{
            return ListingModel.fromJson(jsonDecode(apiResponse.body),pageLinks);
          }

        }

        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ListingModel.withError(
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

  Future<ChildListingModel> getChildListingDetails(
      BuildContext context, String url, String sortOption,String filterApplied,int pageLinks) async {
    try {
      String path ="";


      if (sortOption != null && sortOption != "") {
        print("SORT URL: $url");
        path = "$baseUrl$url"+(url.contains("p=")?"":"&p=$pageLinks");
      }
      if (filterApplied != null && filterApplied != "") {
        print("FILTER URL:  $url" );
        String urlPath= url.contains("?")?"${url.replaceRange(url.lastIndexOf("?") ,url.trim().length,"" )}?":"$url?";
        String urlDomain ="$baseUrl$urlPath" ;
        print("FILTER URL:  $urlDomain" );
        urlDomain=urlDomain+filterApplied.trim()+(sortOption==null || sortOption==""?"":"&sort=$sortOption");
        String finalPath=urlDomain.trim()+"&p=$pageLinks";
        print("FILTER URL: $finalPath $url" );
        path =finalPath;
      }
      if(MyFilter.isClear==true && filterApplied==""){
        String urlDomain ="${url.replaceRange(url.lastIndexOf("?") ,url.trim().length,"" )}?";
        print(" isClear FILTER URL: $url $urlDomain ${MyFilter.isClear}");
        path = "$baseUrl${urlDomain.trim()}"+(sortOption==null || sortOption==""?"":"sort=$sortOption")+"&p=$pageLinks";
        print("FILTER URL: $path $url" );

      }
      else if((sortOption == null || sortOption == "") && (filterApplied == null || filterApplied == "")) {
       /* String urlPath= url.contains("?")?"${url.replaceRange(url.lastIndexOf("?") ,url.trim().length,"" )}?":"$url?";
        print("FILTER URL: $urlPath");
        String urlDomain= urlPath+(urlPath.contains("p=")?urlPath.replaceRange(urlPath.indexOf("p="), urlPath.length,"p=$pageLinks"):urlPath.contains("&")?"&p=$pageLinks":"p=$pageLinks");
        print("FILTER URL: $url");
        path = "$baseUrl$urlDomain";*/
        String urlPath= url.contains("?")?"${url.trim()}&p=$pageLinks":"${url.trim()}?p=$pageLinks";
        /* print("FILTER URL: $urlPath");
        String urlDomain= urlPath+(urlPath.contains("p=")?urlPath.replaceRange(urlPath.indexOf("p="), urlPath.length,"p=$pageLinks"):urlPath.contains("&")?"&p=$pageLinks":"p=$pageLinks");
        print("FILTER URL: $url");
        path = "$baseUrl$urlDomain";*/
        path = "$baseUrl$urlPath";
      }

      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print("API RESPONSE: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          if(jsonDecode(apiResponse.body)["data"]["code"]==905){
            return ChildListingModel.withSuccess("${jsonDecode(apiResponse.body)["data"]["message"]}");
          }
          else{
            return ChildListingModel.fromJson(jsonDecode(apiResponse.body),pageLinks);
          }

        }

        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ChildListingModel.withError(
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
   //Search API
  Future<ChildListingModel> getSearchListDetails(
      BuildContext context, String url, String sortOption,String filterApplied,int pageLinks) async {
    try {
      String path ="";

      if (sortOption != null && sortOption != "") {
        print("SORT URL: $url");
        String urlDomain= url+(url.contains("p=")?"":"&p=$pageLinks");
        path = "$baseUrl$urlDomain";
        print("FILTER URL: $path");
      }
      if (filterApplied != null && filterApplied != "") {
        String queryparameter= url.contains("q=")?url.substring(url.indexOf("q="), url.contains("&")? url.indexOf("&"):url.length):"";
        String urlPath= url.contains("?")?"${url.replaceRange(url.lastIndexOf("?") ,url.trim().length,"" )}?":"$url?$queryparameter";

        String urlDomain ="$baseUrl$urlPath";
        urlDomain=urlDomain.trim()+(queryparameter!=""?"$queryparameter&"+filterApplied.trim():filterApplied .trim())+(sortOption==null || sortOption==""?"":"&sort=$sortOption");
        String finalPath=urlDomain.trim()+"&p=$pageLinks";
        path =finalPath;
      }
      if(MyFilter.isClear==true && filterApplied==""){
        String queryparameter= url.contains("q=")?url.substring(url.indexOf("q="), url.contains("&")? url.indexOf("&"):url.length):"";
        String urlPath= url.contains("?")?"${url.replaceRange(url.lastIndexOf("?") ,url.trim().length,"" )}?$queryparameter":"$url?$queryparameter";

        String urlDomain ="$baseUrl$urlPath";
        urlDomain=urlDomain.trim()+(sortOption==null || sortOption==""?"":"&sort=$sortOption");
        String finalPath=urlDomain.trim()+"&p=$pageLinks";
        path =finalPath;

      }
      else if((sortOption == null || sortOption == "") && (filterApplied == null || filterApplied == "")) {
        String urlPath= url.contains("q=")?url+"&":url.contains("?")?"${url.replaceRange(url.lastIndexOf("?") ,url.trim().length,"" )}?":"$url?";
        print("FILTER URL: $urlPath");
        String urlDomain=(urlPath.contains("p=")?urlPath.replaceRange(urlPath.indexOf("p="), urlPath.length,"p=$pageLinks"):urlPath+(urlPath.contains("&")?"p=$pageLinks":"p=$pageLinks"));
        print("FILTER URL: $url");
        path = "$baseUrl$urlDomain";
        print("FILTER URL: $path");
      }
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print("API RESPONSE: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          if(jsonDecode(apiResponse.body)["data"]["code"]==904){
            return ChildListingModel.withSuccess("${jsonDecode(apiResponse.body)["data"]["message"]}");
          }
          else{
            return ChildListingModel.fromJson(jsonDecode(apiResponse.body),pageLinks);
          }

        }

        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ChildListingModel.withError(
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

/*
  Future<ChildListingModel> getSearchDetails(
      BuildContext context, String query, String sortOption,int pageLinks) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = (sortOption != null || sortOption != "")
          ? "${HeaderFile().baseUrl}search?q=$query&p=$pageLinks&sort=$sortOption"
          : "${HeaderFile().baseUrl}search?q=$query&p=$pageLinks";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        print(headers);
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return ChildListingModel.fromJson(jsonDecode(apiResponse.body),pageLinks);
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ChildListingModel.withError(
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
*/

  Future<SearchModel> searchAutoComplete(
      BuildContext context, String query, String sortOption) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = (sortOption != null || sortOption != "")
          ? "${HeaderFile().baseUrl}autocomplete/search?q=$query&p=1&sort=$sortOption"
          : "${HeaderFile().baseUrl}autocomplete/search?q=$query&p=1";

      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          if(jsonDecode(apiResponse.body)['data']['code']==904){
            return SearchModel.withError(JSON.jsonDecode(apiResponse.body)['data']['message']);
          }
          else{
            UserTrackingDetails().searchQuery(query);
            print("SAERCH API :${jsonDecode(apiResponse.body)} ");
            return SearchModel.fromJson(jsonDecode(apiResponse.body));
          }
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return SearchModel.withError(
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

  Future<ChildListingModel> boughtTogether(
      BuildContext context, int productId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}products/$productId/bought-together";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return ChildListingModel.fromJson(jsonDecode(apiResponse.body),1);
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ChildListingModel.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<ChildListingModel> similarProducts(
      BuildContext context, int productId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}products/$productId/similar-products";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);

        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          if (jsonDecode(apiResponse.body)["data"]['code'] == 1701) {
            return ChildListingModel.withError(
                json.decode(apiResponse.body)['data']['message']);
          } else {
            print(apiResponse.body);
            return ChildListingModel.fromJson(jsonDecode(apiResponse.body),1);
          }
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ChildListingModel.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<ChildListingModel> recentlyViewed(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}customers/products/recently-viewed";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print("RECENTLY${JSON.jsonDecode(apiResponse.body)}");
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          print(JSON.jsonDecode(apiResponse.body));
          return ChildListingModel.fromJson(jsonDecode(apiResponse.body),1);
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return ChildListingModel.withError(
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

  //Category API

  Future<CategoryModel> getCategories(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}category-hierarchy";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print("RECENTLY${JSON.jsonDecode(apiResponse.body)}");
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          print(JSON.jsonDecode(apiResponse.body));
          return CategoryModel.fromJson(jsonDecode(apiResponse.body));
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          // return ListingModel.withError(
          //     "${jsonDecode(apiResponse.body)["data"]["message"]}");
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
