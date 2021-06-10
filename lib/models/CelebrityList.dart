import 'package:azaFashions/models/Listing/Filters.dart';
import 'package:azaFashions/models/Listing/SortList.dart';

class CelebrityList {
  String layoutName;
  String title;
  List<CelebrityData> celebData;
  static List<CelebrityData> celebrityData;
  String view_all_title, view_all_url, view_all_urltag;
  SortList sortList;
  static List<Filters> filters;
  String total_records;
  int  attribute_id;
  List pageLinks;
  String error;
  int sliderCount;
  CelebrityList(this.layoutName, this.celebData);


  CelebrityList.withError(String error){
    this.error = error;
  }
  CelebrityList.fromJson(Map<String, dynamic> json, int pages) {

    if (json != null && pages == 1) {
      celebData = new List<CelebrityData>();
      celebrityData = new List<CelebrityData>();
      layoutName = json["layout"];
      title = json["title"];
      sliderCount = json['slider_item_count'];
      json["list"].forEach((v) {
        print("FOR EACH $v");
        celebData.add(new CelebrityData.fromJson(v));
        celebrityData.add(new CelebrityData.fromJson(v));
      });
      total_records = json["total_records"].toString();
      attribute_id = json["attribute_id"];

      filters = List<Filters>();
      json.toString().contains("filters")? json["filters"].forEach((v){
        filters.add(Filters.fromJson(v));
      }):null;

      sortList = json.toString().contains("sort")
          ? SortList.fromJson(json["sort"])
          : null;

      pageLinks= new List();
      pageLinks = json['page_links'];

      view_all_title = json["view_all"] != "" && json["view_all"] != null ? json["view_all"]["title"] : "";
      view_all_url = json["view_all"] != "" && json["view_all"] != null ? json["view_all"]["url"] : "";
      view_all_urltag = json["view_all"] != "" && json["view_all"] != null ? json["view_all"]["url_tag"] : "";
    }
    else if (json != null && pages > 1) {

      celebData = new List<CelebrityData>();
      layoutName = json["layout"];
      title = json["title"];
      sliderCount = json['slider_item_count'];
      json["list"].forEach((v) {
        celebrityData.add(new CelebrityData.fromJson(v));
        celebData.add(new CelebrityData.fromJson(v));
      });
      total_records = json["total_records"].toString();
      attribute_id = json["attribute_id"];



      sortList = json.toString().contains("sort")
          ? SortList.fromJson(json["sort"])
          : null;

      pageLinks= new List();
      pageLinks = json['page_links'];
      view_all_title = json["view_all"] != "" && json["view_all"] != null
          ? json["view_all"]["title"]
          : "";
      view_all_url = json["view_all"] != "" && json["view_all"] != null
          ? json["view_all"]["url"]
          : "";
      view_all_urltag = json["view_all"] != "" && json["view_all"] != null
          ? json["view_all"]["url_tag"]
          : "";
    }

    else {
      total_records = json["total_records"].toString();
      celebData = new List<CelebrityData>();
      layoutName = json["layout"];
      sliderCount = json['slider_item_count'];
      title = json["title"];
      json["list"].forEach((v) {
        print("FOR EACH $v");
        celebData.add(new CelebrityData.fromJson(v));
      });
      view_all_title = json["view_all"] != "" && json["view_all"] != null
          ? json["view_all"]["title"]
          : "";
      view_all_url = json["view_all"] != "" && json["view_all"] != null
          ? json["view_all"]["url"]
          : "";
      view_all_urltag = json["view_all"] != "" && json["view_all"] != null
          ? json["view_all"]["url_tag"]
          : "";
    }
  }
}

class CelebrityData {
  String celebrity_name, designer_name, product_url, banner_image, url_tag,image;
  int celebrity_id, designer_id, product_id;

  CelebrityData(
      {this.celebrity_name,
        this.designer_name,
        this.url_tag,
        this.product_url,
        this.banner_image,
        this.celebrity_id,
        this.designer_id,this.image,
        this.product_id});

  factory CelebrityData.fromJson(Map<String, dynamic> json) {
    return CelebrityData(
      // celebrity_name: json["celebrity_name"],
      celebrity_name:
      json.containsKey("name") ? json["name"] : json["celebrity_name"],
      designer_name: json["designer_name"],
      product_url: json["product_url"],
      banner_image: json.containsKey("large_image") ? json["large_image"] : json["banner_image"],
      image: json.containsKey("image")?json['image']:"",
      celebrity_id: json["celebrity_id"],
      designer_id: json["designer_id"],
      product_id: json["product_id"],
    );
  }
}
