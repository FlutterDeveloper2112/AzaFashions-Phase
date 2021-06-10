
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class UserLogin {
  String customer_id;
  String firstname, lastname;
  String email;
  String dob;
  String gender, mobile;
  String referral_code;
  String error="",success="";

  UserLogin({
    this.customer_id,
    this.firstname, this.lastname,
    this.email,
    this.dob,
    this.gender,
    this.mobile,
    this.referral_code
  });

  UserLogin.withError(String errorMessage) {
    success  = "";
    error = errorMessage;
  }

  UserLogin.withSuccess(String successMessage) {
    success = successMessage;
  }



  UserLogin.fromJson(Map<String, dynamic> json) {
    success  = "Details Updated Successfully";
    if(json.toString().contains("data")){
      customer_id = json["data"]['customer_id'].toString();
      firstname = json["data"]['firstname'].toString();
      lastname = json["data"]['lastname'].toString();
      email = json["data"]['email'].toString();
      dob = json["data"]['dob'].toString();
      gender = json["data"]['gender'].toString()=="Male"? "1" : json["data"]['gender'].toString()=="Female"?"2": json["data"]['gender'].toString()=="Others"?"0":json['data']['gender'].toString();
      mobile = json["data"]['mobile'].toString();
      referral_code = json["data"]['referral_code'].toString();
      SessionDetails sessionDetails= new SessionDetails();
      sessionDetails.saveUserDetails(UserLogin(customer_id:customer_id,firstname:firstname,lastname:lastname,email:email,dob:dob,gender:gender,mobile:mobile,referral_code: referral_code));
      WebEngagePlugin.setUserAttribute('Customer Id', json["data"]['customer_id'].toString());
      WebEngagePlugin.setUserFirstName(json["data"]['firstname'].toString());
      WebEngagePlugin.setUserLastName(json["data"]['lastname'].toString());
      WebEngagePlugin.setUserPhone(json["data"]['mobile'].toString());

    }
    else{

      customer_id = json['customer_id'].toString();
      firstname = json['firstname'].toString();
      lastname = json['lastname'].toString();
      email = json['email'].toString();
      dob = json['dob'].toString();
      gender = json['gender'].toString()=="Male"? "1" : json['gender'].toString()=="Female"?"2": json['gender'].toString()=="Others"?"0":json['gender'].toString();
      mobile = json['mobile'].toString();
      referral_code = json['referral_code'].toString();
      SessionDetails sessionDetails= new SessionDetails();
      sessionDetails.saveUserDetails(UserLogin(customer_id:customer_id,firstname:firstname,lastname:lastname,email:email,dob:dob,gender:gender,mobile:mobile,referral_code: referral_code));
      WebEngagePlugin.setUserAttribute('Customer Id', json['customer_id'].toString());
      WebEngagePlugin.setUserFirstName(json['firstname'].toString());
      WebEngagePlugin.setUserLastName(json['lastname'].toString());
      WebEngagePlugin.setUserPhone(json['mobile'].toString());

    }
  }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["customer_id"] = customer_id;
    jsonData["firstname"] = firstname;
    jsonData["lastname"] = lastname;
    jsonData["email"] = email;
    jsonData["dob"] = dob;
    jsonData["gender"] = gender;
    jsonData["mobile"] = mobile;
    jsonData["referral_code"] = referral_code;
    return jsonData;
  }

}