

class SocialLoginModel{
  String email,token,name;
  String type,social_id;
  String error="";




  SocialLoginModel({
    this.email, this.token,
    this.name,
    this.type, this.social_id,
  });

  SocialLoginModel.withError(String errorMessage) {
    error = errorMessage;
  }
  
Map<String,dynamic> toJson(){
  Map<String,dynamic>  jsonData= new Map<String,dynamic>();

        jsonData["email"]=email;
        jsonData["token"]=token;
        jsonData["name"]=name;
        jsonData["type"]=type;
        jsonData["social_id"]=social_id;
    return jsonData;

}

factory SocialLoginModel.fromJson(Map<String,dynamic> json,String social_auth_token,String type,String userId){
    return SocialLoginModel(email:json["email"], token:social_auth_token, name:json["name"], type:type, social_id:userId);


}

}