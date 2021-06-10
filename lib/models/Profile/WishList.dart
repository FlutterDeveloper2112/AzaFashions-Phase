import 'dart:core';

import 'package:azaFashions/models/Listing/SizeList.dart';

class WishListArray {
  List<WishList> list;
  String error="",success="";

  WishListArray({this.list});
  WishListArray.withError(String errorMessage) {
    error = errorMessage;
  }
  WishListArray.withSuccess(String successMessage) {
    success = successMessage;
  }
  WishListArray.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<WishList>();
      json["list"].forEach((v) {
        list.add(new WishList.fromJson(v));
      });
    }
  }
}

class WishList {
  String page_name;
  int attribute_id;
  int id;
  String name;
  String url;
  String designerName;
  int categoryId;
  String mrp,display_mrp;
  String discount;
  String you_pay,display_you_pay;
  SizeList sizeList;


  WishList(this.sizeList,{this.id, this.name, this.url, this.designerName, this.categoryId, this.mrp, this.discount, this.you_pay,this.display_you_pay,this.display_mrp,});

  factory WishList.fromJson(Map<String, dynamic> json) {
    return WishList(
      SizeList.fromJson(json["sizes"]),
        id : json['id'],
        name : json['name'],
        url : json['image'],
        designerName : json['designer_name'],
        categoryId : json['category_id'],
        mrp : json['mrp'].toString(),
        discount : json['discount_percentage'].toString(),
       you_pay : json['you_pay'].toString(),
      display_you_pay: json["display_you_pay"].toString(),
      display_mrp: json["display_mrp"].toString(),

    );
  }


  WishList.toJson() {
    Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['id'] = id;
    jsonData['name'] = name;
    jsonData['image'] = url;
    // jsonData['sizes'] = size;
    jsonData['designer_name'] = designerName;
    jsonData['category_id'] = categoryId;
    jsonData['mrp'] = mrp;
    jsonData['discount_percentage'] = discount;
    jsonData['you_pay'] = you_pay;
  }
}

