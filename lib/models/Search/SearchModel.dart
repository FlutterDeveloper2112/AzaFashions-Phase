import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllText.dart';
import 'package:azaFashions/ui/Search/SearchSuggestion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchModel {
  List<Widget> widgets;
  SearchItemList designers;
  SearchItemList categories;
  ChildListingModel products;
  SearchItemList celebrity;
  SearchItemList occasions;
  SearchItemList hottestTrends;
 static String url;


  String error,success;


  SearchModel(this.widgets, this.designers, this.categories, this.products,
      this.celebrity, this.occasions, this.hottestTrends,this.error);


  SearchModel.withError(String error){
    this.error = error;
  }
  SearchModel.fromJson(Map<String, dynamic> json) {
    this.error="";
    if (json['data'].containsKey('sections')) {
      print(json['data']['sections']);
      widgets = List<Widget>();
      json['data']['sections'].forEach((v) {
        if (v['title'] == "Designers") {
          designers = SearchItemList.fromJson(v);
          widgets.add(SearchSuggestion(
            title: designers.title,
            searchItems: designers,
          ));
          widgets.add(SizedBox(height: 10,));
        } else if (v['title'] == "Categories") {
          categories = SearchItemList.fromJson(v);
          widgets.add(SearchSuggestion(
            title: categories.title,
            searchItems: categories,
          )
          );
          widgets.add(SizedBox(height: 10,));
        } else if (v['title'] == "Products") {
          print("SARCH ${v}");
          products = ChildListingModel.fromJson(v,1);
          print("SEARCH PRODUCTS LENGTH: ${products.new_model.length}");
          widgets.add(SearchSuggestion(
            title: v['title'],
            products: products,
          ));
          widgets.add(SizedBox(height: 10,));
        } else if (v['title'] == "Occasion") {
          occasions = SearchItemList.fromJson(v);
          widgets.add(SearchSuggestion(
            title: occasions.title,
            searchItems: occasions,
          ));
          widgets.add(SizedBox(height: 10,));
        } else if (v['title'] == "Hottest Trends") {
          hottestTrends = SearchItemList.fromJson(v);
          widgets.add(SearchSuggestion(
            title: hottestTrends.title,
            searchItems: hottestTrends,
          ));
          widgets.add(SizedBox(height: 10,));
        } else if (v['title'] == "Celebrity") {
          celebrity = SearchItemList.fromJson(v);
          widgets.add(SearchSuggestion(
            title: celebrity.title,
            searchItems: celebrity,
          ));
          widgets.add(SizedBox(height: 10,));
        }
      });

    }
    if(json.toString().contains("view_all")){
      url=json["data"]["view_all"]["url"];
      widgets.add(Padding(padding:EdgeInsets.only(bottom: 30)));
     // );
    }
  }
}

class SearchItemList {
  String title;
  String urlTag;
  List<SearchItems> searchItems;

  SearchItemList(this.searchItems);

  SearchItemList.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    urlTag = json['url_tag'];
    searchItems = List<SearchItems>();
    json['list'].forEach((v) {
      searchItems.add(SearchItems.fromJson(v));
    });
  }
}

class SearchItems {
  int id;
  String name;
  String url;

  SearchItems({this.id, this.name, this.url});

  SearchItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
  }
}
