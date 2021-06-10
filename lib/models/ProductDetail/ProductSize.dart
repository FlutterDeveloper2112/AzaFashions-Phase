class ProductSize{

  int id;
  String name;
  String mrp,display_mrp;
  String discountPercentage;
  String youPay,display_you_pay;
  int availableQuantity;
  bool inWareHouse;
  String estimatedDelivery;
  String fastDelivery;
  String estimated_delivery_weeks;
  bool inCart;
  ProductSize(
      {this.id,
        this.name,
        this.mrp,
        this.discountPercentage,
        this.youPay,
        this.availableQuantity,
        this.inWareHouse,
        this.estimatedDelivery,this.display_mrp,this.display_you_pay,this.fastDelivery,this.estimated_delivery_weeks,this.inCart});

  ProductSize.fromJson(Map<String,dynamic> json){
    id = json['id'];
    name = json['name'];
    mrp= json['mrp'].toString();
    discountPercentage = json['discount_percentage'].toString();
    youPay = json['you_pay'].toString();
    inCart =json["in_cart"];
    availableQuantity = json['available_quantity'];
    inWareHouse= json['in_warehouse'];
    estimatedDelivery= json['estimated_delivery'];
    display_mrp = json['display_mrp'].toString();
    display_you_pay = json['display_you_pay'].toString();
    fastDelivery = json["faster_delivery_styles_url"];
    estimated_delivery_weeks=json["estimated_delivery_weeks"].toString();

  }
}