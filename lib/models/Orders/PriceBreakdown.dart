
class PriceBreakdown {
  List<Price> price;

  PriceBreakdown(this.price);

  PriceBreakdown.fromJson(dynamic json) {
    print("SHOPPING CART PRICE BREAKDOWN: ${json.toString()}");
    if (json != null) {
      price = new List<Price>();
      json .forEach((v) {
        price.add(new Price.fromJson(v));
      });
    }
  }
}



class Price{
  String name,type,amount;
  static String  redeemWallet="",redeemLoyalty="",redeemCredit="";
  static String  redeemWalletAmt="",redeemLoyaltyAmt="",redeemCreditAmt="";


  Price({this.name, this.type, this.amount});

  factory Price.fromJson(dynamic json) {
    redeemWallet= json["name"].toString().contains("Wallet Redeemed")?"REDEEM FROM WALLET":"";
    redeemLoyalty= json["name"].toString().contains("Loyalty Redeemed")?"REDEEM FROM LOYALTY":"";
    redeemCredit= json["name"].toString().contains("Credit Redeemed")?"REDEEM FROM CREDIT":"";
    redeemWalletAmt= json["name"].toString().contains("Wallet Redeemed")?"REDEEM FROM WALLET":"";
    redeemLoyaltyAmt= json["name"].toString().contains("Loyalty Redeemed")?"REDEEM FROM LOYALTY":"";
    redeemCreditAmt= json["name"].toString().contains("Credit Redeemed")?"REDEEM FROM CREDIT":"";


    return Price(
        name : json["name"],
        type : json["type"].toString(),
        amount : json["amount"].toString()
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




class PaymentDetails{

  String mode;

  PaymentDetails({this.mode});

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
        mode : json["mode"],
    );
  }
}