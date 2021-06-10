

class AzaMagzine{
  String layoutName;
  String title;
  String url_tag;
  List<MagzineList> magzineList;

  AzaMagzine(this.layoutName,this.magzineList);

  AzaMagzine.fromJson(Map<String,dynamic> json) {
    if (json != null) {
      magzineList = new List<MagzineList>();
      layoutName= json["layout"];
      title=json["title"]!=null? json["title"]:"";
      url_tag=json["url_tag"]!=null? json["url_tag"]:"";

      json["list"] .forEach((v) {
        magzineList.add(new MagzineList.fromJson(v));
      });
    }
  }

}

class MagzineList{
  String title,url,image,description,url_tag;
  MagzineList({this.title,this.url,this.image,this.description,this.url_tag});

  factory MagzineList.fromJson(Map<String, dynamic> json) {
    return MagzineList(
      title: json["title"],
      url: json["url"],
      image: json["image"],
      description: json["description"],
      url_tag: json["url_tag"]

    );
  }



}