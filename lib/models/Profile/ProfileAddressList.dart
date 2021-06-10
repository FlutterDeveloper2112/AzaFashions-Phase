
class ProfileAddressList {
  List<AddressModel> addressModel;
  String error, success;

  ProfileAddressList({this.addressModel});

  ProfileAddressList.withError(String errorMessage) {
    error = errorMessage;
  }

  ProfileAddressList.withSuccess(String successMessage) {
    success = successMessage;
  }

  ProfileAddressList.fromJson(Map<String, dynamic> json) {
    if (json["data"]["list"] != null) {
      addressModel = new List<AddressModel>();
      json["data"]["list"].forEach((v) {
        addressModel.add(new AddressModel.fromJson(v));
      });
    }
  }
}

class AddressModel {
  String type;
  int isDefault;
  String firstName;
  String lastName;
  String email;
  String mobileNo;
  String addressOne;
  String addressTwo;
  String cityName;
  String stateName;
  int countryID;
  String countryName;
  String postalCode;
  String selection_type;
  int addressId;
  bool selected;
  String addressType;

  AddressModel(
      {this.addressType,
        this.addressId,
        this.type,
        this.isDefault,
        this.firstName,
        this.lastName,
        this.email,
        this.mobileNo,
        this.addressOne,
        this.cityName,
        this.stateName,
        this.countryName,
        this.postalCode,
        this.selection_type,
        this.selected,
        this.countryID});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    print("JSON DATA : ${json["firstname"]} ${json["lastname"]}");
    return AddressModel(
      addressId: json["id"],
      type: json["type"],
      isDefault: json["is_default"],
      firstName: json["firstname"],
      lastName: json["lastname"],
      mobileNo: json["mobile"].toString(),
      addressOne: json["address_one"],
      cityName: json["city_name"],
      stateName: json["state_name"],
      countryID: json['country_id'],
      countryName: json["country_name"],
      postalCode: json["postal_code"],
      email: json.toString().contains("email") ? json["email"] : "",
      selection_type: json.toString().contains("selection_type")
          ? json["selection_type"]
          : "",
      selected: json.toString().contains("selected") ? json["selected"] : false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData["type"] = type;
    jsonData["is_default"] = isDefault;
    jsonData["firstname"] = firstName;
    jsonData["lastname"] = lastName;
    jsonData["email"] = email;
    jsonData["mobile"] = mobileNo;
    jsonData["address_one"] = addressOne;
    jsonData["postal_code"] = postalCode;
    jsonData["city_name"] = cityName;
    jsonData["state_name"] = stateName;
    jsonData["country_name"] = countryName;
    selection_type != ""
        ? jsonData["selection_type"] =
        selection_type.split(" ")[0].toLowerCase()
        : null;
    return jsonData;
  }
}
