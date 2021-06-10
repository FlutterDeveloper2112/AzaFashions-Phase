import 'dart:convert';
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Cart/CartModel.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginProvider.dart';

class CartProvider {
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


  //Cart
  Future<CartListing> getCartItemList(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}customers/cart";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
            print("Shopping Cart Data: ${jsonDecode(apiResponse.body)}");
            UserTrackingDetails().cartViewed(jsonDecode(apiResponse.body)["data"]["total_items"].toString(),jsonDecode(apiResponse.body)["data"]["total_amount_payable"].toString(),jsonDecode(apiResponse.body)["data"]["total_discount"].toString());
            return CartListing.fromJson(jsonDecode(apiResponse.body));
        }
        else {
          print("API RESPONSE: ${jsonDecode(apiResponse.body)}");
          CartListing.data_error=jsonDecode(apiResponse.body)["data"]["message"];
      /*    _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
      */    return CartListing.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print("Exception: ${Exception.toString()}");
      return _toastMsg.getSomethingWentWrong(context);
    }
  }
  Future<CartListing> addCart(context, CartModel cartModel) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}customers/cart/items/add";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      String body = jsonEncode( cartModel.toJson());
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        print("Body $body");
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          print("CART MESSAGE OF ITEM:${jsonDecode(apiResponse.body)} Product Doesn't Exists or is Inactive");
          _toastMsg.getLoginSuccess(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          //await LoginProvider().getBagCount(context);
          if(jsonDecode(apiResponse.body)["data"]["message"]=="Added to Your Bag"){
            BagCount.bagCount.value= BagCount.bagCount.value+ cartModel.products.length;
          }
          return CartListing.withSuccess("${jsonDecode(apiResponse.body)["data"]["message"]}");

        } else {
          _toastMsg.getFailureMsg(context, "Item Failed to add in cart");
          return CartListing.withError("Item Failed to add in cart");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }
  Future<CartListing>removeItem(context,int productId,int sizeId,int quantity,String source) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}customers/cart/items/$productId/remove";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      Map<String, dynamic> body = {"size_id": sizeId, "quantity": quantity};
      _internetStatus = await _internetConnection.checkInternet(context);

      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body: jsonEncode(body));
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          print("CART MESSAGE OF ITEM:${jsonDecode(apiResponse.body)} Product Doesn't Exists or is Inactive");

          source!=""?null:_toastMsg.getLoginSuccess(context, "Item Removed Successfully");
          if(jsonDecode(apiResponse.body)["data"]["message"]=="Removed From Your Bag"){
            BagCount.bagCount.value= BagCount.bagCount.value-1;
          }

          return CartListing.withSuccess("Item Removed Successfully");
        } else {
          _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return CartListing.withError("${jsonDecode(apiResponse.body)["data"]["message"]}");
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







