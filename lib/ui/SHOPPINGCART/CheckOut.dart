import 'dart:io';
import 'package:azaFashions/bloc/CheckoutBloc/CheckoutBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Checkout/CheckOutListing.dart';
import 'package:azaFashions/models/Orders/PriceBreakdown.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PAYMENT/PaymentPage.dart';
import 'package:azaFashions/ui/PROFILE/ADDRESS/BillingAddress.dart';
import 'package:azaFashions/ui/PROFILE/ADDRESS/ShippingAddress.dart';
import 'package:azaFashions/ui/SHOPPINGCART/ShoppingCart.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';


class CheckOut extends StatefulWidget {
  bool is_gift,is_orderinstruction;
  String gift_instruction,order_instruction;
  CheckOut(this.is_gift,this.gift_instruction,this.is_orderinstruction,this.order_instruction);

  @override
  CheckOutPage createState() =>CheckOutPage();
}

class CheckOutPage extends State<CheckOut> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _termscondition=false;
  String order_payable,mobileNo;
  final connectivity=new ConnectivityService();
  var connectionStatus;
  bool shippingAddress=false,billingAddress=false;
  FirebaseAnalytics analytics= new FirebaseAnalytics();

  @override
  void initState() {
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    WebEngagePlugin.trackScreen("Checkout Page");
    analytics.setCurrentScreen(screenName: "Checkout Page");
    checkoutBloc.fetchAllCheckoutItems(widget.is_gift,widget.gift_instruction,widget.is_orderinstruction,widget.order_instruction);
    // connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);connectionStatus.toString()!="ConnectivityStatus.Offline"? checkoutBloc.fetchAllCheckoutItems(widget.is_gift,widget.gift_instruction,widget.is_orderinstruction,widget.order_instruction):"";

    super.initState();
  }

  @override
  void dispose() {
    connectivity.dispose();

    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar: AppBarWidget().myAppBar(context, "Checkout", scaffoldKey),
          body: connectionStatus.toString()!="ConnectivityStatus.Offline"?RefreshIndicator(
            child: StreamBuilder<CheckoutListing>(
                stream: checkoutBloc.fetchCheckoutItemList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data != null && snapshot.data.new_model != null) {
                        shippingAddress=snapshot.data.shippingAddresss!=null? true:false;
                        mobileNo=snapshot.data.shippingAddresss!=null?snapshot.data.shippingAddresss.mobileNo:"";
                        billingAddress=snapshot.data.billingAddress!=null? true:false;
                         order_payable=snapshot.data.total_amount_payable;
                      return SingleChildScrollView(
                          child: Column(children: <Widget>[
                            Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ORDER TOTAL : ${CountryInfo.currencySymbol} ${snapshot.data.total_amount_payable}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17,
                                        fontFamily: "Helvetica-Condensed",
                                        color: Colors.black),
                                  ),
                                )),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return ShippingAddress();})).then((value){
                                    if(value==true){
                                      print("VALUE: $value");
                                      setState(() {
                                        shippingAddress=true;
                                        mobileNo=snapshot.data.shippingAddresss!=null?snapshot.data.shippingAddresss.mobileNo:"";

                                      });
                                    }
                                    refreshData();
                                  });

                                },
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(left:20,right: 15,top: 7,bottom: 5),
                                        height: 35,
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: new Text('SHIPPING ADDRESS',style:TextStyle(fontSize:15,fontFamily:"Helvetica" ,color:Colors.black)),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child:  new Icon(Icons.arrow_forward_ios,size: 15,color: Colors.black,),
                                            )
                                          ],
                                        )),
                                    snapshot.data.shippingAddresss!=null?InkWell(
                                      child: Padding(
                                          padding: EdgeInsets.only(left:20,right: 15,top:5,bottom: 5),
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${ snapshot.data.shippingAddresss.addressOne + ", " +snapshot.data.shippingAddresss.cityName + ", " +snapshot.data.shippingAddresss.postalCode+ ", " + snapshot.data.shippingAddresss.stateName + ", " +snapshot.data.shippingAddresss.countryName   }",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13,
                                                  fontFamily: "Helvetica",
                                                  color: Colors.black),
                                            ),
                                          )),
                                    ):Center(),
                                  ],
                                )
                            ),

                            Padding(
                              padding: EdgeInsets.only(left:20,right:15,bottom: 5,top: 2),
                              child: Divider(color: Colors.grey[400],),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return BillingAddress();})).then((value){
                                    if(value==true){
                                      setState(() {
                                        billingAddress=true;
                                      });

                                    }
                                    refreshData();
                                  });

                                },
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(left:20,right: 15,top: 2,bottom: 5),
                                        height: 30,
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: new Text('BILLING ADDRESS',style:TextStyle(fontSize:15,fontFamily:"Helvetica" ,color:Colors.black)),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child:  new Icon(Icons.arrow_forward_ios,size: 15,color: Colors.black,),
                                            )

                                          ],
                                        )),
                                    snapshot.data.billingAddress!=null?InkWell(
                                      child: Padding(
                                          padding: EdgeInsets.only(left:20,right: 15,top:5,bottom: 5),
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${snapshot.data.billingAddress.addressOne + ", " +snapshot.data.billingAddress.cityName + ", " +snapshot.data.billingAddress.postalCode+ ", " + snapshot.data.billingAddress.stateName + ", " +snapshot.data.billingAddress.countryName   }",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13,
                                                  fontFamily: "Helvetica",
                                                  color: Colors.black),
                                            ),
                                          )),
                                    ):Center(),
                                  ],
                                )
                            ),

                            Padding(
                              padding: EdgeInsets.only(left:20,right:15,bottom: 5,top: 5),
                              child: Divider(color: Colors.grey[400],),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left:15,right: 15,top:10,bottom: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "ITEMS",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: "Helvetica",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            ShoppingCart("CheckOut", snapshot.data.new_model),
                            widget.gift_instruction!=""?Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left:20,right: 15,top:10,bottom: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "GIFT INSTRUCTIONS",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "Helvetica",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.5,
                                          color: Colors.black),
                                    ),
                                  )),
                                  Padding(
                                  padding: EdgeInsets.only(left:20,right: 15,top:10,bottom: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${widget.gift_instruction}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "Helvetica",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ):Center(),
                            widget.order_instruction!=""?Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left:20,right: 15,top:10,bottom: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "SPECIAL INSTRUCTIONS ADDED",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "Helvetica",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.5,
                                          color: Colors.black),
                                    ),
                                  )),
                                  Padding(
                                  padding: EdgeInsets.only(left:20,right: 15,top:10,bottom: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${widget.order_instruction}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: "Helvetica",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ):Center(),

                            widget.order_instruction!="" || widget.gift_instruction!=""?Padding(
                              padding: EdgeInsets.only(bottom: 5, top: 10),
                              child: Divider(
                                color: Colors.grey[400],
                              ),
                            ):Center(),
                            totalPrice(
                                context,
                                snapshot.data.priceBreakdown,
                                snapshot.data.total_amount_payable,
                                snapshot.data.total_discount),

                            Padding(
                              padding: EdgeInsets.only(bottom: 5, top: 10),
                              child: Divider(
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Checkbox(
                                      activeColor: Colors.black,
                                      checkColor: Colors.white,
                                      value: _termscondition,
                                      onChanged: (bool val) {
                                        setState(() {
                                          _termscondition = val;
                                        });
                                      }),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "I agree to the terms and conditions",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          fontFamily: "Helvetica",
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Center(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20, bottom: Platform.isIOS?25:10, left: 20, right: 20),
                                      child: Container(
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(

                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(25.0),
                                          ),
                                        ),
                                        child: FlatButton(
                                          onPressed: () async{
                                            if(_termscondition!=false && snapshot.data.billingAddress!=null && snapshot.data.shippingAddresss!=null){
                                              print("Mobile: $mobileNo");
                                              WebEngagePlugin.trackScreen("Checkout Page => Billing Address:${snapshot.data.total_amount_payable}, Shipping Addres: ${snapshot.data.shippingAddresss} , Terms&Condition: ${_termscondition}");
                                              Navigator.push(context, new MaterialPageRoute(builder: (context) => new PaymentPage(order_payable,mobileNo)));
                                            }
                                            else{
                                              if(_termscondition==false){
                                                print("Billing Address: ${snapshot.data.billingAddress}");
                                                ToastMsg().getFailureMsg(context, "Please accept the terms and conditions to proceed.");
                                              }
                                              else if(shippingAddress==false ){
                                                ToastMsg().getFailureMsg(context, "Please add shipping address!");

                                              }
                                              else if(billingAddress==false ){
                                                ToastMsg().getFailureMsg(context, "Please add billing address!");

                                              }
                                              else if(shippingAddress==false  && billingAddress==false){
                                                ToastMsg().getFailureMsg(context, "Please add checkout address!");

                                              }

                                            }

                                          },
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.red[900],
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          child: Text(
                                            'PLACE ORDER',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Helvetica",
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          color: Colors.red[900],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),


                          ]));
                    } else {
                      return Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.2),
                              child: ErrorPage(
                                appBarTitle: "Hey, it feels so light!",
                              )),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.2,
                                  right: MediaQuery.of(context).size.width * 0.2),
                              child: RaisedButton(
                                color: Colors.grey[300],
                                onPressed: () => Navigator.of(context)
                                    .pushNamedAndRemoveUntil('/homePage',
                                        (Route<dynamic> route) => false),
                                child: Text("No ITEMS FOUND FOR PLACING ORDER"),
                              )),
                        ],
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            onRefresh: refreshData,
          ):ErrorPage(appBarTitle: "You are offline.",)),
    );

  }

  //Price Calculation
  Widget totalPrice(BuildContext context, PriceBreakdown priceBreakdown, String total_amount, String total_discount) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: priceBreakdown.price.length,
              itemBuilder: (BuildContext context, int index) => new Container(
                color: Colors.white,
                child: new Column(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${priceBreakdown.price[index].name}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                fontFamily: "Helvetica",
                                color: Colors.black87),
                          ),
                          Text(
                            "${CountryInfo.currencySymbol} ${priceBreakdown.price[index].amount}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: priceBreakdown.price[index].name ==
                                    "Bag Discount"
                                    ? Colors.green
                                    : Colors.black),
                          ),
                        ],
                      ))
                ]),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          child: Divider(
            thickness: 1,
            color: Colors.grey[300],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "ORDER TOTAL",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    fontFamily: "Helvetica",
                    color: Colors.black87),
              ),
              Text(
                "${CountryInfo.currencySymbol} $total_amount",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        total_discount != ""
            ? Container(
            height: 50,
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Savings",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        fontFamily: "Helvetica",
                        color: Colors.green),
                  ),
                  Text(
                    "${CountryInfo.currencySymbol} ${total_discount}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.green),
                  ),
                ],
              ),
            ))
            : Center(),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Text(
            "Sale and Secure Payments | Easy Returns | 100% Authentic Products",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 11,
                fontFamily: "Helvetica",
                color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(milliseconds: 1));
    setState(() {
      checkoutBloc.fetchAllCheckoutItems(widget.is_gift,widget.gift_instruction,widget.is_orderinstruction,widget.order_instruction);
    });
  }

}
