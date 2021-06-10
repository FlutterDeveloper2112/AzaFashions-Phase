

class BannerCarousel{
  String layoutName;
  String title;
  List<BannerList> bannerList;
  String view_all_title,view_all_url,view_all_urltag;

  BannerCarousel(this.layoutName,this.bannerList);

  BannerCarousel.fromJson(Map<String,dynamic> json) {
    if (json != null) {
      bannerList = new List<BannerList>();
      layoutName= json["layout"];
      title=json["title"]!=""? json["title"]:"";
      json["list"] .forEach((v) {
        bannerList.add(new BannerList.fromJson(v));
        print("BannerList: ${bannerList.length}");
      });
      view_all_title=json["view_all"]!="" && json["view_all"]!=null? json["view_all"]["title"]:"";
      view_all_url=json["view_all"]!="" && json["view_all"]!=null? json["view_all"]["url"]:"";
      view_all_urltag=json["view_all"]!="" && json["view_all"]!=null? json["view_all"]["url_tag"]:"";

    }
  }

}

class BannerList{
  String image,url,banner_section,section_heading,section_description,url_tag,section_sub_heading;
  String display_order;
  String designer_title,designer_description,action_text;

  BannerList({this.image, this.url, this.banner_section,this.url_tag,
      this.section_heading, this.section_description, this.section_sub_heading,this.display_order,this.designer_title,this.designer_description,this.action_text});

  factory BannerList.fromJson(Map<String, dynamic> json) {
    return BannerList(
      image: json["image"],
      url: json["url"],
      url_tag: json["url_tag"],
      banner_section: json["banner_section"],
      section_heading: json["section_heading"],
      section_description: json["section_description"],
      section_sub_heading: json["section_sub_heading"],
      display_order: json["display_order"].toString(),
      designer_description: json["section_sub_heading"]!=""?json["section_sub_heading"]:"",
      action_text: json["action_text"]!=""?json["action_text"]:"",
    );
  }



}