class VanillaBanner{
  String image,url,url_tag,screen_title;

  VanillaBanner({this.image, this.url,this.url_tag,this.screen_title});

  factory VanillaBanner.fromJson(Map<String, dynamic> json) {
    return VanillaBanner(
      image: json["image"],
      url: json["url"],
      url_tag:json["url_tag"],
      screen_title:json["screen_title"],

    );
  }



}