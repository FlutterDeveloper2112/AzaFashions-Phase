
import 'dart:convert';

class Registration{
  String name,email,password,dob,mobile,referrer;
  int gender;
  String firstname,lastname;
  int customer_id;

  Registration(
      {
        this.name,
        this.email,this.mobile,
        this.password,this.dob,
        this.gender, this.referrer,
      });



  Map<String,dynamic> toJson(){
    Map<String,dynamic>  jsonData= new Map<String,dynamic>();
    jsonData["email"]=email;
    jsonData["name"]=name;
    jsonData["password"]=base64.encode(utf8.encode(password));
    jsonData["dob"]=dob;
    jsonData["mobile"]=mobile;
    jsonData["referrer"]=referrer;
    jsonData["gender"]=gender;

    return jsonData;

  }

  Registration.fromJson(Map<String, dynamic> json) {
    customer_id = json['customer_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    //dob = json['dob'];
    //gender = json['gender'];
    mobile = json['mobile'];
    referrer = json['referral_code'];
  }
}