import 'package:azaFashions/models/Orders/OrderModel.dart';
import 'Coupon.dart';
import 'OrderAddress.dart';
import 'PriceBreakdown.dart';

class ItemListing{
  int order_id;
  String custom_order_id,order_status,order_date,order_amount;
  OrderModel order_model;



  ItemListing( this.order_model,{this.order_id, this.order_status, this.order_date, this.order_amount,this.custom_order_id});

  factory ItemListing.fromJson(Map<String,dynamic> json) {
    print("MAIN ORDER LIST: ${json.toString()}");
    return ItemListing(
      OrderModel.fromJson(json["items"]),
      order_id : json["order_id"],
      order_status : json["order_status"],
      order_date : json["order_date"].toString(),
      order_amount : json["order_amount"].toString(),
      custom_order_id : json.toString().contains("custom_order_id")?json["custom_order_id"]:null,

    );
  }
}



class OrderDetailList{
  int order_id;
  String order_status,order_date,order_amount;
  OrderModel order_model;
  PriceBreakdown priceBreakdown;
  OrderAddress shippingAddress;
  OrderAddress billingAddress;
  Coupon coupon;
  String payment_mode;


  OrderDetailList( this.order_model,this.priceBreakdown,{this.payment_mode,this.coupon,this.shippingAddress,this.billingAddress,this.order_id, this.order_status, this.order_date, this.order_amount});

  factory OrderDetailList.fromJson(dynamic json) {
    print("Detail STATUS: ${json.toString()}");
    return OrderDetailList(
      OrderModel.fromJson(json["items"]),
      PriceBreakdown.fromJson(json["price_breakdown"]),
      order_id : json.toString().contains("order_id")?json["order_id"]:null,
      order_status : json.toString().contains("order_status")?json["order_status"]:"",
      order_date : json.toString().contains("order_date")?json["order_date"].toString():"",
      order_amount : json.toString().contains("order_amount")?json["order_amount"].toString():"",
      shippingAddress: json.toString().contains("shipping_address")? OrderAddress.fromJson(json["shipping_address"]):null,
      billingAddress:  json.toString().contains("billing_address")? OrderAddress.fromJson(json["billing_address"]):null,
      coupon: json.toString().contains("coupon_details")? Coupon.fromJson(json["coupon_details"]):null,
      payment_mode: json.toString().contains("payment_details")?json["payment_details"]["mode"]:"",

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
