import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Checkout/CheckOutListing.dart';
import 'package:azaFashions/networkprovider/CheckoutProvider.dart';
import 'package:flutter/cupertino.dart';

class CheckoutRepo {
  BuildContext context;

  CheckoutProvider _checkoutProvider = CheckoutProvider();

  Future<CartListing> couponRepo(String coupon,String action) => _checkoutProvider.coupon(context, coupon,action);
  Future<CartListing> redeem(String action,String type,int amount)=>_checkoutProvider.redeemItems(context, action, type, amount);
  Future<CheckoutListing> getCheckoutItemListRepo(bool is_gift,String gift_instr,bool is_orderInst, String orderIns) =>  _checkoutProvider.getCheckoutItemList(context,is_gift,gift_instr,is_orderInst,orderIns);
  Future<CheckoutListing> getSelectedAddressRepo(int addressId, String selection_type) =>  _checkoutProvider.getSelectedAddress(context,addressId,selection_type);
}
