import 'package:azaFashions/ui/Filter/Multiple.dart';

class Filters {
  // int id;
  String name;
  String field;
  String selection;
  bool nested;
  List<FilterItems> items;
  List<FilterTitle> headings;
  String min;
  String max;

  // bool selected;

  Filters(
      {this.name,
        this.field,
        this.items,
        this.selection,
        this.nested,
        this.min,
        this.max});

  Filters.fromJson(Map<String, dynamic> json) {

    // id = json['id'];
    name = json['name'];
    field = json['field'];
    selection = json['selection'];
    nested = json['nested'];
    json.containsKey("min") ? min = json['min'] : null;
    json.containsKey("max") ? max = json['max'] : null;
    items = List<FilterItems>();
    headings = List<FilterTitle>();

    if (json.containsKey('list')) {
      json['list'].forEach((v) {
        if (v.containsKey('title')) {
          headings.add(FilterTitle.fromJson(v));
        } else {
          items.add(FilterItems.fromJson(v));
        }
      });
    }
  }
}

class FilterTitle {
  String title;
  List<FilterItems> list;
  bool selected;
  String value;

  FilterTitle(this.title, this.list, this.selected);

  FilterTitle.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    selected = false;
    list = List<FilterItems>();
    value = json['value'].toString();
    if (json.containsKey('list')) {
      json['list'].forEach((v) {
        list.add(FilterItems.fromJson(v));
      });
    }
  }
}

class FilterItems {
  String value;
  String name;
  bool selected;
  int count;
  String field;
  List<FilterSubItems> subItems;

  FilterItems(
      {this.value, this.name, this.selected, this.count, this.subItems,this.field});

  FilterItems.fromJson(Map<String, dynamic> json) {
    subItems = List<FilterSubItems>();
    value = json['value'].toString();
    name = json['name'];
    field = json['field'];
    selected = json.toString().contains("selected") ? json['selected'] : false;
    json.toString().contains('count') ? count = json['count'] : null;
    json.containsKey("list")
        ? json['list'].forEach((v) {
      subItems.add(FilterSubItems.fromJson(v));
    })
        : [];
  }
}

class FilterSubItems {
  String value;
  String name;
  bool selected;
  int count;
  String field;


  FilterSubItems(
      {this.value, this.name, this.selected, this.count,this.field});

  FilterSubItems.fromJson(Map<String, dynamic> json) {

    value = json['value'].toString();
    name = json['name'];
    field = json['field'];
    selected = json.toString().contains("selected") ? json['selected'] : false;
    json.toString().contains('count') ? count = json['count'] : null;

  }
}

// class Filters {
//   // int id;
//   String name;
//   String field;
//   String selection;
//   bool nested;
//   List<FilterItems> items;
//   String min;
//   String max;
//
//   // bool selected;
//
//   Filters({this.name, this.field, this.items, this.selection, this.nested,this.min,this.max});
//
//   Filters.fromJson(Map<String, dynamic> json) {
//     // id = json['id'];
//     name = json['name'];
//     field = json['field'];
//     selection = json['selection'];
//     nested = json['nested'];
//     json.containsKey("min") ? min = json['min']:null;
//     json.containsKey("max") ? max = json['max']:null;
//     items = List<FilterItems>();
//     print("MAX $max");
//
//     if(json.containsKey('list')){
//       json['list'].forEach((v) {
//         print("Filter ITEMS ${json['list']}");
//         items.add(FilterItems.fromJson(v));
//       });
//     }
//   }
// }
//
//
//
// class FilterTitle{
//
//   String title;
//   List<FilterItems> list;
//
//   FilterTitle(this.title, this.list);
//
//
//   FilterTitle.fromJson(Map<String,dynamic> json){
//
//     print("TITILE $json");
//     title = json['title'];
//
//     list = List<FilterItems>();
//
//     if(json.containsKey('list')){
//       json['list'].forEach((v) {
//         print(json['list'][0].containsKey('title'));
//         list.add(FilterItems.fromJson(v));
//       });
//     }
//
//   }
// }
//
//
// class FilterItems {
//   String value;
//   String name;
//   bool selected;
//   int count;
//
//   FilterItems({this.value, this.name, this.selected, this.count});
//
//   FilterItems.fromJson(Map<String, dynamic> json) {
//     value = json['value'].toString();
//     name = json['name'];
//     selected = json.toString().contains("selected")?json['selected']:false;
//     json.toString().contains('count') ? count = json['count'] : null;
//
//   }
// }
