import 'dart:convert';

import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/models/Login/Registration.dart';
import 'package:azaFashions/models/Login/SideNavigationModel.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class SessionDetails {
  //Shared Preference
  void saveTrailId(String trailId, String customer_id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("XTrailId", trailId);
    sharedPreferences.setString("CustomerId", customer_id);
    print("TrailId: ${trailId}");
    sharedPreferences.commit();
  }
  void loginStatus(bool status) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("loginStatus", status);
    sharedPreferences.commit();
  }
  void locationStatus(bool status) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("locationStatus", status);
    sharedPreferences.commit();
  }

  void saveLoginDetails(String email, String password, bool remember) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("UserEmail", email);
    sharedPreferences.setString("UserPassword", password);
    sharedPreferences.setBool("Remember", remember);
    sharedPreferences.commit();
  }

  void saveUserDetails(UserLogin userLogin) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String user_details = jsonEncode(userLogin);
    sharedPreferences.setString("userDetails", user_details);
    sharedPreferences.commit();
  }

  void saveSideNavigation(SideNavigationModel sideNavigation) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String sideNavigation_details = jsonEncode(sideNavigation);
    sharedPreferences.setString("sideNavigation", sideNavigation_details);
    sharedPreferences.commit();
  }

  saveIntroScreens(List<IntroModel> introScreens) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String json = jsonEncode(introScreens.map((i) => i.toJson()).toList()).toString();
    preferences.setString("introScreens", json);
    preferences.commit();
  }

  void clearIntroScreens() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("introScreens");
  }

  clearSessionDetails() async{
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.remove("XTrailId");
    _sharedPreferences.remove("CustomerId");
    _sharedPreferences.remove("userDetails");
    _sharedPreferences.commit();

  }

  void clearLoginDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("UserEmail");
    sharedPreferences.remove("UserPassword");
    sharedPreferences.remove("Remember");
    sharedPreferences.commit();
  }




  //Save Support Details

  saveSupportDetails(String whatsApp,String emailSupport,String mobileSupport) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("whatsAppSupport", whatsApp);
    preferences.setString("emailSupport", emailSupport);
    preferences.setString("mobileSupport", mobileSupport);
  }
  //Save Introduction Details

  saveIntroDetails(String header,String content,String img) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("header", header);
    preferences.setString("content", content);
    preferences.setString("img", img);
    preferences.commit();
  }

  //Shared Preference
  void skippedIntro(bool skippedIntro) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("skippedIntro", skippedIntro);
    sharedPreferences.commit();
  }

  //Shared Preference
  void browseAsGuest(bool browseAsGuest) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("browseAsGuest", browseAsGuest);
    sharedPreferences.commit();
  }
  void browseAsGuestCounter(int counter) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("guestCounter", counter);
    sharedPreferences.commit();
  }

  //Shared Preference
  void saveLocation(String saveLocation,String countryCode,String currency,String currencyCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("saveLocation", saveLocation);
    sharedPreferences.setString("country_dial_code", countryCode);
    sharedPreferences.setString("currencySymbol", currency);
    sharedPreferences.setString("currency_code", currencyCode);

    sharedPreferences.commit();
  }

  void clearGuestData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("browseAsGuest");
    sharedPreferences.commit();
  }

  void clearSessionData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("achievedGoals");
    sharedPreferences.remove("newGoals");
    sharedPreferences.remove("actionable");
    sharedPreferences.remove("comments");
    sharedPreferences.remove("questionList");
    sharedPreferences.remove("avgRating");
    sharedPreferences.remove("tempId");
    sharedPreferences.remove("resId");
    sharedPreferences.remove("serviceId");
    sharedPreferences.remove("clientId");
    sharedPreferences.commit();
  }

  void clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("user_token");
    sharedPreferences.remove("userName");
    sharedPreferences.remove("userId");
    sharedPreferences.remove("feedBackReportAccess");
    sharedPreferences.remove("isAdmin");
    sharedPreferences.commit();
  }
}
