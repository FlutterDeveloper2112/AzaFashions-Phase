
import 'package:azaFashions/models/ProductDetail/EmiDetails.dart';
import 'package:azaFashions/models/ProductDetail/ProductItemDetail.dart';
import 'package:azaFashions/networkprovider/ProductDetailProvider.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:flutter/cupertino.dart';

class ProductDetailRepo{
  BuildContext context;

  ProductDetailProvider _apiProvider = new ProductDetailProvider();
  Future<ProductItemDetail> getProductDetailsRepo(int productId,String url)=> _apiProvider.getProductDetails(context, productId,url);

  Future<ResponseMessage> codAvailabilityRepo(String pinCode)=> _apiProvider.checkCODAvailability(context, pinCode);

  Future<EmiDetails> emiDetails(String amount)=> _apiProvider.getEmiDetails(context,amount);
  Future<ResponseMessage> customization(Map<String,dynamic> body,int productId) => _apiProvider.customization(context,body, productId);

}