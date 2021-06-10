
import 'package:azaFashions/utils/BagCount.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'dart:convert' as JSON;
import 'dart:convert';
import 'package:azaFashions/models/Orders/CancelReasonsListing.dart';
import 'package:azaFashions/models/Profile/CountryList.dart';
import 'package:azaFashions/models/Profile/MeasurementList.dart';
import 'package:azaFashions/models/Orders/OrderItemListing.dart';
import 'package:azaFashions/models/Orders/OrderListing.dart';
import 'package:azaFashions/models/Profile/Points.dart';
import 'package:azaFashions/models/Profile/ProfileAddressList.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/models/Orders/TrackingDetails.dart';
import 'package:azaFashions/models/Profile/WishList.dart';
import 'package:azaFashions/networkprovider/LoginProvider.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider {
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

  //ADD ADDRESS
  Future<ResponseMessage> addAddress(
      BuildContext context, AddressModel addressModel) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path = addressModel.selection_type=="billing" || addressModel.selection_type=="shipping" || addressModel.selection_type=="identical"?  '${HeaderFile().baseUrl}checkout/address/add': '${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/address/add';

      String body = jsonEncode(addressModel);
      print("Body: $body");

      //headers

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        //response
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);
        print("Service API RES: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          _toastMsg.getLoginSuccess(context, "Your Address Added Successfully");
          return ResponseMessage.withSuccess("Your Address Added Successfully");
        } else {
          _toastMsg.getFailureMsg(context, "Adding Address Failed");
          return ResponseMessage.withError("Adding Address Failed");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<ProfileAddressList> getAddressList(BuildContext context,String addressType) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = addressType=="billing" || addressType=="shipping"?"${HeaderFile().baseUrl}checkout/address":"${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/address";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print("API RESPOMSE: ${apiResponse.body.toString()}");
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return ProfileAddressList.fromJson(jsonDecode(apiResponse.body));
        } else {
         // _toastMsg.getFailureMsg(context, "No Data Found");
          return ProfileAddressList.withError("No Data Found}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<ResponseMessage> removeAddress(
      BuildContext context, int addressId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path =
          '${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/address/remove/$addressId';

      //headers

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        //response
        apiResponse = await post(Uri.parse(path), headers: headers);
        print("Service API RES: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          _toastMsg.getLoginSuccess(
              context, "Your Address Removed Successfully");
          return ResponseMessage.withSuccess(
              "Your Address Removed Successfully");
        } else {
          _toastMsg.getFailureMsg(
              context, jsonDecode(apiResponse.body)["data"]["message"]);
          return ResponseMessage.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<ResponseMessage> updateAddress(
      BuildContext context, int addressId, AddressModel addressModel) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      print("ADDRESS MODEL: ${addressModel.selection_type}");

      String path =addressModel.selection_type=="billing" || addressModel.selection_type=="shipping" || addressModel.selection_type=="identical"?  '${HeaderFile().baseUrl}checkout/address/update/$addressId':
          '${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/address/update/$addressId';
      String body = jsonEncode(addressModel);
      print("Body: $body");

      //headers

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        //response
        apiResponse = await put(Uri.parse(path), headers: headers, body: body);
        print("Service API RES: ${jsonDecode(apiResponse.body)}");
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
         // _toastMsg.getLoginSuccess(context, "Your Address Updated Successfully");
          return ResponseMessage.withSuccess(
              "Your Address Updated Successfully");
        } else {

       //   _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["invalid_fields"][0]["message"]}");
          return ResponseMessage.withError("${jsonDecode(apiResponse.body)["data"]["invalid_fields"][0]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  //AccountDetails
  Future<UserLogin> accountDetails(context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path =
          "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/profile";

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);

        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          print("ACCOUNT JSON: ${apiResponse.body}");
          return UserLogin.fromJson(JSON.jsonDecode(apiResponse.body));
        } else {
          _toastMsg.getFailureMsg(context, "Failed to fetch Account Details");
          return UserLogin.withError("Failed to fetch Account Details");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<UserLogin> updateAccountDetails(context, UserLogin details) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path =
          "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/profile/update";

      Map<String, String> headers;

      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      Map<String, String> body = {
        "firstname": details.firstname,
        "lastname": details.lastname,
        "mobile": details.mobile,
        "dob": details.dob,
        "gender": details.gender
      };

      print(body);
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await put(Uri.parse(path), headers: headers, body: json.encode(body));
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {

          ToastMsg().getLoginSuccess(context, "Details updated successfully");
          return UserLogin.fromJson(JSON.jsonDecode(apiResponse.body));
        } else {
          _toastMsg.getFailureMsg(
              context,
              json
                  .decode(apiResponse.body)['data']['invalid_fields'][0]
              ['message']
                  .toString());
          return UserLogin.withError(
              "${json.decode(apiResponse.body)['data']['invalid_fields'][0]['message'].toString()}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  //Change Password
  Future<UserLogin> changePassword(
      context, String currPassword, String newPassword) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path =
          "${HeaderFile().baseUrl}accounts/${_sharedPreferences.getString("CustomerId")}/change-password";


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      Map<String, String> body = {
        "current_password": base64.encode(utf8.encode(currPassword)),
        "new_password": base64.encode(utf8.encode(newPassword))
      };

      print(json.encode(body));
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse =
        await http.put(Uri.parse(path), headers: headers, body: json.encode(body));
        Map<String, dynamic> respMessage = json.decode(apiResponse.body);
        print(respMessage);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

          sharedPreferences.remove("UserPassword");
          sharedPreferences.remove("UserEmail");

         sharedPreferences.commit();

          _toastMsg.getLoginSuccess(context, "Password Changed Successfully");
          return UserLogin.withSuccess("Password Changed Successfully");
        } else {
          if(jsonDecode(apiResponse.body)["data"]["code"]==708){
            _toastMsg.getFailureMsg(context,
                jsonDecode(apiResponse.body)["data"]['message'].toString());
            return UserLogin.withError(
                "${jsonDecode(apiResponse.body)["data"]['message'].toString()}");

          }
          else{
            _toastMsg.getFailureMsg(context,
                jsonDecode(apiResponse.body)["data"]["invalid_fields"][0]['message'].toString());
            return UserLogin.withError(
                "${jsonDecode(apiResponse.body)["data"]["invalid_fields"][0]['message'].toString()}");

          }
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  //Wallet , Credits , Points
  Future<PointsList> getPointsList(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path =
          "${HeaderFile().baseUrl}accounts/${_sharedPreferences.getString("CustomerId")}/wallet/summary";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return PointsList.fromJson(JSON.jsonDecode(apiResponse.body));
          ;
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return PointsList.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        _toastMsg.getInternetFailureMsg(context);
        return PointsList.withError(
            "${jsonDecode(apiResponse.body)["data"]["message"]}");
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<PointsList> getLoyaltyPointsList(
      BuildContext context,
      ) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path =
          "${HeaderFile().baseUrl}accounts/${_sharedPreferences.getString("CustomerId")}/loyalty-points/summary";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return PointsList.fromJson(JSON.jsonDecode(apiResponse.body));
          ;
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return PointsList.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        _toastMsg.getInternetFailureMsg(context);
        return PointsList.withError(
            "${jsonDecode(apiResponse.body)["data"]["message"]}");
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  //Wish List
  Future<WishListArray> getWishList(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path = "${HeaderFile().baseUrl}customers/products/wishlist";

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          print("WISHLIST API RESPONSE: ${json.decode(apiResponse.body)['data']}");
          return WishListArray.fromJson(json.decode(apiResponse.body)['data']);
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return WishListArray.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (e) {
      print(e);
      return _toastMsg.getFailureMsg(context, "Something Went Wrong");
    }
  }

  Future<WishListArray> getAddWishList(
      BuildContext context, int productId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path =
          "${HeaderFile().baseUrl}customers/products/wishlist/items/${productId}/add";


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers);
        print("WISHLIST RESPONSE: ${jsonDecode(apiResponse.body)}");

        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {


         _toastMsg.getLoginSuccess(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
         print("WISHLIST MESSAGE OF ITEM:${jsonDecode(apiResponse.body)["data"]["message"]} Removed From Your Wishlist");
         if(jsonDecode(apiResponse.body)["data"]["message"]=="Added to Your Wishlist"){
           BagCount.wishlistCount.value= BagCount.wishlistCount.value+1;
         }

        // await LoginProvider().getBagCount(context);
          return WishListArray.withSuccess("${jsonDecode(apiResponse.body)["data"]["message"]}");
        } else {
          _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return WishListArray.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (e) {
      print(e);
      return _toastMsg.getFailureMsg(context, "Something Went Wrong");
    }
  }

  Future<WishListArray> getRemoveWishList(
      BuildContext context, int productId,String source) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path =
          "${HeaderFile().baseUrl}customers/products/wishlist/items/${productId}/remove";


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
         source!=""?null: _toastMsg.getLoginSuccess(context, "Item successfully removed from wishlist");
         print("WISHLIST MESSAGE OF ITEM:${jsonDecode(apiResponse.body)["data"]["message"]} Removed From Your Wishlist");
         if(jsonDecode(apiResponse.body)["data"]["message"]=="Removed From Your Wishlist"){
           BagCount.wishlistCount.value= BagCount.wishlistCount.value-1;
         }

         // await LoginProvider().getBagCount(context);
          return WishListArray.withSuccess("Item successfully removed from wishlist");
        } else {
          _toastMsg.getFailureMsg(context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return WishListArray.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (e) {
      print(e);
      return _toastMsg.getFailureMsg(context, "Something Went Wrong");
    }
  }

  //Show Measurements
  Future<MeasurementList> getMeasurements(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path =
          "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/body-measurements";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          print(JSON.jsonDecode(apiResponse.body));
          return MeasurementList.fromJson(jsonDecode(apiResponse.body));
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return MeasurementList.withError(
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

  Future<Measurements> addMeasurements(
      BuildContext context, Measurements measurements) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      String path =
          "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/body-measurements/add";
      Response apiResponse;

      var body = {};

      if (measurements.gender.toLowerCase() == "male") {
        body = {
          "gender": measurements.gender.toLowerCase(),
          "title": measurements.title,
          "chest": measurements.maleMeasurement.chest!=null?measurements.maleMeasurement.chest:0,
          "waist": measurements.maleMeasurement.waist!=null?measurements.maleMeasurement.waist:0,
          "hips": measurements.maleMeasurement.hips!=null?measurements.maleMeasurement.hips:0,
          "shoulder_length": measurements.maleMeasurement.shoulderLength!=null?measurements.maleMeasurement.shoulderLength:0,
        };
      } else {
        Map frontMeasurements = {
          "cap_sleeve_length":
          measurements.measurementDetails.frontBody.capSleeveLength!=null?measurements.measurementDetails.frontBody.capSleeveLength:0,
          "neck": measurements.measurementDetails.frontBody.frontNeck!=null?measurements.measurementDetails.frontBody.frontNeck:0,
          "shoulder_length":
          measurements.measurementDetails.frontBody.shoulderLength!=null?measurements.measurementDetails.frontBody.shoulderLength:0,
          "short_sleeve_length":
          measurements.measurementDetails.frontBody.shortSleeveLength!=null?measurements.measurementDetails.frontBody.shortSleeveLength:0,
          "bust": measurements.measurementDetails.frontBody.bust!=null?measurements.measurementDetails.frontBody.bust:0,
          "under_bust": measurements.measurementDetails.frontBody.underBust!=null?measurements.measurementDetails.frontBody.underBust:0,
          "sleeve_length":
          measurements.measurementDetails.frontBody.sleeveLength!=null?measurements.measurementDetails.frontBody.sleeveLength:0,
          "waist": measurements.measurementDetails.frontBody.waist!=null?measurements.measurementDetails.frontBody.waist:0,
          "hips": measurements.measurementDetails.frontBody.hips!=null?measurements.measurementDetails.frontBody.hips:0
        };

        Map backMeasurements = {
          "neck": measurements.measurementDetails.backBody.neck!=null?measurements.measurementDetails.backBody.neck:0,
          "shoulder_to_apex":
          measurements.measurementDetails.backBody.shoulderApex!=null?measurements.measurementDetails.backBody.shoulderApex:0,
          "neck_depth": measurements.measurementDetails.backBody.backNeckDepth!=null? measurements.measurementDetails.backBody.backNeckDepth:0,
          "bicep": measurements.measurementDetails.backBody.bicep!=null?measurements.measurementDetails.backBody.bicep:0,
          "elbow_round": measurements.measurementDetails.backBody.elbowRound!=null?measurements.measurementDetails.backBody.elbowRound:0,
          "knee_length": measurements.measurementDetails.backBody.kneeLength!=null?measurements.measurementDetails.backBody.kneeLength:0,
          "bottom_length": measurements.measurementDetails.backBody.bottomLength!=null?measurements.measurementDetails.backBody.bottomLength:0
        };
        body = {
          "gender": measurements.gender.toLowerCase(),
          "title": measurements.title,
          "front": frontMeasurements,
          "back": backMeasurements
        };
      }


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse =
        await post(Uri.parse(path), headers: headers, body: json.encode(body));
        print((apiResponse.body));
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          _toastMsg.getLoginSuccess(context, "Measurement Added Successfully");
          return Measurements.withSuccess("Measurement Added Successfully");
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return Measurements.withError("Something Went Wrong");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      print(Exception);
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<Measurements> updateMeasurements(
      BuildContext context, Measurements measurements) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path =
          "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/body-measurements/update/${measurements.id}";
      Response apiResponse;
      var body;
      print(measurements.toJson());
      if (measurements.gender == "Male") {
        body = {
          "gender": measurements.gender.toLowerCase(),
          "title": measurements.title,
          "chest": measurements.maleMeasurement.chest,
          "waist": measurements.maleMeasurement.waist,
          "hips": measurements.maleMeasurement.hips,
          "shoulder_length": measurements.maleMeasurement.shoulderLength,
        };
      } else {
        body = {
          "gender": "female",
          "title": measurements.title,
          "front": {
            "cap_sleeve_length":
            measurements.measurementDetails.frontBody.capSleeveLength,
            "neck": measurements.measurementDetails.frontBody.frontNeck,
            "shoulder_length":
            measurements.measurementDetails.frontBody.shoulderLength,
            "short_sleeve_length":
            measurements.measurementDetails.frontBody.shortSleeveLength,
            "bust": measurements.measurementDetails.frontBody.bust,
            "under_bust": measurements.measurementDetails.frontBody.underBust,
            "sleeve_length":
            measurements.measurementDetails.frontBody.sleeveLength,
            "waist": measurements.measurementDetails.frontBody.waist,
            "hips": measurements.measurementDetails.frontBody.hips
          },
          "back": {
            "neck": measurements.measurementDetails.backBody.neck,
            "shoulder_to_apex":
            measurements.measurementDetails.backBody.shoulderApex,
            "neck_depth":
            measurements.measurementDetails.backBody.backNeckDepth,
            "bicep": measurements.measurementDetails.backBody.bicep,
            "elbow_round": measurements.measurementDetails.backBody.elbowRound,
            "knee_length": measurements.measurementDetails.backBody.kneeLength,
            "bottom_length":
            measurements.measurementDetails.backBody.bottomLength
          }
        };
      }



      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        print(json.encode(body).toString());
        apiResponse =
        await put(Uri.parse(path), headers: headers, body: json.encode(body));
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          _toastMsg.getLoginSuccess(
              context, "Measurement Updated Successfully!");
          return Measurements.withSuccess(
              jsonDecode(apiResponse.body)['message']);
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return Measurements.withError(
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

  Future<Measurements> removeMeasurements(
      BuildContext context, int measurementId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path =
          "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/body-measurements/remove/$measurementId";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers);
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          _toastMsg.getLoginSuccess(
              context, "Measurement Removed Successfully");
          return Measurements.withSuccess("Measurement Removed Successfully");
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return Measurements.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  //Order
  Future<OrderListing> getOrdersList(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path =
          "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/orders";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      print("PATH OF ORDER LISTING: $path ${_sharedPreferences.getString("XTrailId")}");
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print("ORDER LISTING: ${apiResponse.body}");

        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          print("ORDER DATA: ${jsonDecode(apiResponse.body)}");
          return OrderListing.fromJson(jsonDecode(apiResponse.body));
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return OrderListing.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      print("EXCEPTION: ${Exception.toString()}");
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<OrderItemList> getOrdersItemList(BuildContext context, int id) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path =
          "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/orders/$id";
      Response apiResponse;

      print("TRAILS ID: ${_sharedPreferences.getString("XTrailId")}");

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          print("ORDER DETAIL LISTING : ${JSON.jsonDecode(apiResponse.body)}");
          return OrderItemList.fromJson(jsonDecode(apiResponse.body));
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return OrderItemList.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      return _toastMsg.getSomethingWentWrong(context);
    }
  }
  Future<OrderItemList> shareProductFeedback(BuildContext context, int orderId,int itemId,int rating,String comment) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/orders/${orderId}/items/${itemId}/record-delivery-feedback";
      print("FEEDBACK PATH :$path");

      Response apiResponse;

      print("TRAILS ID: ${_sharedPreferences.getString("XTrailId")}");

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      Map<String, dynamic> body = {
        "rating":rating,
        "comment":comment
      };
      print("BODY : ${jsonEncode(body)}");

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers,body: jsonEncode(body));
        print("RESPONSE: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          print("ORDER DETAIL LISTING : ${JSON.jsonDecode(apiResponse.body)}");
          return OrderItemList.withSuccess("Thanks for your Feedback");
        } else {
          return OrderItemList.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      } else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    } catch (Exception) {
      print("EXCEPGION: ${Exception.toString()}");
      return _toastMsg.getSomethingWentWrong(context);
    }
  }


  Future<CancelReasonsListing> cancelItem(
      context, CancelReasons reasons, int orderId, int itemId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/orders/${orderId}/items/${itemId}/cancel";

      Response apiResponse;
      Map<String, dynamic> body = {
        "reason_id": reasons.id.toString(),
        "quantity": reasons.qty,
        "comments": reasons.comments
      };


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers, body: jsonEncode(body));
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          _toastMsg.getLoginSuccess(context, "Your Item has been Cancelled.");
          return CancelReasonsListing.withSuccess(jsonDecode(apiResponse.body)['message']);
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return CancelReasonsListing.withError(
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

  Future<CancelReasonsListing> cancelReasons(context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}order-cancellation/reasons";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          return CancelReasonsListing.fromJson(jsonDecode(apiResponse.body));
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return CancelReasonsListing.withError(
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

  Future<TrackingDetails> trackItems(
      context, String orderId, String itemId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path =
          "${HeaderFile().baseUrl}customers/${_sharedPreferences.getString("CustomerId")}/orders/$orderId/items/$itemId/track";
      Response apiResponse;


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          return TrackingDetails.fromJson(jsonDecode(apiResponse.body));
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return TrackingDetails.withError(
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

  Future<CountryStateList> autoCompleteCountry(context,int id, String title) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "";
      title == "state" || title != null
          ? path = "${HeaderFile().baseUrl}autocomplete/$title?country_id=$id"
          : path = "${HeaderFile().baseUrl}autocomplete/$title";


      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print(apiResponse.body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          print(apiResponse.body);
          return CountryStateList.fromJson(JSON.jsonDecode(apiResponse.body));
        } else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return CountryStateList.withError(
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
}
