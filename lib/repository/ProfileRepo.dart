import 'dart:async';
import 'package:azaFashions/models/Orders/CancelReasonsListing.dart';
import 'package:azaFashions/models/Profile/CountryList.dart';
import 'package:azaFashions/models/Profile/MeasurementList.dart';
import 'package:azaFashions/models/Orders/OrderItemListing.dart';
import 'package:azaFashions/models/Orders/OrderListing.dart';
import 'package:azaFashions/models/Profile/Points.dart';
import 'package:azaFashions/models/Profile/ProfileAddressList.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/models/Orders/TrackingDetails.dart';
import 'package:azaFashions/models/Profile/WishList.dart';
import 'package:azaFashions/networkprovider/ProfileProvider.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:flutter/cupertino.dart';

class ProfileRepo{
  BuildContext context;

  ProfileProvider _apiProvider = new ProfileProvider();

  //Account
  //Change Password
  Future<UserLogin> passwordChange(String currPassword, String newPassword) => _apiProvider.changePassword(context, currPassword, newPassword);
  Future<UserLogin> getAccountDetails() => _apiProvider.accountDetails(context);
  Future updateAccountDetails(UserLogin details) => _apiProvider.updateAccountDetails(context,details);

  //ADDRESS
  Future<ResponseMessage> getAddAddress(BuildContext context,AddressModel addressModel) =>  _apiProvider.addAddress(context,addressModel);
  Future<ProfileAddressList> getAddressListRepo(String addressType) =>  _apiProvider.getAddressList(context,addressType);
  Future<ResponseMessage> removeAddressRepo(BuildContext context,int addressId) =>  _apiProvider.removeAddress(context,addressId);
  Future<ResponseMessage> getUpdateAddress(BuildContext context,int addressId,AddressModel addressModel) =>  _apiProvider.updateAddress(context,addressId,addressModel);
  Future<CountryStateList> getCountryList(BuildContext context,int id,String title) =>  _apiProvider.autoCompleteCountry(context, id,title);

  //Wallet , Credits , Loyalty points
  Future<PointsList> getPointsRepo() => _apiProvider.getPointsList(context);
  Future<PointsList> getLoyaltyPointsRepo() => _apiProvider.getLoyaltyPointsList(context);

  //WISHLIST
  Future wishlistRepo() => _apiProvider.getWishList(context);
  Future<WishListArray> addWishlistRepo(BuildContext context,int productId) => _apiProvider.getAddWishList(context,productId);
  Future<WishListArray> removeWishlistRepo(BuildContext context,int productId,String source) => _apiProvider.getRemoveWishList(context,productId,source);

  //ORDER
  Future<OrderListing> getOrderListRepo() =>  _apiProvider.getOrdersList(context);
  Future<OrderItemList> getOrderItemListRepo(int id) =>  _apiProvider.getOrdersItemList(context,id);
  Future<OrderItemList> shareProductFeedbackRepo(int orderId,int itemId,int rating,String comment) =>  _apiProvider.shareProductFeedback(context,orderId,itemId,rating,comment);

  Future<CancelReasonsListing>cancelItemRepo(CancelReasons cancelReasons,int orderId,int itemId)=>_apiProvider.cancelItem(context,cancelReasons,orderId,itemId);
  Future<CancelReasonsListing>cancelResonsRepo()=>_apiProvider.cancelReasons(context);
  Future<TrackingDetails>trackItemsRepo(BuildContext context,String orderId, String itemId)=>_apiProvider.trackItems(context,orderId,itemId);


  ///Measurements
  Future<MeasurementList> getMeasurementsRepo()=> _apiProvider.getMeasurements(context);
  addMeasurementRepo(measurements)=> _apiProvider.addMeasurements(context, measurements);
  removeMeasurementRepo(measurementId) => _apiProvider.removeMeasurements(context, measurementId);
  updateMeasurementRepo(measurements) => _apiProvider.updateMeasurements(context, measurements);


}
