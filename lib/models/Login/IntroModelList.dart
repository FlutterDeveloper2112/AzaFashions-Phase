

import 'package:azaFashions/models/Login/SideNavigationModel.dart';
import 'package:azaFashions/utils/SessionDetails.dart';

class IntroModelList {
  List<IntroModel> intro_model;
  SideNavigationModel sideNavigationModel;
  String error,success;

  String whatsAppLink;
  String emailLink;
  String mobileLink;
  static int maintenanceMode,force_update;
  static bool loginSessionStatus,locationStatus=false;
  static String currency_iso_code,country_iso_code,currency_symbol;
  IntroModelList({this.intro_model});

  IntroModelList.withError(String errorMessage) {
    error = errorMessage;
  }
  IntroModelList.withSuccess(String successMessage) {
    success = successMessage;
  }


  IntroModelList.fromJson(Map<String, dynamic> json) {
    SessionDetails details = SessionDetails();

    print(json['data'].containsKey('introductory_screens'));
    country_iso_code=json["data"].containsKey("country_iso_code")?json["data"]["country_iso_code"]:null;
    currency_symbol=json["data"].containsKey("currency")?json["data"]["currency"]["title"]:null;
    whatsAppLink = json['data'].containsKey('whatsapp_link')?json['data']['whatsapp_link']:null;
    emailLink = json['data'].containsKey('support_email')?json['data']['support_email']:null;
    mobileLink = json['data'].containsKey('support_mobile')?json['data']['support_mobile']:null;
    maintenanceMode = json['data'].containsKey('maintenance_mode')?json["data"]['maintenance_mode"']:null;
    force_update = json['data'].containsKey('force_update')?json["data"]['force_update"']:null;
    loginSessionStatus=json['data'].containsKey('is_logged_in')?json["data"]["is_logged_in"]:null;

    if (json["data"]["introductory_screens"] != null) {
      intro_model = new List<IntroModel>();

      json["data"]["introductory_screens"] .forEach((v) {    SessionDetails details = SessionDetails();

      whatsAppLink = json['data'].containsKey('whatsapp_link')?json['data']['whatsapp_link']:null;
      emailLink = json['data'].containsKey('support_email')?json['data']['support_email']:null;
      mobileLink = json['data'].containsKey('support_mobile')?json['data']['support_mobile']:null;
      loginSessionStatus=json['data'].containsKey('is_logged_in')?json["data"]["is_logged_in"]:null;

      if (json["data"]["introductory_screens"] != null) {
        intro_model = new List<IntroModel>();

        json["data"]["introductory_screens"] .forEach((v) {
          intro_model.add(new IntroModel.fromJson(v));
          details.saveIntroScreens(intro_model);
        });
        details.saveIntroDetails(intro_model[intro_model.length-1].header, intro_model[intro_model.length-1].content, intro_model[intro_model.length-1].image);
      }

      if (json["data"]["side_navigation"] != null) {
        sideNavigationModel = SideNavigationModel.fromJson(json["data"]);
        SessionDetails sessionDetails = new SessionDetails();
        sessionDetails.saveSideNavigation(SideNavigationModel(
            mainListing:
            MainListing.fromJson(json['data']["side_navigation"]["main"]),
            azaListing:
            AzaListing.fromJson(json['data']["side_navigation"]["aza"]),
            buyingGuideList: BuyingGuideList.fromJson(
                json['data']["side_navigation"]["buying_guide"]),
            policyList: PolicyList.fromJson(
                json['data']["side_navigation"]["policies"])));
      }
      details.saveSupportDetails(whatsAppLink, emailLink, mobileLink);

      intro_model.add(new IntroModel.fromJson(v));
      details.saveIntroScreens(intro_model);
      });
      details.saveIntroDetails(intro_model[intro_model.length-1].header, intro_model[intro_model.length-1].content, intro_model[intro_model.length-1].image);
    }

    if (json["data"]["side_navigation"] != null) {
      sideNavigationModel = SideNavigationModel.fromJson(json["data"]);
      SessionDetails sessionDetails = new SessionDetails();
      sessionDetails.saveSideNavigation(SideNavigationModel(
          mainListing:
          MainListing.fromJson(json['data']["side_navigation"]["main"]),
          azaListing:
          AzaListing.fromJson(json['data']["side_navigation"]["aza"]),
          buyingGuideList: BuyingGuideList.fromJson(
              json['data']["side_navigation"]["buying_guide"]),
          policyList: PolicyList.fromJson(
              json['data']["side_navigation"]["policies"])));
    }
    details.saveSupportDetails(whatsAppLink, emailLink, mobileLink);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["introductory_screens"] = intro_model.map((e) => e.toString());
    jsonData["side_navigation"] = SideNavigationModel();
    jsonData["whatsapp_link"] = whatsAppLink;
    jsonData["support_email"] = emailLink;
    jsonData["support_mobile"] = mobileLink;
    return jsonData;
  }

}

class IntroModel {
  String header;
  String content;
  String image;
  IntroModel({this.header, this.content, this.image});
  factory IntroModel.fromJson(Map<String, dynamic> json) {
    return IntroModel(
        header: json["header"], content: json["content"], image: json["image"]);
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['header'] = header;
    jsonData['content'] = content;
    jsonData['image'] = image;
    return jsonData;
  }
}








