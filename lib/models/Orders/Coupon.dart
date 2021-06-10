
class Coupon{
  String code,discount_type,discount_value;

  Coupon({this.code, this.discount_type, this.discount_value});

  factory Coupon.fromJson(dynamic json) {

      return Coupon(
          code : json["code"],
          discount_type : json["discount_type"].toString(),
          discount_value : json["discount_value"].toString()
      );


  }

}