import 'package:azaFashions/models/Orders/ItemListing.dart';

class OrderListing {
  List<ItemListing> order_modellist;

  String error,success;

  OrderListing({this.order_modellist});

  OrderListing.withError(String errorMessage) {
    error = errorMessage;
  }
  OrderListing.withSuccess(String successMessage) {
    success = successMessage;
  }


  OrderListing.fromJson(Map<String,dynamic> json) {
    if (json["data"] != null) {
      order_modellist = new List<ItemListing>();
      json["data"]["list"] .forEach((v) {
        order_modellist.add(new ItemListing.fromJson(v));
      });
    }
  }


}




