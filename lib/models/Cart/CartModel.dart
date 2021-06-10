
class CartModel {
  String pageName;
  int attributeId;
  List<CartItems> products;

  CartModel({this.pageName, this.attributeId, this.products});

  CartModel.fromJson(Map<String, dynamic> json) {
    pageName = json['page_name'];
    attributeId = json['attribute_id'];
    products = json['products'].forEach((v) {
      CartItems.fromJson(v);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['page_name'] = pageName;
    jsonData['attribute_id'] = attributeId;
    if (this.products != null) {
      jsonData['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return jsonData;
  }

}

class CartItems {
  int productId;
  int sizeId;
  int quantity;
  int parentId;

  CartItems({this.productId, this.sizeId, this.quantity, this.parentId});

  CartItems.fromJson(Map<String, dynamic> json) {
    productId = json['id'];
    sizeId = json['size_id'];
    quantity = json['quantity'];
    parentId = json['parent_id'];
  }


  toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['id'] = productId;
    jsonData['size_id'] = sizeId;
    jsonData['quantity'] = quantity;
    jsonData['parent_id'] = parentId;
    return jsonData;

  }
}
