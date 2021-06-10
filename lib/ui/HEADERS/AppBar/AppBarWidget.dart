

import 'dart:io';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/PROFILE/ADDRESS/AddAddress.dart';
import 'package:azaFashions/ui/PROFILE/ProfileUI.dart';
import 'package:azaFashions/ui/SHOPPINGCART/ShoppingBag.dart';
import 'package:azaFashions/ui/Search/SearchUI.dart';
import 'package:azaFashions/ui/Search/TransparentRoute.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final connectivity = new ConnectivityService();
  var connectionStatus;
  @override
  AppBar myAppBar(BuildContext context, String title,
      GlobalKey<ScaffoldState> scaffoldKey,{String webview}) {
    return AppBar(
      centerTitle: true,
      leading: title=="AZA"?Padding(
        padding: EdgeInsets.only(left:10),
        child: InkWell(
          onTap: () {
            connectionStatus = Platform.isIOS
                ? connectivity.checkConnectivity1()
                : Provider.of<ConnectivityStatus>(context,listen: false);
            connectionStatus.toString() != "ConnectivityStatus.Offline"
                ? scaffoldKey.currentState.isDrawerOpen
                ? scaffoldKey.currentState.openEndDrawer()
                : scaffoldKey.currentState.openDrawer()
                : ToastMsg().getInternetFailureMsg(context);

          },
          child: Icon(
            Icons.menu,
            color: Colors.black,
            size: 30,
          ),
        ),
      ):
      InkWell(
        onTap: () async {
          if(webview=="WEBVIEW"||title=="Big Luxury Sale" || title=="Women"||title=="Accessories" ||title=="Jewellery"|| title =="Kids" || title=="Mens" || title=="Ready To Ship"||title=="Wedding" ){
            Navigator.of(context).pop();
            /*   Navigator.of(context)
                    .pushNamedAndRemoveUntil('/homePage', (Route<dynamic> route) => false);*/

          }
          else if(title=="Order Placed"){
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/homePage', (Route<dynamic> route) => false);

          }
          else if(title == "My Address"/* ||title == "Shipping Address" ||title == "Billing Address" ||*/ ||title == "Account Details" || title == "Add Measurements"){
            if(ProfileUI.isEdited){
              bool res = await CustomBottomSheet().saveChanges(context);
              if(res){
                Navigator.of(context).pop();
              }
              else{

              }
            }
            else{
              Navigator.pop(context);
            }
          }
          else {
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () async {
              if(webview=="WEBVIEW"||title=="Big Luxury Sale" || title=="Women"||title=="Accessories" ||title=="Jewellery"|| title =="Kids" || title=="Mens" || title=="Ready To Ship"||title=="Wedding" ){
                Navigator.of(context).pop();
                /*   Navigator.of(context)
                    .pushNamedAndRemoveUntil('/homePage', (Route<dynamic> route) => false);*/

              }
              else if(title=="Order Placed"){
                   Navigator.of(context)
                    .pushNamedAndRemoveUntil('/homePage', (Route<dynamic> route) => false);

              }
              else if(title == "My Address"/* ||title == "Shipping Address" ||title == "Billing Address" ||*/ ||title == "Account Details" || title == "Add Measurements"){
                if(ProfileUI.isEdited){
                  bool res = await CustomBottomSheet().saveChanges(context);
                  if(res){
                    Navigator.of(context).pop(true);
                  }
                  else{

                  }
                }
                else{
                  Navigator.pop(context);
                }
              }
              else {
                Navigator.of(context).pop();
              }
            },
            child: Platform.isAndroid?Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20
            ):Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          title=="AZA"?Expanded(
            child: Center(
                child:InkWell(
                  onTap:(){
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/homePage', (Route<dynamic> route) => false);
    },
                  child: Image.asset("images/splash_aza_logo.png",
                    width: 60, height: 60,),
                )),
          ):
          Expanded(
            child: Center(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$title",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "PlayfairDisplay",
                          fontSize: 16.5,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ))),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        title == "My Address" ||
            title == "Size Guide"||
            title == "Billing Address" ||
            title == "Shipping Address" ||
            title == "Credit/Debit" ||
            title == "Part Payment" ||
            title == "Cash On Delivery" ||
            title == "My Aza Wallet" ||
            title == "Aza Loyalty Points" ||
            title=="My WishList" ||
            title=="My Measurements" ||title== "Add Measurements"||
            title == "Payment Method" ||
            title == "Account Details" ||
            title == "Change Password" ||
            title == "Give Us Feedback" ||
            title == "My Addressess" ||
            title == "Shopping Bag" ||
            title=="Terms & Conditions"||
            title=="Privacy Policy"||
            title == "CheckOut" ||
            title == "My Orders" ||title=="Order Details"||title=="Reset Password"/*|| title=="DesignerProfile"*/||(webview!="WEBVIEW" && webview!="")
            ? Padding(
          padding: EdgeInsets.only(right: 10),
        ):
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {


              connectionStatus = Platform.isIOS
                  ? connectivity.checkConnectivity1()
                  : Provider.of<ConnectivityStatus>(context,listen: false);
              connectionStatus.toString() != "ConnectivityStatus.Offline"
                  ? Navigator.of(context).push(TransparentRoute(
                  builder: (BuildContext context) => SearchUI()))
                  : ToastMsg().getInternetFailureMsg(context);

            },
            child: Icon(
              Icons.search,
              color: Colors.black,
              size: 25,
            ),
          ),
        ),


//SHOPPING BAG
        title == "My Address" ||
            title == "Billing Address" ||
            title == "Shipping Address" ||
            title == "Cash On Delivery" ||
            title == "Credit/Debit" ||
            title == "Part Payment" ||
            title == "CheckOut" ||
            title == "Shopping Bag" ||
            title=="Terms & Conditions"||
            title=="Privacy Policy"||
            title == "Payment Method" ||
            title == "Size Guide"||title=="Reset Password"||title=="Order Details"||(webview!="WEBVIEW" && webview!="")
            ? Padding(padding: EdgeInsets.only(right: 15),)
            :  Stack(
          alignment: Alignment.topRight,
          children: [
            InkWell(
              onTap: (){
                connectionStatus = Platform.isIOS
                    ? connectivity.checkConnectivity1()
                    : Provider.of<ConnectivityStatus>(context,listen: false);
                connectionStatus.toString() !=
                    "ConnectivityStatus.Offline"
                    ? Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new ShoppingBag()))
                    : ToastMsg().getInternetFailureMsg(context);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 15,right: 15),
                child:ValueListenableBuilder(
                    valueListenable: BagCount.bagCount,
                    builder:(BuildContext context,int value,Widget child ) => BagCount.bagCount.value>0?Badge(
                      shape: BadgeShape.circle,
                      badgeColor: Colors.black,
                      alignment: Alignment.topLeft,
                      badgeContent: Text("${BagCount.bagCount.value}",style: TextStyle(
                          color: Colors.white,
                          fontSize:
                          BagCount.wishlistCount.value > 9
                              ? 10
                              : 12)),
                      child: GestureDetector(
                        onTap: ()async {
                          connectionStatus = Platform.isIOS
                              ? connectivity.checkConnectivity1()
                              : Provider.of<ConnectivityStatus>(context,listen: false);
                          connectionStatus.toString() !=
                              "ConnectivityStatus.Offline"
                              ? Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (__) => new ShoppingBag()))
                              : ToastMsg().getInternetFailureMsg(context);
                        },
                        child: Image.asset(
                          "images/cart_icon.png",
                          width: 21,
                          height: 21,
                        ),
                      ),
                    ):
                    GestureDetector(
                      onTap: ()async {
                        connectionStatus = Platform.isIOS
                            ? connectivity.checkConnectivity1()
                            : Provider.of<ConnectivityStatus>(context,listen: false);
                        connectionStatus.toString() !=
                            "ConnectivityStatus.Offline"
                            ? Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new ShoppingBag()))
                            : ToastMsg().getInternetFailureMsg(context);
                      },
                      child: Image.asset(
                        "images/cart_icon.png",
                        width: 20,
                        height: 20,
                      ),
                    )
                ),
              ),
            ),

          ],

        ),
      ],
      backgroundColor: Colors.white,
    );
  }


}
