

class BulletMenuList {
  List<MenuModel> menu_model;
  List<TopMenu> top_menu;

  String error;

  BulletMenuList({this.menu_model,this.top_menu});

  BulletMenuList.withError(String errorMessage) {
    error = errorMessage;
  }

  BulletMenuList.fromJson(Map<String, dynamic> json) {
    print("BULLET DATA: ${json}");
    if (json["data"]["bullet_menu"] != null) {
      menu_model = new List<MenuModel>();
      json["data"]["bullet_menu"] .forEach((v) {
        menu_model.add(new MenuModel.fromJson(v));

      });
    }
    if(json["data"]["top_menu"]!=null){
      top_menu = new List<TopMenu>();
      json["data"]["top_menu"] .forEach((v) {
        top_menu.add(new TopMenu.fromJson(v));

      });
    }
  }

}

class MenuModel{

  String title;
  String url;
  String url_tag;
  String image;

  MenuModel({this.title, this.url,this.url_tag,this.image});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
        title: json["title"],
        url: json["url"],
        image: json["image"],
        url_tag: json["url_tag"]
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

class TopMenu{

  String title;
  String url;


  TopMenu({this.title, this.url});

  factory TopMenu.fromJson(Map<String, dynamic> json) {
    return TopMenu(
        title: json["title"],
        url: json["url"],
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








