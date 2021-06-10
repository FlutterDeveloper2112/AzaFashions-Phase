
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'dart:convert';
import 'package:azaFashions/models/Login/BulletMenuList.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/models/Login/Registration.dart';
import 'package:azaFashions/models/Login/SocialLoginModel.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:azaFashions/utils/CountryInfo.dart';

import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/utils/InternetConnection.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:country_codes/country_codes.dart';
import 'package:crypto/crypto.dart';
import 'package:currency_pickers/currency_pickers.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider {
  InternetConnection _internetConnection = new InternetConnection();
  ToastMsg _toastMsg = new ToastMsg();
  var _internetStatus;
  String currentLocation = "";
  LocationData curLocation;
  SessionDetails _sessionDetails = SessionDetails();
  SharedPreferences _sharedPreferences;
  String _locale;
  static String htmlRes = "";

  Future<bool> getBrowseAsGuest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("browseAsGuest");
  }

  Future<IntroModelList> getIntroScreenList(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String path = "${HeaderFile().baseUrl}app-bootstrap";
      Response apiResponse;

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      print(path);
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        print("APP BOOTSTRAP RESPONSE: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          print(apiResponse.body);
              _sessionDetails.saveTrailId(apiResponse.headers["x-trail-id"].toString(), _sharedPreferences.getString("CustomerId")!=null || _sharedPreferences.getString("CustomerId")!=""? _sharedPreferences.getString("CustomerId"):"");
          return IntroModelList.fromJson(jsonDecode(apiResponse.body));
        }
        else {
          _toastMsg.getFailureMsg(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
          return IntroModelList.withError(
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

  //Registration Api
  Future<UserLogin> registrationApi(BuildContext context, Registration registration) async {
    try {
      String body = jsonEncode(registration);
      _sharedPreferences= await SharedPreferences.getInstance();
      print("Registration Data: ${body}");

      Response apiResponse;
      String path = '${HeaderFile().baseUrl}accounts/customer/registration';

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        //response
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);

        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          print("REGIS RESP: ${jsonDecode(apiResponse.body)} ${jsonDecode(apiResponse.body)["data"]["cutsomer_id"].toString()}");

          _sessionDetails.saveTrailId(
              apiResponse.headers["x-trail-id"].toString(),
              jsonDecode(apiResponse.body)["data"]["customer_id"].toString());
          UserTrackingDetails().signUpDetails(jsonDecode(apiResponse.body)["data"]["email"],jsonDecode(apiResponse.body)["data"]["customer_id"].toString(),jsonDecode(apiResponse.body)["data"]["firstname"],jsonDecode(apiResponse.body)["data"]["lastname"],jsonDecode(apiResponse.body)["data"]["mobile"].toString());
          //_toastMsg.getLoginSuccess(context, "Registeration Successful");
          return UserLogin.fromJson(jsonDecode(apiResponse.body));
        }
        else {
     /*     jsonDecode(apiResponse.body)["data"]["message"]!=null && jsonDecode(apiResponse.body)["data"]["message"]!=""? _toastMsg.getFailureMsg(
              context,"${jsonDecode(apiResponse.body)["data"]["message"]}") : "";
     */     return UserLogin.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print("SIGN UP Exception: ${Exception.toString()}");
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<UserLogin> loginWithCredentials(String username, String password, BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path = '${HeaderFile().baseUrl}accounts/customer/login';

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      String body = '{"username":  "$username", "password":"${base64.encode(utf8.encode(password))}"}';
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) { //response
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          _sessionDetails.saveTrailId(
              apiResponse.headers["x-trail-id"].toString(),
              jsonDecode(apiResponse.body)["data"]["customer_id"].toString());
          await getBagCount(context);
          UserTrackingDetails().signInDetails(username,jsonDecode(apiResponse.body)["data"]["customer_id"].toString());
          return UserLogin.fromJson(jsonDecode(apiResponse.body)["data"]);
        }
        else {
       /*   jsonDecode(apiResponse.body)["data"]["message"]!=null && jsonDecode(apiResponse.body)["data"]["message"]!=""? _toastMsg.getFailureMsg(
              context,"${jsonDecode(apiResponse.body)["data"]["message"]}") : "";
       */   return UserLogin.withError(
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

  bool isFacebookLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  Future<SocialLoginModel> login_facebook(BuildContext context) async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _internetStatus = await _internetConnection.checkInternet(context);
    logout_facebook();
    try {
      if (_internetStatus) {
        facebookLogin.loginBehavior=FacebookLoginBehavior.webViewOnly;
        final result = await facebookLogin.logIn(['email','public_profile','user_friends']);
        print(result.status);
        print("STATUS ${result.status}");

        if (FacebookLoginStatus.loggedIn != null) {
          isFacebookLoggedIn = true;
          if(result.status.toString().contains("FacebookLoginStatus.cancelledByUser")){
            SocialLoginModel().error="";
            return SocialLoginModel.withError("Facebook Login Cancelled.");
          }
          else{
            final fbToken = result.accessToken.token;
            final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${fbToken}'));

            return SocialLoginModel.fromJson(jsonDecode(graphResponse.body), fbToken, "facebook",md5.convert(utf8.encode(result.accessToken.userId)).toString());
          }
        }
        else {
          SocialLoginModel().error="";
          return SocialLoginModel.withError("Login Failed");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }

    catch (Exception) {
      print("FB Exception:${Exception.toString()}");
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  bool isGoogleLoggedIn = false;
  GoogleSignIn _googleSignIn = new GoogleSignIn(scopes: ['email']);


  Future<SocialLoginModel> login_google(BuildContext context) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _internetStatus = await _internetConnection.checkInternet(context);
    try {
      if (_internetStatus) {
        logout_google();
        final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
        if (googleSignInAccount != null) {
          if (googleSignInAccount.authentication != null) {
            final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
             isGoogleLoggedIn = true;

            return SocialLoginModel(
                email: _googleSignIn.currentUser.email,
                token: googleSignInAuthentication.idToken,
                name: _googleSignIn.currentUser.displayName,
                type: "gmail",
                social_id: md5.convert(utf8.encode(_googleSignIn.currentUser.id)).toString());
          }
          else {
            _googleSignIn.signOut();

            isGoogleLoggedIn = false;

            return SocialLoginModel.withError("Google Login Failed");
          }
        }
        else {
          return SocialLoginModel.withError("Google Login Failed");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print("EXCEPTION: ${Exception.toString()}");
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  Future<SocialLoginModel> login_apple(BuildContext context) async {
    try{
      if(await AppleSignIn.isAvailable()) {
        final AuthorizationResult result = await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
        ]);
        SocialLoginModel().error = "";
        switch (result.status) {
          case AuthorizationStatus.authorized:
            print(result);
            final appleToken = result.credential.authorizationCode;
            print("AUTHORISED TOKEN: ${String.fromCharCodes(appleToken)}");
            print("ID TOKEN: ${String.fromCharCodes(result.credential.identityToken)}");


            Map<String,dynamic> body = {
              "email" : result.credential.email,
              "name" : result.credential.fullName.givenName
            };
            return SocialLoginModel.fromJson(body,String.fromCharCodes(result.credential.identityToken), "apple",md5.convert(utf8.encode(result.credential.user)).toString());
            break;//All the required credentials
            case AuthorizationStatus.error:
            return SocialLoginModel.withError(result.error.localizedDescription);
            print("Sign in failed: ${result.error.localizedDescription}");
            break;
            case AuthorizationStatus.cancelled:
            return SocialLoginModel.withError(result.error.localizedDescription);
            break;
        }



      }
      else{
        return _toastMsg.getFailureMsg(context, "Apple SignIn is not available for your device'");
      }
    }
    catch(Exception){

    }
  }

  logout_google() {
    _googleSignIn.signOut();
    isGoogleLoggedIn = false;
  }

  logout_facebook() {
    facebookLogin.logOut();
    isFacebookLoggedIn = false;
  }


  Future<UserLogin> socialLoginApi(BuildContext context, SocialLoginModel socialLogin) async {
    try {
      Response apiResponse;
      String path = '${HeaderFile().baseUrl}accounts/customer/social-login';

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      String body = jsonEncode(socialLogin);
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);

        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          _sessionDetails.saveTrailId(apiResponse.headers["x-trail-id"].toString(), jsonDecode(apiResponse.body)["data"]["customer_id"].toString());
          _toastMsg.getLoginSuccess(context, "Login Successful");
          UserTrackingDetails().signInDetails(jsonDecode(apiResponse.body)["data"]["email"],jsonDecode(apiResponse.body)["data"]["customer_id"].toString());
          print("USER DATA: ${apiResponse.body.toString()}");
          return UserLogin.fromJson(jsonDecode(apiResponse.body));
        }
        else {
          jsonDecode(apiResponse.body)["data"]["message"]!=null && jsonDecode(apiResponse.body)["data"]["message"]!=""? _toastMsg.getFailureMsg(
              context,"${jsonDecode(apiResponse.body)["data"]["message"]}") : "";
          return UserLogin.withError("${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print("EXCeption: $Exception");
      return _toastMsg.getSomethingWentWrong(context);
    }
  }

  //ForgetPassword API
  Future<ResponseMessage> forgetPasswordApi(BuildContext context, String emailId) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path = '${HeaderFile().baseUrl}accounts/customer/forgot-password';

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      print("email: $emailId");
      String body = '{"email":  "$emailId"}';
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) { //response
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);

        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          var data = jsonDecode(apiResponse.body);

          UserTrackingDetails().forgetPassword(emailId);

        /*  _toastMsg.getLoginSuccess(
              context, "${jsonDecode(apiResponse.body)["data"]["message"]}");
        */  return ResponseMessage.withSuccess("${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
        else {
     /*     jsonDecode(apiResponse.body)["data"]["message"]!=null && jsonDecode(apiResponse.body)["data"]["message"]!=""? _toastMsg.getFailureMsg(
              context,"${jsonDecode(apiResponse.body)["data"]["message"]}") : "";
     */     return ResponseMessage.withError(
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

  //OTP
  Future<ResponseMessage> sendOTP(BuildContext context, String intent,String mobileNo, String email, String customer_id) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path = '${HeaderFile().baseUrl}otp/send';

      String body = '{"intent": "${intent}","communicator": "mobile","mobile": "$mobileNo","email": "$email"}';


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      print("TRAILS ID: ${ _sharedPreferences.getString("XTrailId")}");
      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        //response
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);

        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
          UserTrackingDetails().otpSent(mobileNo);
        return ResponseMessage.withSuccess(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
        else {
         /* jsonDecode(apiResponse.body)["data"]["message"]!=null && jsonDecode(apiResponse.body)["data"]["message"]!=""? _toastMsg.getFailureMsg(
              context,"${jsonDecode(apiResponse.body)["data"]["message"]}") : "";
         */ return ResponseMessage.withError(
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
  Future<ResponseMessage> verifyOTP(BuildContext context,String intent, int otp, String mobileNo, String email, String customer_id) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path = '${HeaderFile().baseUrl}otp/verify';

      String body = '{"intent": "${intent}","communicator": "mobile","otp": $otp,"mobile": "$mobileNo","email": "$email"}';
      print("Body: $body");

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        //response
        apiResponse = await post(Uri.parse(path), headers: headers, body: body);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {
       /*   _toastMsg.getLoginSuccess(
              context, " ${jsonDecode(apiResponse.body)["data"]["message"]}");
       */   return ResponseMessage.withSuccess(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
        else {
        /*  jsonDecode(apiResponse.body)["data"]["message"]!=null && jsonDecode(apiResponse.body)["data"]["message"]!=""? _toastMsg.getFailureMsg(
              context,"${jsonDecode(apiResponse.body)["data"]["message"]}") : "";
        */  return ResponseMessage.withError(
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

  Future<void> initPlatformState() async {
    String currentLocale;
    try {
      CountryInfo.currencySymbol=IntroModelList.currency_symbol;
      print((currentLocale != null)
          ? currentLocale
          : "Unable to get currentLocale");
    } on PlatformException {
      print("Error obtaining current locale");
    }

  }

  Future<String> getUserLocation(BuildContext context) async {
   await initPlatformState();
    IntroModelList.locationStatus=true;
    LocationData myLocation;
    Locale locale = Localizations.localeOf(context);

    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
      curLocation = myLocation;
      final coordinates = new Coordinates(myLocation.latitude, myLocation.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      currentLocation = ' ${first.countryName},${first.countryCode},${first.adminArea} ${first.locality} : ${first.postalCode} ,${first.subLocality},${first.addressLine} ';
      CountryDetails details = CountryCodes.detailsForLocale();
      CountryInfo.location=currentLocation;
      CountryInfo.currencySymbol=IntroModelList.currency_symbol;
      CountryInfo.countryDialCode=details.dialCode;
    }
    on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
      currentLocation = "Denied";
    }
    print("CurrentLocation: $currentLocation");
    return currentLocation;
  }



  //HomeData
  Future<BulletMenuList> homeApi(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path = '${HeaderFile().baseUrl}home';


      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        //response
        apiResponse = await get(Uri.parse(path), headers: headers);

        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {

          return BulletMenuList.fromJson(jsonDecode(apiResponse.body));
        }
        else {
          return BulletMenuList.withError(
              "${jsonDecode(apiResponse.body)["data"]["message"]}");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print("EXCEPTION: ${Exception.toString()}");
      return _toastMsg.getSomethingWentWrong(context);
    }
  }
  Future<ResponseMessage> getBagCount(BuildContext context) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      Response apiResponse;
      String path = '${HeaderFile().baseUrl}accounts/insights';

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        //response
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 && jsonDecode(apiResponse.body)["message"] == "Success") {
          BagCount.bagCount.value=jsonDecode(apiResponse.body)["data"]["cart_count"];
          BagCount.wishlistCount.value=jsonDecode(apiResponse.body)["data"]["wishlist_count"];
          BagCount.news_letter=jsonDecode(apiResponse.body)["data"]["newsletter_subscribed"];
          print("BAG COUNT: ${jsonDecode(apiResponse.body)["data"]["cart_count"]} ${jsonDecode(apiResponse.body)["data"]["wishlist_count"]}${jsonDecode(apiResponse.body)["data"]["newsletter_subscribed"]}");

          return ResponseMessage.withSuccess("Success");
        }
        else {
          return ResponseMessage.withError("No Data found");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
      print("PRINTING: ${Exception.toString()}");
      return _toastMsg.getSomethingWentWrong(context);
    }
  }


  //Logout
  Future<ResponseMessage>logout(context) async {
    try {

      Response apiResponse;
      String path = "${HeaderFile().baseUrl}accounts/customer/logout";

      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});


      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await post(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 &&
            jsonDecode(apiResponse.body)["message"] == "Success") {

          await getBagCount(context);
          return ResponseMessage.withSuccess("Logout Successfully");
        }
        else {
          return ResponseMessage.withError("${jsonDecode(apiResponse.body)["message"]}");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (e) {
      print(e);
      return _toastMsg.getFailureMsg(context, "Something Went Wrong");
    }
  }


  html(BuildContext context,String url) async {
    try {
      Response apiResponse;
      url = url.replaceFirst("/", "");
      String path = "${HeaderFile().baseUrl}$url";

      print(path);
      Map<String, String> headers;
      await HeaderFile().getHeaderDetails(context).then((value) {headers=value;});

      _internetStatus = await _internetConnection.checkInternet(context);
      if (_internetStatus) {
        apiResponse = await get(Uri.parse(path), headers: headers);
        if (apiResponse.statusCode == 200 ) {
          print(apiResponse.body);
          htmlRes = apiResponse.body.toString();
        }
        else {
          return _toastMsg.getFailureMsg(context, "Something Went Wrong");

          // return ResponseMessage.withError("${jsonDecode(apiResponse.body)["message"]}");
        }
      }
      else {
        return _toastMsg.getInternetFailureMsg(context);
      }
    }
    catch (e) {
      print(e);
      return _toastMsg.getFailureMsg(context, "Something Went Wrong");
    }
  }




}







