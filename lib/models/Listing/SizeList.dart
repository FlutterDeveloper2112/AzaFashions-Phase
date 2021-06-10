
import 'package:azaFashions/models/ProductDetail/ProductSize.dart';

class SizeList {
  List<Size> size;
  int index=0;
  bool openedSheet;
  SizeList(this.size);

  SizeList.fromJson(dynamic json) {
    if (json != null) {
      size = new List<Size>();
      // size = new List<ProductSize>();
      // json["sizes"].forEach((v) {
      //   size.add(new ProductSize.fromJson(v));
      // }); //
      openedSheet = false;
      json .forEach((v) {
        size.add(new Size.fromJson(v));
      });
    }

  }
}

class Size {
  int id;
  String name;
  String youPay,display_you_pay;
  bool isSelectedSize;

  Size({this.id, this.name,this.isSelectedSize});

  Size.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    youPay = json.containsKey("you_pay")?json['you_pay'].toString():"";
    display_you_pay = json.containsKey("display_you_pay")?json['display_you_pay'].toString():"";
    isSelectedSize = false;
  }

  Size.toJson() {
    Map<String, dynamic> jsonData = {};
    jsonData['id'] = id;
    jsonData['name'] = name;
  }
}