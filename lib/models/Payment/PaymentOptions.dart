
class PaymentOptions {
  List<PaymentModel> payment_model;
  String error,success;


  PaymentOptions.withError(String errorMessage) {
    error = errorMessage;
  }
  PaymentOptions.withSuccess(String successMessage) {
    success = successMessage;
  }


  PaymentOptions.fromJson(Map<String, dynamic> json) {
    if (json["data"]["list"] != null) {

      payment_model = new List<PaymentModel> ();
      json["data"]["list"] .forEach((v) {
        payment_model.add(new PaymentModel.fromJson(v));
      });
    }

  }
}



class PaymentModel{
  String title,icon,mode,flow,url,gateway,callback_url;


  PaymentModel({this.title,this.icon,this.mode,this.flow,this.url,this.callback_url,this.gateway});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
     title: json["title"],
     icon:json["icon"],
     mode:json["mode"],
     flow:json["flow"],
     url:json["url"],
     callback_url:json["callback_url"],
     gateway: json["gateway"]

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








