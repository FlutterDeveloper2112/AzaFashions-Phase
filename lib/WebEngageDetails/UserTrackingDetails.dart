import 'package:azaFashions/models/Cart/CartModel.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class UserTrackingDetails{

  signInDetails(String username,String customerId){
    WebEngagePlugin.trackEvent('Sign In', {'Email Address' : username,'User ID' : int.parse(customerId)});
  }
  signUpDetails(String username,String customerId,String firstname,String lastname,String mobile){
    WebEngagePlugin.trackEvent('Sign In', {'Email Address' : username,'User ID' : customerId,'FirstName' :firstname,'LastName':lastname,'Mobile':mobile});
  }
  forgetPassword(String username) {
    WebEngagePlugin.trackEvent('Forget Password', {'Email Address': username});
  }
  otpSent(String mobile) {
    WebEngagePlugin.trackEvent('OTP', {'Mobile': mobile});
  }

  followDesigner(String email,String designerId){
    WebEngagePlugin.trackEvent('Follow The Designer', {'Email Address': email,'Designer ID': designerId});
  }
  unFollowDesigner(String email,String designerId){
    WebEngagePlugin.trackEvent('UnFollow The Designer', {'Email Address': email,'Designer ID': designerId});
  }

  searchQuery(String query){
    WebEngagePlugin.trackEvent('Search', {'Keyword': query});
  }

  buyTogetherProducts(CartModel cartItems){
    WebEngagePlugin.trackEvent('Buy Together', {'PRODUCTS': cartItems});
  }

  productViewed(String productId,String productUrl,String designerName,String categoryId,String productPrice){
    WebEngagePlugin.trackEvent('Product Viewed' ,{'Product ID':productId,'Page URl':productUrl,'Designer' :designerName,'Category ID':int.parse(categoryId),'Product Price':double.parse(productPrice)});
  }

  promoCodeApplied(String code){
    WebEngagePlugin.trackEvent('Promo Code Applied', {'Code': code});

  }
  promoCodeRemoved(String code){
    WebEngagePlugin.trackEvent('Promo Code Removed', {'Code': code});
  }

  redeemPointsApplied(String title, String amount){
    WebEngagePlugin.trackEvent('Redeem Points Applied', {title: amount});
  }
  redeemPointsRemoved(String title,String amount){
    WebEngagePlugin.trackEvent('Redeem Points Removed', {title: amount});
  }

  emailSubscription(String email){
    WebEngagePlugin.trackEvent('Email Subscription', {'Email Address': email});
  }
  emailUnsubscription(String email){
    WebEngagePlugin.trackEvent('Email UnSubscription', {'Email Address': email});
  }




  addToWishlist(String designer,String imageUrl,String productId,String productPrice,String productUrl){

    WebEngagePlugin.trackEvent('Added to Wishlist', {'Designer' : designer,'Image URL' : imageUrl,'Product Id':productId,'Product Price': int.parse(productPrice),'Product URL':productUrl});
  }

  removedFromWishlist(String designer,String imageUrl,String productId,String productPrice,String productUrl){

    WebEngagePlugin.trackEvent('Removed From Wishlist', {'Designer' : designer,'Image URL' : imageUrl,'Product Id':productId,'Product Price': int.parse(productPrice),'Product URL':productUrl});
  }

  addToCart(String designer,String imageUrl,String productId,String productPrice,String productUrl){

    WebEngagePlugin.trackEvent('Added to Cart', {'Designer' : designer,'Image URL' : imageUrl,'Product Id':productId,'Product Price': int.parse(productPrice),'Product URL':productUrl});
  }

  removedFromCart(String designer,String imageUrl,String productId,String productPrice,String productUrl){

    WebEngagePlugin.trackEvent('Removed From Cart', {'Designer' : designer,'Image URL' : imageUrl,'Product Id':productId,'Product Price': int.parse(productPrice),'Product URL':productUrl});
  }

  cartViewed(String totalItems,String total_amount_payable,String total_discount){
    WebEngagePlugin.trackEvent('Cart Viewed',{'Cart Total':total_amount_payable,'Total Quantity':totalItems,'Cart Discount':total_discount});
  }
  checkoutShippingStarted(String address,String addressType){
    WebEngagePlugin.trackEvent('Checkout - Shipping Started', {'Address': address, 'Address Type' :addressType});
  }
  checkoutStarted(String totalItems,String total_amount_payable,String total_discount,String shippingAddress,String billingAddress){
    WebEngagePlugin.trackEvent('Checkout Started',{'Cart Total':total_amount_payable,'Total Quantity':totalItems,'Cart Discount':total_discount,'Shipping Address': shippingAddress,'Billing Address':billingAddress});
  }
  paymentPage(String amount,String paymentMode){
    WebEngagePlugin.trackEvent('Checkout - Shipping Started', {'Amount': amount, 'Payment Mode' :paymentMode});
  }
  orderSuccess(String orderid,String custom_order_id,String total_items,String total_discount,String totalAmount,String shippingAddress,String billingAddress){
    WebEngagePlugin.trackEvent('Order Success',{'Order ID': orderid,'Customer Order ID':custom_order_id,'Cart Total':totalAmount,'Total Quantity':total_items,'Cart Discount':total_discount,'Shipping Address': shippingAddress,'Billing Address':billingAddress});

  }
}