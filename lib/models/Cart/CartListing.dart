

import 'package:azaFashions/models/Orders/Coupon.dart';
import 'package:azaFashions/models/Orders/PriceBreakdown.dart';


class CartListing {
  static List<CartModelList> new_model;
  String error,success,total_amount_payable,total_discount;
  PriceBreakdown priceBreakdown;
  List<Coupon> coupon;
  static PromoList promoPrompt;
  int total_items;
  static List<RedeemItems> redeemItems;
  static String data_error;
  static String promo_banner="";
  static String couponCode ="";


  CartListing.withError(String errorMessage) {
    error = errorMessage;
  }
  CartListing.withSuccess(String successMessage) {
    success = successMessage;
  }

  CartListing.fromJson(Map<String, dynamic> json) {
      if (json["data"]["list"] != null) {
        data_error="";
        total_items = json["data"]["total_items"];
        total_amount_payable = json["data"]["total_amount_payable"].toString();
        total_discount = json["data"]["total_discount"].toString();
        promo_banner = json["data"]["promo_banner"].toString();

        priceBreakdown = PriceBreakdown.fromJson(json["data"]["price_breakdown"]);


        print(json['data']['promo_prompt']);
        promoPrompt =json.toString().contains("promo_prompt")?PromoList.fromJson(json['data']['promo_prompt']):null;

        new_model = new List<CartModelList> ();
        json["data"]["list"].forEach((v) {
          new_model.add(new CartModelList.fromJson(v));
        });
        redeemItems = new List<RedeemItems>();
        print("REDEEM POINTS: ${ json["data"]["redeemable_items"].toString()}");
        json["data"]["redeemable_items"].forEach((v) {
          redeemItems.add(new RedeemItems.fromJson(v));
        });
      }
      else {
        data_error="";
        total_amount_payable = json["data"]["total_amount_payable"].toString();
        total_discount = json["data"]["total_discount"].toString();
        priceBreakdown = PriceBreakdown.fromJson(json["data"]["price_breakdown"]);

      }

  }
}

class RedeemItems {
  String title;
  String subTitle;
  int balance;
  int redeemed;
  String note;
  bool isSelected;
  bool value;

  int remainingBalance;

  RedeemItems({this.title, this.subTitle, this.balance, this.note,this.isSelected,this.value});

  RedeemItems.fromJson(Map<String,dynamic> json){

    title = json['title'];
    subTitle = json['sub_title'];
    balance = json['balance'];
    note = json['note'];
    isSelected = false;
    value = false;
    remainingBalance= balance;
  }
}



class PromoList{

  List<PromoPrompt> promo;

  PromoList(this.promo);

  PromoList.fromJson(dynamic json){
    print(json);
    promo = List<PromoPrompt>();

    json['list'].forEach((v){
      promo.add(PromoPrompt.fromJson(v));
    });
  }
}
class PromoPrompt{
  String text;
  String info;

  PromoPrompt(this.text, this.info);

  PromoPrompt.fromJson(Map<String,dynamic> json){
    text= json['text'];
    info = json.toString().contains("info")?json['info']:"";
  }
}

class CartModelList{
  String name,image,url,designer_name,mrp,you_pay,discount_percentage,display_mrp,display_you_pay,size_name,colour_name,estimated_delivery;
  int id,size_id, quantity,category_id,parent_id,designer_id;


  CartModelList({this.name, this.image, this.url, this.designer_name, this.mrp,
    this.you_pay, this.discount_percentage, this.size_id, this.size_name,
    this.colour_name, this.id,this.quantity,this.category_id,this.parent_id,this.designer_id,this.estimated_delivery,this.display_you_pay,this.display_mrp});

  factory CartModelList.fromJson(Map<String, dynamic> json) {
    return CartModelList(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      url: json["url"],
      colour_name: json["colour_name"],
      size_name: json["size_name"],
      size_id: json["size_id"],
      quantity: json["quantity"],
      category_id:json["category_id"],
      parent_id:json["parent_id"],
      designer_id:json["designer_id"],
      designer_name: json["designer_name"],
      mrp: json["mrp"].toString(),
      you_pay: json["you_pay"].toString(),
      display_mrp: json["display_mrp"].toString(),
      display_you_pay: json["display_you_pay"].toString(),
      discount_percentage: json["discount_percentage"].toString(),
      estimated_delivery: json.toString().contains("estimated_delivery")?json["estimated_delivery"].toString():""

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








