import 'package:azaFashions/models/Listing/Filters.dart';
import 'package:azaFashions/models/Listing/SortList.dart';

import 'SizeList.dart';

class ChildListingModel {
  String screen_title;
  List<ChildModelList> new_model;
  static List<ChildModelList> finalModel_List;
  List<ChildModelList> collectionList;
  SortList sortList;
  static List<Filters> filters;
  static String banner="";
  static String description="";
  String url;
  String error;
  String success, page_name;
  String total_records;
  int  attribute_id;
  bool isFollowing;
  List pageLinks;
  String currentUrl;


  ChildListingModel({this.screen_title, this.new_model, this.sortList});

  ChildListingModel.withError(String errorMessage) {
    this.error = errorMessage;
  }

  ChildListingModel.withSuccess(String successMessage) {
    if(successMessage=="No Result Found"){
      finalModel_List= new List<ChildModelList>();
      new_model= new List<ChildModelList>();
    }
  }


  ChildListingModel.fromJson(Map<String, dynamic> json,int pages) {
    print("JSON DATA:$json");
    if(json.containsKey('data') && pages==1 /*&& !json["data"].toString().contains("code")*/){
      print("ENTERED IN LISTING MODEL");
      finalModel_List= new List<ChildModelList>();
      new_model= new List<ChildModelList>();

      banner = json['data'].toString().contains("banner")?json['data']['banner']:"";
      description = json['data'].toString().contains("description")?json['data']['description']:"";
      isFollowing = json['data'].toString().contains("following")?json['data']['following']:false;
      if (json["data"]["list"] != null) {

        currentUrl=json["data"]["current_url"].toString();
        print("CUrrent URL :$currentUrl");
        total_records = json["data"]["total_records"].toString();
        page_name = json["data"]["page_name"];
        attribute_id = json["data"]["attribute_id"];

        screen_title = json.toString().contains("screen_title")
            ? json["data"]["screen_title"]
            : "";

        json["data"]["list"].forEach((v) {
          new_model.add(new ChildModelList.fromJson(v));
          finalModel_List.add(new ChildModelList.fromJson(v));
        });

        filters = List<Filters>();
        json['data'].toString().contains("filters")? json["data"]["filters"].forEach((v){
          filters.add(Filters.fromJson(v));
        }):null;

        sortList = json.toString().contains("sort")
            ? SortList.fromJson(json["data"]["sort"])
            : null;

        pageLinks= new List();
        pageLinks = json['data']['page_links'];
      }
    }
    else if(json.containsKey('data') && pages>1){
      print("CUrrent URL :$currentUrl");
      currentUrl=json["data"]["current_url"].toString();
      total_records = json["data"]["total_records"];
      page_name = json["data"]["page_name"];
      attribute_id = json["data"]["attribute_id"];

      sortList = json.toString().contains("sort")
          ? SortList.fromJson(json["data"]["sort"])
          : null;

      pageLinks= new List();
      pageLinks = json['data']['page_links'];
      new_model= new List<ChildModelList>();
      json["data"]["list"].forEach((v) {
        finalModel_List.add(new ChildModelList.fromJson(v));
        new_model.add(new ChildModelList.fromJson(v));
      });
    }

    else{
      total_records = json["total_records"];
      new_model = List<ChildModelList>();
      finalModel_List = List<ChildModelList>();

      json['list'].forEach((v){
        new_model.add(ChildModelList.fromJson(v));
        finalModel_List.add(ChildModelList.fromJson(v));
      });
      collectionList = List<ChildModelList>();
      json['list'].forEach((v){
        collectionList.add(ChildModelList.fromJson(v));
      });

    }
  }

}

class ChildModelList{
  String name,image,large_image,url,designer_name,mrp,you_pay,discount_percentage,display_mrp,display_you_pay;
  int id,category_id;
  bool wishlist;
  SizeList sizeList;
  bool isSelected;
  String productTag="";
  ChildModelList({this.sizeList,this.wishlist,this.name, this.image,this.url,this.designer_name,this.id,this.category_id,this.mrp,this.you_pay,this.display_mrp,this.display_you_pay,this.discount_percentage,this.isSelected,this.productTag,this.large_image});

  factory ChildModelList.fromJson(Map<String, dynamic> json) {
    return ChildModelList(
        sizeList:SizeList.fromJson(json["sizes"]),
        name: json["name"],
        image: json["image"],
        large_image: json["large_image"],
        url: json["url"],
        designer_name: json["designer_name"],
        id: json["id"],
        category_id: json["category_id"],
        mrp: json["mrp"].toString(),
        you_pay: json["you_pay"].toString(),
        display_mrp: json["display_mrp"].toString(),
        display_you_pay: json["display_you_pay"].toString(),
        discount_percentage: json["discount_percentage"].toString(),
        wishlist: json["in_wishlist"],
        isSelected : false,
        productTag: json["tag"]
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








