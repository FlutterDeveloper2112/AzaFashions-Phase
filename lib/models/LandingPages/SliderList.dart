class SliderList{
  String layoutName;
  String title;
  List<SliderDetails> sliderList;
  String view_all_title,view_all_url,view_all_urltag;

  SliderList(this.layoutName,this.sliderList);

  SliderList.fromJson(Map<String,dynamic> json) {
    if (json != null) {
      sliderList = new List<SliderDetails>();
      layoutName= json["layout"];
      title= json["title"];
      json["list"] .forEach((v) {
        sliderList.add(new SliderDetails.fromJson(v));
      });
      view_all_title=json["view_all"]!="" && json["view_all"]!=null? json["view_all"]["title"]:"";
      view_all_url=json["view_all"]!="" && json["view_all"]!=null? json["view_all"]["url"]:"";
      view_all_urltag=json["view_all"]!="" && json["view_all"]!=null? json["view_all"]["url_tag"]:"";

    }
  }

}

class SliderDetails{
  String image,url,banner_section,section_heading,section_description,url_tag;
  String display_order;

  SliderDetails({this.image, this.url, this.banner_section,this.url_tag,
    this.section_heading, this.section_description, this.display_order});

  factory SliderDetails.fromJson(Map<String, dynamic> json) {
    return SliderDetails(
      url_tag: json["url_tag"],
      image: json["image"],
      url: json["url"],
      banner_section: json["banner_section"],
      section_heading: json["section_heading"],
      section_description: json["section_description"],
      display_order: json["display_order"].toString(),

    );
  }



}