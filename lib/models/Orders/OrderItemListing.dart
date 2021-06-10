import 'package:azaFashions/models/Orders/ItemListing.dart';

class OrderItemList {
  List<OrderDetailList> order_detailsList;

  String error,success;

  OrderItemList({this.order_detailsList});

  OrderItemList.withError(String errorMessage) {
    error = errorMessage;
  }
  OrderItemList.withSuccess(String successMessage) {
    success = successMessage;
  }


  OrderItemList.fromJson(Map<String,dynamic> json) {
    if (json["data"] != null) {
      order_detailsList= new List<OrderDetailList>();
      order_detailsList.add(new OrderDetailList.fromJson(json["data"]));
    }
  }


}

