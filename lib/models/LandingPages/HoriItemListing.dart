
class HoriItemListing{
  String layoutName,title;
  List<HoriList> horiList;

  HoriItemListing(this.layoutName,this.horiList);

  HoriItemListing.fromJson(Map<String,dynamic> json) {
    if (json != null) {
      horiList = new List<HoriList>();
      layoutName= json["layout"];
      title=json["title"];
      json["list"] .forEach((v) {
        horiList.add(new HoriList.fromJson(v));
      });
    }
  }

}


class HoriList{
  String name,image,url,designer_name,mrp,you_pay,discount_percentage,url_tag,display_mrp,display_you_pay;
  int id,category_id;
  bool wishlist;


  HoriList({this.wishlist,this.name, this.image,this.url,this.designer_name,this.url_tag,this.id,this.category_id,this.mrp,this.you_pay,this.display_you_pay,this.display_mrp,this.discount_percentage});

  factory HoriList.fromJson(Map<String, dynamic> json) {
    return HoriList(
        name: json["name"],
        image: json["image"],
        url: json["url"],
        designer_name: json["designer_name"],
        id: json["id"],
        category_id: json["category_id"],
        mrp: json["mrp"].toString(),
        you_pay: json["you_pay"].toString(),
        discount_percentage: json["discount_percentage"].toString(),
        display_mrp: json["display_mrp"].toString(),
        display_you_pay: json["display_you_pay"].toString(),
        wishlist: json.toString().contains("in_wishlist")? json["in_wishlist"]:false
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