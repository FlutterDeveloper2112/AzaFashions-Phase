import 'package:azaFashions/bloc/ProfileBloc/OrderBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Orders/ItemListing.dart';
import 'package:azaFashions/models/Orders/OrderItemListing.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/OrderModule/ItemPattern.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:webengage_flutter/webengage_flutter.dart';


class OrderDetail extends StatefulWidget {
  String tag;
  int orderId;
  String customerId;
  OrderDetail(this.tag,this.orderId,this.customerId);
  @override
  OrderDetailPage createState() =>OrderDetailPage();
}

class OrderDetailPage extends State<OrderDetail> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final connectivity=new ConnectivityService();
  var connectionStatus;

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("Order Detail Screen: ${widget.orderId}");
    analytics.setCurrentScreen(screenName: "Order Detail/${widget.orderId}");

  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
      connectionStatus.toString()!="ConnectivityStatus.Offline"?order_bloc.fetchAllOrderItems(widget.orderId):"";

    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar:AppBarWidget().myAppBar(context, "Order Details",scaffoldKey),
          body: ScrollConfiguration(
              behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
              child:connectionStatus.toString()!="ConnectivityStatus.Offline"?SingleChildScrollView(
                  child:Column(
                      children:<Widget> [
                        StreamBuilder<OrderItemList>(
                            stream: order_bloc.fetchOrderItemList,
                            builder: (context, snapshot) {
                              if(snapshot.connectionState==ConnectionState.active){
                                if(snapshot.data.order_detailsList.length>0){
                                  List<OrderDetailList> _orderDetails = snapshot.data.order_detailsList;
                                  return Column(
                                      children:<Widget> [
                                        new ListView.builder(
                                          shrinkWrap: true,
                                          physics:  NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(left:10.0,right: 5,top: 15,bottom: 5),
                                          itemCount: _orderDetails.length,
                                          itemBuilder: (BuildContext context, int index) => new Container(
                                            color: Colors.white,
                                            child: new Column(
                                                children: <Widget>[
                                                  ItemPattern(
                                                    tag:"DetailScreen",
                                                    screen_name:"OrderDetails",
                                                    order_Date:"${_orderDetails[index].order_date}" ,
                                                    order_id:_orderDetails[index].order_id,
                                                    customer_id: widget.customerId,
                                                    model: _orderDetails[index].order_model.model,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        pickUpAddress(context,snapshot.data.order_detailsList),
                                        totalPrice(context,snapshot.data.order_detailsList),


                                      ]);
                                }
                                else{
                                  return  Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),child:ErrorPage(appBarTitle: "No Items Found",));
                                }

                              }
                              else{
                                return Center(child: CircularProgressIndicator(),);
                              }
                            }
                        )

                      ])
              ):ErrorPage(appBarTitle: "You are offline.",))),
    );
  }
  //AddressUI
  Widget pickUpAddress(BuildContext context,List<OrderDetailList> orderDetailList){
    return  Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left:15,right:15,top: 5),
            child: Align(
                alignment: Alignment.centerLeft,
                child:Text(
                  "PICKUP ADDRESS",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      fontFamily: "Helvetica",
                      color: Colors.black),
                ))),


        Padding(padding: EdgeInsets.only(left:15,right:15,top: 15),child: Align(
            alignment: Alignment.centerLeft,
            child:Text(
              "Shipping Address : ",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.5,
                  fontFamily: "Helvetica",
                  color: Colors.black87),
            ))),

        Padding(padding: EdgeInsets.only(left:15,right:15,top: 5),child:Container(

          child: Align(
              alignment: Alignment.centerLeft,
              child:Text(
                "${orderDetailList[0].shippingAddress.addressOne}, ${orderDetailList[0].shippingAddress.cityName}, ${orderDetailList[0].shippingAddress.stateName}, ${orderDetailList[0].shippingAddress.countryName}, ${orderDetailList[0].shippingAddress.postalCode} ",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    fontFamily: "Helvetica",
                    color: Colors.black87),
              )),
        )),
        Padding(padding: EdgeInsets.only(left:15,right:15,top: 15),child: Align(
            alignment: Alignment.centerLeft,
            child:Text(
              "Billing Address : ",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.5,
                  fontFamily: "Helvetica",
                  color: Colors.black87),
            ))),

        Padding(padding: EdgeInsets.only(left:15,right:15,top: 5,bottom:10),child:Container(
          child: Align(
              alignment: Alignment.centerLeft,
              child:Text(
                "${orderDetailList[0].billingAddress.addressOne}, ${orderDetailList[0].billingAddress.cityName}, ${orderDetailList[0].billingAddress.stateName}, ${orderDetailList[0].billingAddress.countryName}, ${orderDetailList[0].billingAddress.postalCode} ",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    fontFamily: "Helvetica",
                    color: Colors.black87),
              )),
        )),
        Container(
            padding: EdgeInsets.only(left:15,right:15,top: 5,bottom: 15),
            child: Divider(thickness: 2,color: Colors.grey[200],)),


      ],
    );
  }


  //Price Calculation
  Widget totalPrice(BuildContext context,List<OrderDetailList> orderDetailList){
    return  Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left:15,right:15,top: 5,bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "TOTAL ORDER PRICE",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      fontFamily: "PlayfairDisplay",
                      color: Colors.black),
                ),
                Text(
                    "${CountryInfo.currencySymbol} ${orderDetailList[0].order_amount}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black
                    )),
              ],
            )),
        Padding(padding: EdgeInsets.only(left:15,right:15,top: 5,bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                orderDetailList[0].coupon!=null?Flexible(child:  RichText(
                  text: TextSpan(
                    text: "You Saved",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13,fontFamily: "Helvetica"),
                    children: <TextSpan>[
                      TextSpan(text: " ${CountryInfo.currencySymbol} ${orderDetailList[0].coupon.discount_value}", style: TextStyle( fontWeight: FontWeight.normal,fontSize: 13,color: Colors.green)),
                      TextSpan(text: " on this order", style: TextStyle( fontWeight: FontWeight.normal,fontSize: 13,color: Colors.black)),
                    ],
                  ),
                )):Center(),
                InkWell(
                  onTap: (){
                    CustomBottomSheet().priceBreakup(context, orderDetailList);
                  },
                  child:  Align(
                    alignment: Alignment.topRight,
                    child:    Text(
                      "View Breakup",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.red[400]),
                    ),
                  ),

                )
              ],
            )
        ),
        Container(
            padding: EdgeInsets.only(left:15,right:15,top: 5,bottom: 5),
            child: Divider(thickness: 2,color: Colors.grey[200],)),


      ],
    );
  }




}
