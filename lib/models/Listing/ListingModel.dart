import 'package:azaFashions/models/Listing/Filters.dart';
import 'package:azaFashions/models/Listing/SortList.dart';

import 'SizeList.dart';

class ListingModel {
  String screen_title;
  List<ModelList> new_model;
  static List<ModelList> finalModel_List;
  List<ModelList> collectionList;
  SortList sortList;
  static List<Filters> filters;
  static String banner="";
  static String description="";
  String url;
  String error;
  String success, page_name;
  String total_records;
   int  attribute_id;
   String currentUrl;
  static bool isFollowing=false;
  List pageLinks;


  ListingModel({this.screen_title, this.new_model, this.sortList});

  ListingModel.withError(String errorMessage) {
    this.error = errorMessage;
  }

  ListingModel.withSuccess(String successMessage) {
    if(successMessage=="No Result Found"){
      finalModel_List= new List<ModelList>();
      new_model= new List<ModelList>();
    }
    success = successMessage;
  }


  ListingModel.fromJson(Map<String, dynamic> json,int pages) {
    print("JSON DATA:$json");
    if(json.containsKey('data') && pages==1 /*&& !json["data"].toString().contains("code")*/){
      print("ENTERED IN LISTING MODEL ${json["data"]["current_url"].toString()}");
      currentUrl=json["data"]["current_url"].toString();
      finalModel_List= new List<ModelList>();
      new_model= new List<ModelList>();

      if( json['data'].toString().contains("banner") && json['data'].toString().contains("description")){
        banner = json['data'].toString().contains("banner")?json['data']['banner']:"";
        description = json['data'].toString().contains("description")?json['data']['description']:"";
        isFollowing = json['data'].toString().contains("following")?json['data']['following']:false;
      }
      else{
        banner="";
        description="";
        isFollowing=false;
      }

      if (json["data"]["list"] != null) {
        total_records = json["data"]["total_records"].toString();
        page_name = json["data"]["page_name"];
        attribute_id = json["data"]["attribute_id"];

        screen_title = json.toString().contains("screen_title")
            ? json["data"]["screen_title"]
            : "";

        json["data"]["list"].forEach((v) {
          new_model.add(new ModelList.fromJson(v));
          finalModel_List.add(new ModelList.fromJson(v));
        });

        filters = List<Filters>();
        print("FILTER JSON:${json["data"]["filters"].toString()} ");
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
      currentUrl=json["data"]["current_url"].toString();
      total_records = json["data"]["total_records"];
      page_name = json["data"]["page_name"];
      attribute_id = json["data"]["attribute_id"];

      sortList = json.toString().contains("sort")
          ? SortList.fromJson(json["data"]["sort"])
          : null;

      pageLinks= new List();
      pageLinks = json['data']['page_links'];
      new_model= new List<ModelList>();
      json["data"]["list"].forEach((v) {
        finalModel_List.add(new ModelList.fromJson(v));
        new_model.add(new ModelList.fromJson(v));
      });
    }

    else{
      total_records = json["total_records"];
      new_model = List<ModelList>();
      finalModel_List = List<ModelList>();

      json['list'].forEach((v){
        new_model.add(ModelList.fromJson(v));
        finalModel_List.add(ModelList.fromJson(v));
      });
      collectionList = List<ModelList>();
      json['list'].forEach((v){
        collectionList.add(ModelList.fromJson(v));
      });

    }
  }

}

class ModelList{
  String name,image,large_image,url,designer_name,mrp,you_pay,discount_percentage,display_mrp,display_you_pay;
  int id,category_id;
  bool wishlist;
  SizeList sizeList;
  bool isSelected;
  String productTag="";
  ModelList({this.sizeList,this.wishlist,this.name, this.image,this.url,this.designer_name,this.id,this.category_id,this.mrp,this.you_pay,this.display_mrp,this.display_you_pay,this.discount_percentage,this.isSelected,this.productTag,this.large_image});

  factory ModelList.fromJson(Map<String, dynamic> json) {

    return ModelList(
        sizeList:SizeList.fromJson(json["sizes"]),
        name: json["name"],
        image: json["image"],
        large_image:json["large_image"],
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








