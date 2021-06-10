
class CategoryModel {
  List<CategoryItems> items;

  CategoryModel(this.items);

  CategoryModel.fromJson(Map<String, dynamic> json) {
    items = List<CategoryItems>();
    json['data']['list'].forEach((v) {
      items.add(CategoryItems.fromJson(v));
    });
  }
}

class CategoryItems {
  int id;
  String name;
  String url;
  String image;
  List<CategoryItems> items;
  List<CategoryItems> list;

  CategoryItems(this.id, this.name, this.url, this.list,this.image);

  bool selected;

  CategoryItems.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    name = json['name'];
    url = json['url'];
    image=json.toString().contains("banner_image")?json["banner_image"]:"";
    selected = false;
    items = List<CategoryItems>();
    list = List<CategoryItems>();
    json.containsKey('list')
        ? json['list'].forEach((v) {
          print("ITEMS CATEGORY MODEL: ${v}:");
          items.add(CategoryItems.fromJson(v));
        v.containsKey('list') ? v['list'].forEach((e) {
          print("ITEMS CATEGORY MODEL: ${e}:");
        list.add(CategoryItems.fromJson(e));
      })
          : "";
    })
        : "";
  }
}

class CategoryItemsList {}
