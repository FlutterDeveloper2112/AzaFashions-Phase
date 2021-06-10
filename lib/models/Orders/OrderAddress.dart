class OrderAddress{

  String type;
  int isDefault;
  String name;
  String mobileNo;
  String addressOne;
  String addressTwo;
  String cityName;
  String stateName;
  String countryName;
  String postalCode;
  int addressId;

  OrderAddress({this.addressId,this.type,this.isDefault,this.name,this.mobileNo,this.addressOne,this.cityName,this.stateName,this.countryName,this.postalCode});



  factory OrderAddress.fromJson(Map<String, dynamic> json) {
    print("JSON DATA : ${json["firstname"]} ${json["lastname"]}");
    return OrderAddress(
      addressId: json["id"],
      type: json["type"],
      isDefault: json["is_default"],
      name: json["name"],
      mobileNo: json["mobile"].toString(),
      addressOne: json["address_one"],
      cityName: json["city_name"],
      stateName: json["state_name"],
      countryName: json["country_name"],
      postalCode: json["postal_code"],
    );
  }




  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["type"] = type;
    jsonData["is_default"] = isDefault;
    jsonData["name"] = name;
    jsonData["mobile"] = mobileNo;
    jsonData["address_one"] = addressOne;
    jsonData["postal_code"] = postalCode;
    jsonData["city_name"] = cityName;
    jsonData["state_name"] = stateName;
    jsonData["country_name"] = countryName;

    return jsonData;
  }

/* Map<dynamic,String> toJson(){
    Map<String,String> jsonData=  new Map<String,dynamic>();
    jsonData['imageAsset']=imageAsset;
    jsonData['title']=title;
    jsonData['description']=description;
    return jsonData;

  }*/

}