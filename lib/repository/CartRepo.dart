import 'dart:async';

import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Cart/CartModel.dart';
import 'package:azaFashions/networkprovider/CartProvider.dart';
import 'package:flutter/cupertino.dart';

class CartRepo
{
  BuildContext context;

  CartProvider _apiProvider = new CartProvider();


  //Cart Repository
  addCartRepo(CartModel cartModel) => _apiProvider.addCart(context, cartModel);
  removeCartItemRepo(int productId, int sizeId, int quantity,String source) => _apiProvider.removeItem(context, productId, sizeId, quantity,source);
  Future<CartListing> getCartItemListRepo() =>  _apiProvider.getCartItemList(context);

}
