import 'dart:io';
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/bloc/CartBloc/CartBloc.dart';
import 'package:azaFashions/bloc/CheckoutBloc/CheckoutBloc.dart';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Orders/PriceBreakdown.dart';
import 'package:azaFashions/networkprovider/CheckoutProvider.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/CatalogueDetails/WishlistCatalogueList.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/SHOPPINGCART/CheckOut.dart';
import 'package:azaFashions/ui/SHOPPINGCART/ShoppingCart.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/SupportDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ShoppingBag extends StatefulWidget {
  @override
  ShoppingBagPage createState() => ShoppingBagPage();
}

class ShoppingBagPage extends State<ShoppingBag> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _value = true;
  TextEditingController giftController = new TextEditingController();
  TextEditingController orderController = new TextEditingController();
  TextEditingController _walletController = new  TextEditingController();
  TextEditingController _creditController = new  TextEditingController();
  TextEditingController _loyaltyController = new  TextEditingController();

  TextEditingController couponCodeController = new  TextEditingController();
  int redeemedAmount = 0;
  String couponCode = "";
  final connectivity = new ConnectivityService();
  var connectionStatus;

  bool applied = false;

  //REEDEEM POINTS
  bool _azaWallet = false;
  bool _azaLoyalty = false;




  @override
  void initState() {
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    cartBloc.fetchAllCartItems();

    super.initState();
    WebEngagePlugin.trackScreen("Shopping Cart Page");
    analytics.setCurrentScreen(screenName: "Shopping Bag");

  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }


  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      cartBloc.fetchAllCartItems();
      wishList.getWishList();
    });
  }

  @override
  Widget build(BuildContext context) {

    connectionStatus = Platform.isIOS
        ? connectivity.checkConnectivity1()
        : Provider.of<ConnectivityStatus>(context);

    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBarWidget().myAppBar(context, "Shopping Bag", scaffoldKey),
          body: connectionStatus.toString() != "ConnectivityStatus.Offline"
              ? RefreshIndicator(
            child: StreamBuilder<CartListing>(
                stream: cartBloc.fetchCartItemList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (CartListing.data_error == "" &&
                        snapshot.data != null &&
                        CartListing.new_model != null) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom:50.0),
                            child: SingleChildScrollView(
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
                                            fontSize: 16,
                                            fontFamily: "Helvetica-Condensed",
                                            color: Colors.black),
                                      ),
                                    )),

                                ShoppingCart("ShoppingBag", CartListing.new_model),
                                //COUPON CODE
                                couponDetails(context, CartListing.promoPrompt),

                                Padding(
                                  padding: const EdgeInsets.only(top:20),
                                  child: redeemPoints(context, snapshot.data.priceBreakdown),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(bottom: 5, top: 10),
                                  child: Divider(
                                    color: Colors.grey[400],
                                  ),
                                ),


                                totalPrice(
                                    context,
                                    snapshot.data.priceBreakdown,
                                    snapshot.data.total_amount_payable,
                                    snapshot.data.total_discount),

                                CartListing.promo_banner != ""
                                    ? Container(
                                  padding: EdgeInsets.only(
                                      left: 35,
                                      right: 35,
                                      top: 20,
                                      bottom: 5),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                  TargetPlatform.iOS != null ? 200 : 180,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: CachedNetworkImageProvider(
                                              CartListing.promo_banner)
                                        //Can use CachedNetworkImage
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(0))),
                                )
                                    : Center(),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5, top: 10),
                                  child: Divider(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                giftInstructions(context),

                                //CONTACT US
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Contact us if you have any problem while checking out",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Helvetica",
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                                color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.grey[300],
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    var whatsApp = await SupportDetails()
                                                        .getWhatsAppDetails();
                                                    // print(whatsApp);
                                                    await launch(whatsApp);
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: HexColor("#f5f5f5"),
                                                          border: Border.all(
                                                            color: Colors.grey[400],
                                                          )),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.only(top: 10),
                                                            child: Image.asset(
                                                              "images/whatsapp.png",
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: 10, bottom: 10),
                                                            child: Align(
                                                              alignment: Alignment.center,
                                                              child: Text(
                                                                "WHATSAPP",
                                                                textAlign:
                                                                TextAlign.center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    "Helvetica",
                                                                    fontWeight:
                                                                    FontWeight.normal,
                                                                    fontSize: 10,
                                                                    color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                )),
                                            Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    var mobile = await SupportDetails()
                                                        .getMobileSupport();
                                                    await launch("tel:$mobile");
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: HexColor("#f5f5f5"),
                                                        border: Border(
                                                          top: BorderSide(
                                                              width: 1.0,
                                                              color: Colors.grey[400]),
                                                          bottom: BorderSide(
                                                              width: 1.0,
                                                              color: Colors.grey[400]),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.only(top: 10),
                                                            child: Icon(
                                                              Icons.phone,
                                                              color: Colors.black,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: 10, bottom: 10),
                                                            child: Align(
                                                              alignment: Alignment.center,
                                                              child: Text(
                                                                "PHONE",
                                                                textAlign:
                                                                TextAlign.center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    "Helvetica",
                                                                    fontWeight:
                                                                    FontWeight.normal,
                                                                    fontSize: 10,
                                                                    color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                )),
                                            Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    var email = await SupportDetails()
                                                        .getEmailSupport();

                                                    await launch("mailto:${email}");
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: HexColor("#f5f5f5"),
                                                          border: Border.all(
                                                              color: Colors.grey[400])),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.only(top: 10),
                                                            child: Icon(
                                                              Icons.mail_outline,
                                                              color: Colors.black87,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: 10, bottom: 10),
                                                            child: Align(
                                                              alignment: Alignment.center,
                                                              child: Text(
                                                                "EMAIL",
                                                                textAlign:
                                                                TextAlign.center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    "Helvetica",
                                                                    fontWeight:
                                                                    FontWeight.normal,
                                                                    fontSize: 10,
                                                                    color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                WishlistCatalogueList(
                                    tag: "shoppingBag",
                                    patternName: "Complete From Your Wishlist"),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),


                              ])),
                          ),
                          Center(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        bottom: Platform.isIOS ? 25 : 10,
                                        left: 20,
                                        right: 20),
                                    child: Container(
                                      width: double.infinity,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(25.0),
                                        ),
                                      ),
                                      child: FlatButton(
                                        onPressed: () async {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          SharedPreferences prefs =
                                          await SharedPreferences
                                              .getInstance();
                                          if (prefs.getBool("browseAsGuest")) {
                                            setState(() {
                                              CustomBottomSheet()
                                                  .getShoppingBagBottomSheet(context);
                                            });
                                          } else {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                    new CheckOut(
                                                        _giftChecked,
                                                        giftController.text,
                                                        _instructionChecked,
                                                        orderController
                                                            .text)));
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.red[900],
                                                width: 1,
                                                style: BorderStyle.solid),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        child: Text(
                                          'PROCEED TO CHECKOUT',
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
                              )),],
                      );
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height *
                                    0.22,
                                bottom: 10),
                            child: ErrorPage(
                              appBarTitle: "Hey, it feels so light!",
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10, left: 40, right: 40, bottom: 10),
                            child: Container(
                              height: 43,
                                width: double.infinity,
                                child: RaisedButton(
                                  color: Colors.grey[300],
                                  onPressed: () => Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return MainHome();
                                      })),
                                  child: Text("SHOP NOW"),
                                )),
                          ),
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
          )
              : ErrorPage(
            appBarTitle: "You are offline.",
          )),
    );
  }


  //Redeem Points
  Widget redeemPoints(BuildContext context, PriceBreakdown priceBreakDown) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: CartListing.redeemItems.length,
        itemBuilder: (context, int index) {
          print("SELECTION: ${CartListing.redeemItems[index].isSelected}");

          return Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                      activeColor: Colors.black,
                      checkColor: Colors.white,
                      value: CartListing.redeemItems[index].isSelected,
                      onChanged: (bool val) {
                        setState(() {

                          CartListing.redeemItems[index].isSelected = val;
                          print(
                              "SELECTED INDEX : ${CartListing.redeemItems[index].isSelected}");
                          if (!CartListing.redeemItems[index].isSelected) {

                            CartListing.redeemItems[index].remainingBalance =
                                CartListing.redeemItems[index].balance;
                            CartListing.redeemItems[index].title.toString().toLowerCase().contains(CheckoutProvider.tag)?CheckoutProvider.error="":"";
                            print("Redeemed Wallet ${_walletController.text}");
                            print(
                                "Redeemed Loyalty ${_loyaltyController.text}");
                            print("Redeemed Credit ${_creditController.text}");
                            if (_walletController.text == "" ||
                                _loyaltyController.text == "" ||
                                _creditController.text == "") {}
                            if (_walletController.text != "" ||
                                _loyaltyController.text != "" ||
                                _creditController.text != "") {
                              cartBloc.redeemPoints(
                                  "remove",
                                  CartListing.redeemItems[index].title
                                      .toString()
                                      .toLowerCase()
                                      .contains("wallet")
                                      ? "wallet"
                                      : CartListing.redeemItems[index].title
                                      .toString()
                                      .toLowerCase()
                                      .contains("credit")
                                      ? "credit"
                                      : CartListing.redeemItems[index].title
                                      .toString()
                                      .toLowerCase()
                                      .contains("loyalty")
                                      ? "loyalty"
                                      : "",
                                  CartListing.redeemItems[index].title
                                      .toString()
                                      .toLowerCase()
                                      .contains("wallet")
                                      ? 0
                                      : CartListing.redeemItems[index].title
                                      .toString()
                                      .toLowerCase()
                                      .contains("credit")
                                      ? 0
                                      : CartListing.redeemItems[index].title
                                      .toString()
                                      .toLowerCase()
                                      .contains("loyalty")
                                      ? 0
                                      : 0);
                              UserTrackingDetails().redeemPointsApplied(
                                  CartListing.redeemItems[index].title,
                                  redeemedAmount.toString());

                              // _walletController.clear();
                              // _loyaltyController.clear();
                              // _creditController.clear();
                              CartListing.redeemItems[index].title
                                  .toString()
                                  .toLowerCase()
                                  .contains("wallet")
                                  ? _walletController.clear()
                                  : CartListing.redeemItems[index].title
                                  .toString()
                                  .toLowerCase()
                                  .contains("credit")
                                  ? _creditController.clear()
                                  : CartListing.redeemItems[index].title
                                  .toString()
                                  .toLowerCase()
                                  .contains("loyalty")
                                  ? _loyaltyController.clear()
                                  : "";
                            }
                          } else {
                            setState(() {});
                          }
                        });
                        print(
                          CartListing.redeemItems[index].isSelected,
                        );
                      }),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      CartListing.redeemItems[index].title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.5,
                          fontFamily: "Helvetica-Condensed",
                          color: Colors.black),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 50),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    CartListing.redeemItems[index].title ==
                        "REDEEM FROM LOYALTY"
                        ? "Points :${CartListing.redeemItems[index].remainingBalance}"
                        : "Balance :${CartListing.redeemItems[index].remainingBalance}  ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.5,
                        fontFamily: "Helvetics",
                        color: Colors.black),
                  ),
                ),
              ),
              CartListing.redeemItems[index].isSelected == true
                  ? Column(
                children: [
                  Padding(
                      padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10),
                      child: Container(
                          height: 45,
                          child: TextField(
                              controller: CartListing
                                  .redeemItems[index].title
                                  .toString()
                                  .toLowerCase()
                                  .contains("wallet")
                                  ? _walletController
                                  : CartListing.redeemItems[index].title
                                  .toString()
                                  .toLowerCase()
                                  .contains("credit")
                                  ? _creditController
                                  : CartListing
                                  .redeemItems[index].title
                                  .toString()
                                  .toLowerCase()
                                  .contains("loyalty")
                                  ? _loyaltyController
                                  : TextEditingController(),
                              // onSubmitted: (String bal) {
                              //   if (bal != "") {
                              //     if (int.parse(bal) <=
                              //         CartListing.redeemItems[index].balance &&
                              //         bal.length <=
                              //             CartListing.redeemItems[index].balance
                              //                 .toString()
                              //                 .length) {
                              //       setState(() {
                              //         CartListing.redeemItems[index].value = true;
                              //       });
                              //     } else {
                              //       setState(() {
                              //         CartListing.redeemItems[index].value = false;
                              //       });
                              //     }
                              //   } else {
                              //     setState(() {
                              //       cartBloc.redeemPoints("remove",
                              //           CartListing.redeemItems[index].title
                              //           .toString()
                              //           .toLowerCase()
                              //           .contains("wallet")?"wallet":CartListing.redeemItems[index].title
                              //           .toString()
                              //           .toLowerCase()
                              //           .contains("credit")?"credit":CartListing.redeemItems[index].title
                              //           .toString()
                              //           .toLowerCase()
                              //           .contains("loyalty")?"loyalty":"",
                              //           CartListing.redeemItems[index].title
                              //               .toString()
                              //               .toLowerCase()
                              //               .contains("wallet")?int.parse(_walletController.text):CartListing.redeemItems[index].title
                              //               .toString()
                              //               .toLowerCase()
                              //               .contains("credit")?int.parse(_creditController.text):CartListing.redeemItems[index].title
                              //               .toString()
                              //               .toLowerCase()
                              //               .contains("loyalty")?int.parse(_loyaltyController.text):0);
                              //       CartListing.redeemItems[index].isSelected = false;
                              //
                              //     });
                              //     UserTrackingDetails().redeemPointsRemoved(CartListing.redeemItems[index].title, redeemedAmount.toString());
                              //
                              //   }
                              // },
                              onChanged: (String bal) {
                                setState(() {

                                  CartListing.redeemItems[index].title.toString().toLowerCase().contains(CheckoutProvider.tag)?CheckoutProvider.error="":"";
                                  CartListing.redeemItems[index]
                                      .remainingBalance =
                                      CartListing
                                          .redeemItems[index].balance;
                                  print(CartListing
                                      .redeemItems[index].balance);
                                  print(bal == "");
                                  if (bal == "") {
                                    setState(() {
                                      CartListing.redeemItems[index]
                                          .value = false;
                                      cartBloc.redeemPoints(
                                          "remove",
                                          CartListing.redeemItems[index]
                                              .title
                                              .toString()
                                              .toLowerCase()
                                              .contains("wallet")
                                              ? "wallet"
                                              : CartListing
                                              .redeemItems[index]
                                              .title
                                              .toString()
                                              .toLowerCase()
                                              .contains("credit")
                                              ? "credit"
                                              : CartListing
                                              .redeemItems[
                                          index]
                                              .title
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                              "loyalty")
                                              ? "loyalty"
                                              : "",
                                          CartListing.redeemItems[index]
                                              .title
                                              .toString()
                                              .toLowerCase()
                                              .contains("wallet")
                                              ? 0
                                              : CartListing
                                              .redeemItems[index]
                                              .title
                                              .toString()
                                              .toLowerCase()
                                              .contains("credit")
                                              ? 0
                                              : CartListing
                                              .redeemItems[
                                          index]
                                              .title
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                              "loyalty")
                                              ? 0
                                              : 0);
                                      // CartListing.redeemItems[index]
                                      //     .isSelected = false;
                                    });
                                    UserTrackingDetails()
                                        .redeemPointsRemoved(
                                        CartListing
                                            .redeemItems[index].title,
                                        redeemedAmount.toString());
                                  } else {
                                    if (int.parse(bal) <=
                                        CartListing.redeemItems[index]
                                            .remainingBalance &&
                                        bal.length <=
                                            CartListing.redeemItems[index]
                                                .remainingBalance
                                                .toString()
                                                .length) {
                                      setState(() {
                                        CartListing.redeemItems[index]
                                            .value = true;
                                        redeemedAmount = int.parse(bal);
                                      });
                                    } else {
                                      setState(() {
                                        CartListing.redeemItems[index]
                                            .value = false;
                                      });
                                    }
                                  }
                                });
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(
                                    RegExp(r"[0-9]"))
                              ],
                              decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black12,
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black12,
                                        width: 1.0),
                                  ),
                                  hintText: 'Enter Amount',
                                  hintStyle: TextStyle(
                                      fontFamily: "PlayfairDisplay",
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Colors.black38),
                                  suffix: InkWell(
                                      onTap: CartListing
                                          .redeemItems[index].value
                                          ? () async {
                                        FocusScope.of(context)
                                            .requestFocus(
                                            FocusNode());

                                        if (CartListing
                                            .redeemItems[index]
                                            .remainingBalance >=
                                            redeemedAmount) {
                                          await cartBloc.redeemPoints(
                                              "add",
                                              //type:
                                              CartListing
                                                  .redeemItems[
                                              index]
                                                  .title
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                  "wallet")
                                                  ? "wallet"
                                                  : CartListing
                                                  .redeemItems[
                                              index]
                                                  .title
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                  "credit")
                                                  ? "credit"
                                                  : CartListing.redeemItems[index].title
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                  "loyalty")
                                                  ? "loyalty"
                                                  : "",
                                              CartListing
                                                  .redeemItems[
                                              index]
                                                  .title
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                  "wallet")
                                                  ? int.parse(
                                                  _walletController
                                                      .text)
                                                  : CartListing
                                                  .redeemItems[index]
                                                  .title
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains("credit")
                                                  ? int.parse(_creditController.text)
                                                  : CartListing.redeemItems[index].title.toString().toLowerCase().contains("loyalty")
                                                  ? int.parse(_loyaltyController.text)
                                                  : 0);

                                          setState(() {
                                            CartListing
                                                .redeemItems[index]
                                                .remainingBalance = CartListing
                                                .redeemItems[
                                            index]
                                                .remainingBalance -
                                                redeemedAmount;
                                            CartListing
                                                .redeemItems[index]
                                                .value = false;
                                          });

                                          // if (CheckoutProvider.error != "") {
                                          //   return showDialog(
                                          //       barrierDismissible: false,
                                          //       context: context,
                                          //       builder: (context) {
                                          //         return AlertDialog(
                                          //           title: Text(
                                          //               CartListing.redeemItems[index].title),
                                          //           content: Text(
                                          //               CheckoutProvider.error),
                                          //           actions: [
                                          //             FlatButton(
                                          //               child: Text(
                                          //                   "OK"),
                                          //               onPressed:
                                          //                   () {
                                          //                 Navigator.pop(
                                          //                     context);
                                          //               },
                                          //             )
                                          //           ],
                                          //         );
                                          //       });
                                          // }
                                          UserTrackingDetails()
                                              .redeemPointsApplied(
                                              CartListing
                                                  .redeemItems[
                                              index]
                                                  .title,
                                              redeemedAmount
                                                  .toString());
                                        } else {
                                          scaffoldKey.currentState
                                              .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Insufficient Balance"),
                                              ));
                                        }

                                        cartBloc.errorData
                                            .listen((event) {
                                          if (event.error == null) {
                                          } else {}
                                        });
                                      }
                                          : null,
                                      child: Text(
                                        "REDEEM",
                                        style: TextStyle(
                                            color: CartListing
                                                .redeemItems[index]
                                                .value
                                                ? Colors.black
                                                : Colors.grey),
                                      )))))),
                  CartListing.redeemItems[index].title.toString().toLowerCase().contains(CheckoutProvider.tag) ? Padding(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 10),
                    child: Text(
                      CheckoutProvider.error,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                      : Center()
                ],
              )
                  : Center(),
            ]),
          );
        });
  }


//Coupon
  Widget couponDetails(BuildContext context, PromoList promoPrompt) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 20, bottom: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 5),
                  child: Text(
                    "${promoPrompt.promo[0].text}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
                promoPrompt.promo.length > 1
                    ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: promoPrompt.promo.length - 1,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 10, bottom: 10, right: 10, top: 10),
                        child: Text(
                          "${promoPrompt.promo[index + 1].text}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: "Helvetica-Condensed",
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      );
                    })
                    : Padding(
                  padding: EdgeInsets.all(0),
                ),
              ],
            ),
          ),
        ),
        promoPrompt != null
            ? Container(
          child: StreamBuilder<CartListing>(
              stream: checkoutBloc.couponCode,
              builder: (context, snapshot) {
                return Padding(
                    padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10),
                    child: Container(
                        height: 45,
                        child: TextField(
                          // controller: TextEditingController(),
                            maxLength: 20,
                            onSubmitted: (String code) {},
                            onChanged: (String code) async {
                              setState(() {
                                applied = false;
                              });
                              // couponCode = code;
                            },
                            controller: couponCodeController,
                            readOnly: !applied ? false : true,
                            decoration: new InputDecoration(
                              suffix: InkWell(
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if(couponCodeController.text!=null && couponCodeController.text!=""){
                                    if (!applied) {
                                      String a = await cartBloc.coupon(
                                          couponCodeController.text, "apply");
                                      print("VALUE $a");
                                      if (a=="true") {
                                        setState(() {
                                          applied = true;
                                        });
                                        ToastMsg().getLoginSuccess(context,
                                            "Coupon Applied Successfully");
                                        UserTrackingDetails().promoCodeApplied(couponCodeController.text);
                                      } else {
                                        setState(() {
                                          applied = false;
                                        });
                                        couponCodeController.clear();
                                        ToastMsg().getFailureMsg(
                                            context, a);
                                        UserTrackingDetails().promoCodeRemoved(couponCodeController.text);
                                      }
                                    } else {
                                      cartBloc.coupon(couponCodeController.text, "remove");
                                      setState(() {
                                        applied = false;
                                        couponCodeController.clear();
                                      });
                                    }
                                  }
                                  else{
                                    ToastMsg().getFailureMsg(context, "Please enter your coupon.");
                                  }


                                  print("APPLIED $applied");
                                },
                                child: Text(
                                  !applied ? "APPLY" : "REMOVE",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              contentPadding: EdgeInsets.all(6),
                              counter: Offstage(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black12, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black12, width: 1.0),
                              ),
                              hintText: 'Add promo code',
                              hintStyle: TextStyle(
                                  fontFamily: "PlayfairDisplay",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black38),
                            ))));
              }),
        )
            : Center()
      ],
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
                    fontFamily: "Helvetica-Condensed",
                    color: Colors.black87),
              ),
              Text(
                "${CountryInfo.currencySymbol} $total_amount",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.bold,
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

  //ADDING  GIFT AND OTHER INSTRUCTIONS
  bool _giftChecked = false;
  bool _instructionChecked = false;

  Widget giftInstructions(BuildContext context) {
    return Column(children: <Widget>[
      CheckboxListTile(
          contentPadding: EdgeInsets.only(right: 50),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            "THIS ORDER CONTAINS A GIFT",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                fontFamily: "Helvetica",
                color: Colors.black),
          ),
          activeColor: Colors.black,
          checkColor: Colors.white,
          value: _giftChecked,
          onChanged: (bool val) {
            setState(() {
              _giftChecked = val;
              giftController.text = "";
            });
          }),
      _giftChecked == true
          ? Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: TextField(

              onSubmitted: (String data) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onChanged: (String data) {
                if (giftController.text == "") {
                  setState(() {
                    _giftChecked = false;
                  });
                }
              },
              controller: giftController,
             /* maxLines: 3,*/
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 1.0),
                ),
                hintText: 'Gift Message',
                hintStyle: TextStyle(
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.black38),
              )))
          : Center(),
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
        child: Divider(),
      ),
      CheckboxListTile(
          contentPadding: EdgeInsets.only(right: 0),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            "ADD SPECIAL INSTRUCTIONS",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                fontFamily: "Helvetica",
                color: Colors.black),
          ),
          activeColor: Colors.black,
          checkColor: Colors.white,
          value: _instructionChecked,
          onChanged: (bool val) {
            setState(() {
              _instructionChecked = val;
             orderController.text="";
            });
          }),
      _instructionChecked == true
          ? Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: TextField(
              onSubmitted: (String data) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onChanged: (String data) {
                if (orderController.text == "") {
                  setState(() {
                    _instructionChecked = false;
                  });
                }
              },
              controller: orderController,
              /*maxLines: 3,*/
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 1.0),
                ),
                hintText: 'Special Instructions',
                hintStyle: TextStyle(
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.black38),
              )))
          : Center(),
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
        child: Divider(),
      ),
    ]);
  }
}
