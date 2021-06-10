
class SortList {
  List<Sort> sort;

  SortList({this.sort});

  SortList.fromJson(dynamic json) {
    if (json != null) {
      sort = new List<Sort>();
      json .forEach((v) {
        sort.add(new Sort.fromJson(v));
      });
    }
  }
}

class Sort {
  int order;
  String name,field,url;
  bool selected;

  Sort({this.order, this.name,this.url,this.field,this.selected});

  Sort.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    name = json['name'];
    field = json['field'];
    selected = json['selected'];
    url = json['url'];

  }

  Sort.toJson() {
    Map<String, dynamic> jsonData = {};
    jsonData['order'] = order;
    jsonData['name'] = name;
  }
}