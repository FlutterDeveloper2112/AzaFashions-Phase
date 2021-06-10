import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/models/Orders/PriceBreakdown.dart';
import 'package:azaFashions/models/Profile/ProfileAddressList.dart';

class PaymentStatus {
  List<CartModelList> new_model;
  List<ModelList> completeTheLook;
  String error,success,total_amount_payable,total_discount,custom_order_id;
  PriceBreakdown priceBreakdown;
  int order_id,total_items,code=0;
   String bannerImage,heading,sub_heading,customer_name,customer_email;
   AddressModel shippingAddress,billingAddress;




  PaymentStatus.withError(String errorMessage) {
    error = errorMessage;
  }
  PaymentStatus.withSuccess(String successMessage) {
    success = successMessage;
  }

  PaymentStatus.fromJson(Map<String, dynamic> json) {
    if (json["data"]["items"] != null) {
      customer_name=json["data"]["customer_name"].toString();
      customer_email=json["data"]["customer_email"].toString();
      bannerImage = json["data"]["banner_image"].toString();
      heading = json["data"]["heading"].toString();
      sub_heading = json["data"]["sub_heading"].toString();
      order_id = json["data"]["order_id"];
      custom_order_id = json["data"]["custom_order_id"].toString();
      total_items = json["data"]["total_items"];
      total_discount = json["data"]["total_discount"].toString();
      total_amount_payable = json["data"]["total_amount_payable"].toString();
      shippingAddress=AddressModel.fromJson(json["data"]["shipping_address"]);
      billingAddress=AddressModel.fromJson(json["data"]["billing_address"]);
      priceBreakdown = PriceBreakdown.fromJson(json["data"]["price_breakdown"]);

      new_model = new List<CartModelList> ();
      json["data"]["items"].forEach((v) {
        new_model.add(new CartModelList.fromJson(v));
      });

      completeTheLook = new List<ModelList> ();
      json["data"]["complementary_products"]!=null?json["data"]["complementary_products"].forEach((v) {
        completeTheLook.add(new ModelList.fromJson(v));
      }):null;



    }

  }
  PaymentStatus.fromBlockerJson(Map<String, dynamic> json) {
    if (json["data"]["message"]!= null) {
      code=json["data"]["code"];
      bannerImage = json["data"]["banner_image"].toString();
      heading = json["data"]["heading"].toString();
      sub_heading = json["data"]["sub_heading"].toString();

    }


  }

}

