class MoreOptions{
  String title,page_title,url_tag;
  String url;

  MoreOptions(this.title, this.url,this.page_title,this.url_tag);

  MoreOptions.fromJson(Map<String,dynamic> json){
    title = json['title'];
    url = json['url'];
    page_title=json["page_title"];
    url_tag=json["url_tag"];
  }
}