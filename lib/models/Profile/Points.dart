

class PointsList {
  List<Points> point_model;
  String error,success;
  String bannerImage;

  PointsList({this.point_model});

  PointsList.withError(String errorMessage) {
    error = errorMessage;
  }
  PointsList.withSuccess(String successMessage) {
    success = successMessage;
  }


  PointsList.fromJson(Map<String, dynamic> json) {

    bannerImage= json["data"]["banner_image"];
    if (json["data"]["buckets"] != null) {
      point_model = new List<Points>();
      json["data"]["buckets"] .forEach((v) {
        point_model.add(new Points.fromJson(v));

      });
    }
  }

/*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.countries != null) {
      data['Countries'] = this.countries.map((v) => v.toJson()).toList();
    }

    return data;
  }*/
}

class Points{

  String name;
  String info;
  String wallet,credit,loyalty;


  Points({this.name, this.info,this.wallet,this.credit,this.loyalty});


  factory Points.fromJson(Map<String, dynamic> json) {
    print("JSON DATA : ${json.toString().contains("wallet")}");
    Points points ;
    if(json.toString().contains("wallet")){
      points =Points(
        name: json["name"],
        info: json["info"],
        wallet: json["wallet"].toString(),
        credit: "",
        loyalty: ""
      );
    }
    else if(json.toString().contains("credit")){
      points= Points(
          name: json["name"],
          info: json["info"],
          wallet:"",
          loyalty: "",
          credit:  json["credit"].toString()
      );
    }
    else if(json.toString().contains("loyalty_points")){
      points= Points(
          name: json["name"],
          info: json["info"],
          wallet:"",
          loyalty:  json["loyalty_points"].toString(),
          credit: ""
      );
    }

    return points;

  }

/* Map<dynamic,String> toJson(){
    Map<String,String> jsonData=  new Map<String,dynamic>();
    jsonData['imageAsset']=imageAsset;
    jsonData['title']=title;
    jsonData['description']=description;
    return jsonData;

  }*/

}








