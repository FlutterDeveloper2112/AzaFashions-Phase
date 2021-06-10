

import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Orders/PriceBreakdown.dart';
import 'package:azaFashions/models/Profile/ProfileAddressList.dart';

class CheckoutListing {
   List<CartModelList> new_model;
  String error,success,total_amount_payable,total_discount;
  PriceBreakdown priceBreakdown;
  int total_items;
  AddressModel shippingAddresss, billingAddress;


  CheckoutListing.withError(String errorMessage) {
    error = errorMessage;
  }
  CheckoutListing.withSuccess(String successMessage) {
    success = successMessage;
  }


  CheckoutListing.fromJson(Map<String, dynamic> json) {
    if (json["data"]["list"] != null) {
      total_items= json["data"]["total_items"];
      total_amount_payable= json["data"]["total_amount_payable"].toString();
      total_discount= json["data"]["total_discount"].toString();
      priceBreakdown=PriceBreakdown.fromJson(json["data"]["price_breakdown"]);

      new_model = new List<CartModelList> ();
      json["data"]["list"] .forEach((v) {
        new_model.add(new CartModelList.fromJson(v));
      });
     shippingAddresss=json["data"].toString().contains("shipping_address")? new AddressModel.fromJson(json["data"]["shipping_address"]):null;
     billingAddress= json["data"].toString().contains("billing_address")? new AddressModel.fromJson(json["data"]["billing_address"]):null;

    }

  }
}



class CheckoutModelList{
  String name,image,url,designer_name,mrp,you_pay,discount_percentage,size_name,colour_name,display_mrp,display_you_pay;
  int id,size_id, quantity;


  CheckoutModelList({this.name, this.image, this.url, this.designer_name, this.mrp,
    this.you_pay, this.discount_percentage, this.size_id, this.size_name,
    this.colour_name, this.id,this.quantity,this.display_mrp,this.display_you_pay});

  factory CheckoutModelList.fromJson(Map<String, dynamic> json) {
    return CheckoutModelList(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      url: json["url"],
      colour_name: json["colour_name"],
      size_name: json["size_name"],
      size_id: json["size_id"],
      designer_name: json["designer_name"],
      mrp: json["mrp"].toString(),
      you_pay: json["you_pay"].toString(),
      discount_percentage: json["discount_percentage"].toString(),
      display_mrp: json["display_mrp"].toString(),
      display_you_pay: json["display_you_pay"].toString(),

    );
  }

/* Map<dynamic,String> toJson(){
    Map<String,String> jsonData=  new Map<String,dynamic>();
    jsonData['imageAsset']=imageAsset;
    jsonData['title']=title;
    jsonData['description']=description;
    return jsonData;

  }*/

}








