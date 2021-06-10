import 'package:azaFashions/utils/SessionDetails.dart';

class SideNavigationModel {
  MainListing mainListing;
  AzaListing azaListing;
  BuyingGuideList buyingGuideList;
  PolicyList policyList;
  String error, success;

  SideNavigationModel(
      {this.mainListing,
        this.azaListing,
        this.buyingGuideList,
        this.policyList});

  SideNavigationModel.fromJson(Map<String, dynamic> json) {
    SessionDetails details = SessionDetails();
    if (json["side_navigation"] != null) {
      mainListing = MainListing.fromJson(json["side_navigation"]["main"]);
      azaListing = AzaListing.fromJson(json["side_navigation"]["aza"]);
      buyingGuideList =
          BuyingGuideList.fromJson(json["side_navigation"]["buying_guide"]);
      policyList = PolicyList.fromJson(json["side_navigation"]["policies"]);
      print(json['side_navigation']);


      details.saveSideNavigation(SideNavigationModel(
          mainListing: mainListing,
          azaListing: azaListing,
          buyingGuideList: buyingGuideList,
          policyList: policyList));

    }
    else{

      mainListing = MainListing.fromJson(json["main"]);
      azaListing = AzaListing.fromJson(json["aza"]);
      buyingGuideList =
          BuyingGuideList.fromJson(json["buying_guide"]);
      policyList = PolicyList.fromJson(json["policies"]);


      details.saveSideNavigation(SideNavigationModel(
          mainListing: mainListing,
          azaListing: azaListing,
          buyingGuideList: buyingGuideList,
          policyList: policyList));

    }

  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();

    json['main'] = mainListing;
    json['aza'] = azaListing;
    json['buying_guide'] = buyingGuideList;
    json['policies'] = policyList;
    return json;
  }
}

class MainListing {
  String title;
  List<ListItem> mainItems;

  MainListing({this.title, this.mainItems});

  MainListing.fromJson(Map<String, dynamic> json) {
    if (json["list"] != null) {
      title = json["title"];
      mainItems = new List<ListItem>();
      json["list"].forEach((v) {
        mainItems.add(new ListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();

    json['title'] = title;
    json['list'] = mainItems;

    return json;
  }
}

class AzaListing {
  String title;
  List<ListItem> azaItems;

  AzaListing({this.title, this.azaItems});

  AzaListing.fromJson(Map<String, dynamic> json) {
    if (json["list"] != null) {
      title = json["title"];
      azaItems = new List<ListItem>();
      json["list"].forEach((v) {
        azaItems.add(new ListItem.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();

    json['title'] = title;
    json['list'] = azaItems;

    return json;
  }
}

class BuyingGuideList {
  String title;
  List<ListItem> buyingGuideItems;

  BuyingGuideList({this.title, this.buyingGuideItems});

  BuyingGuideList.fromJson(Map<String, dynamic> json) {
    if (json["list"] != null) {
      title = json["title"];
      buyingGuideItems = new List<ListItem>();
      json["list"].forEach((v) {
        buyingGuideItems.add(new ListItem.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();

    json['title'] = title;
    json['list'] = buyingGuideItems;

    return json;
  }
}

class PolicyList {
  String title;
  List<ListItem> policyItems;

  PolicyList({this.title, this.policyItems});

  PolicyList.fromJson(Map<String, dynamic> json) {
    if (json["list"] != null) {
      title = json["title"];
      policyItems = new List<ListItem>();
      json["list"].forEach((v) {
        policyItems.add(new ListItem.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();

    json['title'] = title;
    json['list'] = policyItems;

    return json;
  }
}

class ListItem {
  String title, url, url_tag, image;

  ListItem({this.title, this.url, this.url_tag, this.image});

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
        title: json["title"],
        url: json["url"],
        url_tag: json["url_tag"],
        image: json.toString().contains("icon") ? json["icon"] : null);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();

    json['title'] = title;
    json['url'] = url;
    json['url_tag'] = url_tag;
    json['icon'] = image;

    return json;
  }
}
