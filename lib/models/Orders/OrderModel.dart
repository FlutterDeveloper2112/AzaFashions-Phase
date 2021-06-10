
import 'package:azaFashions/models/ProductDetail/CustomizationModel.dart';

class OrderModel {
  List<Model> model;

  OrderModel(this.model);

  OrderModel.fromJson(dynamic json) {
    print("JSON ${json.runtimeType}");
    if (json != null) {
      model = <Model>[];
      json.forEach((v) {
        model.add(new Model.fromJson(v));
      });
    }
  }
}

class Model {
  String item_status,
      item_status_date,
      product_name,
      product_image,
      display_mrp,
      display_you_pay,
      product_url,
      tracking_url,
      cancel_url,
      designer_name,
      size_name,
      colour_name,
      discount_percentage,
      you_paid,
      mrp;
  int item_id, product_id, customer_rating, qty, root_category_id;
  bool customer_rated, can_cancel, can_track;
  bool isExpanded;

  CustomizationModelWomen customizationModelWomen;
  CustomizationModelMen customizationModelMen;

  Model(
      {this.item_status,
        this.item_status_date,
        this.customer_rated,
        this.can_cancel,
        this.can_track,
        this.customer_rating,
        this.product_name,
        this.product_image,
        this.product_url,
        this.tracking_url,
        this.cancel_url,
        this.designer_name,
        this.size_name,
        this.colour_name,
        this.discount_percentage,
        this.you_paid,
        this.item_id,
        this.product_id,
        this.root_category_id,
        this.mrp,
        this.isExpanded,
        this.display_mrp,
        this.display_you_pay,
        this.qty,
        this.customizationModelWomen,
        this.customizationModelMen});

  factory Model.fromJson(dynamic json) {
    print("ORDER JSON: ${json.toString()}");
    print("CUSTOMER RATED: ${json["item_status"]}");
    print("Size Name ${json["size_customization"]}");
    return Model(
        item_id: json["item_id"],
        item_status: json["item_status"],
        item_status_date: json["item_status_date"],
        customer_rated: json["customer_rated"],
        can_cancel: json["can_cancel"],
        can_track: json["can_track"],
        customer_rating: json["customer_rating"],
        product_name: json["product_name"],
        product_image: json["product_image"],
        product_url: json["product_url"],
        tracking_url: json.toString().contains("tracking_url")
            ? json["tracking_url"]
            : "",
        cancel_url:
        json.toString().contains("cancel_url") ? json["cancel_url"] : "",
        designer_name: json["designer_name"],
        size_name: json["size_name"],
        root_category_id: json['root_category_id'],
        customizationModelWomen: json.containsKey('size_customization')?json['root_category_id'] == 3
            ? CustomizationModelWomen.fromJson(json["size_customization"])
            : null:null,
        customizationModelMen: json.containsKey('size_customization')?json['root_category_id'] == 2
            ? CustomizationModelMen.fromJson(json["size_customization"])
            : null:null,
        colour_name: json["colour_name"],
        discount_percentage: json["discount_percentage"].toString(),
        you_paid: json["you_paid"].toString(),
        product_id: json["product_id"],
        mrp: json["mrp"].toString(),
        display_mrp: json["display_mrp"].toString(),
        display_you_pay: json["display_you_paid"].toString(),
        isExpanded: false,
        qty: json.toString().contains("quantity") ? json["quantity"] : "");
  }

/* Map<dynamic,String> toJson(){
    Map<String,String> jsonData=  new Map<String,dynamic>();
    jsonData['imageAsset']=imageAsset;
    jsonData['title']=title;
    jsonData['description']=description;
    return jsonData;

  }*/

}
