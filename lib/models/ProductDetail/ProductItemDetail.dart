import 'package:azaFashions/models/ProductDetail/MediaGallery.dart';
import 'package:azaFashions/models/ProductDetail/MoreOptions.dart';
import 'package:azaFashions/models/ProductDetail/PriceMatch.dart';
import 'package:azaFashions/models/ProductDetail/ProductSize.dart';


class ProductItemDetail {
  String success="";
  static String error="";
  int id;
  String sku;
  String name;
  String thumbnail;
  List<MediaGallery> mediaGallery;
  List<ProductSize> sizes;
  List<MoreOptions> moreOptions;
  String url;
  int designerId;
  String designerName;
  String colorId;
  String colorName;
  int categoryId;
  String categoryName;
  int rootCategoryId;
  String rootCategoryName;
  String returnPolicy="";
  String styleNote;
  String additionInformation;
  bool isExchangeable;
  bool emiEnable;
  String applicableGstPercentage;
  bool inStock;
  bool canCustomize;
  bool canPreBook;
  int miniMeProductId;
  bool isSale;
  bool forIndia;
  bool forUSA;
  bool forRow;
  bool inWishList;
  bool inCart;
  bool priceOnRequest;
  String mrp,display_mrp;
  String discountPercentage;
  String youPay,display_you_pay;
  bool canCustomizeBlouse;
  int loyaltyPoints;
  String payableTax;
  List<String> loyalty_point_info;

  PriceMatch priceMatch;
  String sizeGuide;
  PromoPrompt promoPrompt;
  String tag;

  ProductItemDetail(
      this.id,
      this.sku,
      this.name,
      this.thumbnail,
      this.mediaGallery,
      this.sizes,
      this.moreOptions,
      this.url,
      this.designerId,
      this.designerName,
      this.colorId,
      this.colorName,
      this.categoryId,
      this.categoryName,
      this.rootCategoryId,
      this.rootCategoryName,
      this.returnPolicy,
      this.styleNote,
      this.additionInformation,
      this.isExchangeable,
      this.emiEnable,
      this.applicableGstPercentage,
      this.inStock,
      this.canCustomize,
      this.canPreBook,
      this.miniMeProductId,
      this.isSale,
      this.forIndia,
      this.forUSA,
      this.forRow,
      this.inWishList,
      this.inCart,
      this.priceOnRequest,
      this.mrp,
      this.discountPercentage,
      this.youPay,this.sizeGuide,this.promoPrompt,this.tag,
      this.canCustomizeBlouse,this.loyaltyPoints,this.payableTax,this.display_mrp,this.display_you_pay,this.priceMatch,this.loyalty_point_info);


  ProductItemDetail.withError(String error){
    ProductItemDetail.error= error;
  }
  ProductItemDetail.withSuccess(String success){
    this.success= success;
  }

  ProductItemDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    name = json['name'];
    thumbnail = json['thumbnail_image'];
    mediaGallery = new List<MediaGallery>();
    json["media_gallery"].forEach((v) {
      mediaGallery.add(new MediaGallery.fromJson(v));
    }); //MediaGallery
    sizes = new List<ProductSize>();
    json["sizes"].forEach((v) {
      sizes.add(new ProductSize.fromJson(v));
    }); //Size
    moreOptions  = new List<MoreOptions>();
    json['more_options'].forEach((v){
      moreOptions.add(new MoreOptions.fromJson(v));
    });
    url = json['url'];
    designerId = json['designer_id'];
    designerName = json['designer_name'];
    colorId = json['color_id'];
    colorName = json['color_name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    rootCategoryId = json['root_category_id'];
    rootCategoryName = json['root_category_name'];
    returnPolicy = json['return_policy'];
    styleNote = json['stylist_note'];
    additionInformation = json['additional_information'];
    isExchangeable = json['is_exchangeable'];
    emiEnable = json['emi_enabled'];
    applicableGstPercentage = json['applicable_gst_percentage'];
    inStock = json['in_stock'];
    canCustomize = json['can_customize'];
    canPreBook = json['can_pre_book'];
    miniMeProductId = json['mini_me_product_id'];
    isSale = json['is_sale'];
    forIndia = json['for_india'];
    forUSA = json['for_usa'];
    forRow = json['for_row'];
    inWishList = json['in_wishlist'];
    inCart = json['in_cart'];
    priceOnRequest = json['price_on_request'];
    mrp = json['mrp'];
    discountPercentage = json['discount_percentage'].toString();
    youPay = json['you_pay'];
    canCustomizeBlouse = json['can_customize_blouse'];
    loyaltyPoints = json['loyalty_points'];
    loyalty_point_info = new List<String>();
    json["loyalty_points_info"]["list"].forEach((v) {
      loyalty_point_info.add(v.toString());
    });

    payableTax = json['payable_tax'];
    display_mrp= json["display_mrp"].toString();
    display_you_pay= json["display_you_pay"].toString();
    priceMatch = PriceMatch.fromJson(json['price_match']);
    sizeGuide = json['size_guide_url'];
    promoPrompt = PromoPrompt.fromJson(json['promo_prompt']);
    tag  = json['tag'];

  }
  }


class PromoPrompt{
  String header;
  String message;
  String code;


  PromoPrompt(this.header, this.message, this.code);

  PromoPrompt.fromJson(Map<String,dynamic> json){
    header= json['header'];
    message = json.toString().contains("message")?json['message']:"";
    code  = json.toString().contains("code")?json['code']:"";
  }
}





