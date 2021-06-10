import 'package:azaFashions/bloc/PaymentBloc/PaymentBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/models/Payment/PaymentStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguesPatternDesign/patternOne.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/SHOPPINGCART/ShoppingBag.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ThankYou extends StatefulWidget {
  String url, transId;

  ThankYou(this.url, this.transId);

  @override
  _ThankYouState createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  int _rating = 0;
  double rating = 0.0;
  final connectivity = new ConnectivityService();
  var connectionStatus;

  void rate(int rating) {
    //Other actions based on rating such as api calls.
    setState(() {
      _rating = rating;
      print(_rating);
    });
  }

  @override
  void initState() {
    super.initState();

    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    connectionStatus.toString() != "ConnectivityStatus.Offline"
        ? paymentBloc.fetchPaymentStatusBloc(widget.url, widget.transId)
        : "";
    WebEngagePlugin.trackScreen("Thank You Screen: ${widget.url}, ${widget.transId}");
    analytics.setCurrentScreen(screenName: "Thank You Screen/${widget.transId}");

  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS
        ? connectivity.checkConnectivity1()
        : Provider.of<ConnectivityStatus>(context);

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/homePage', (Route<dynamic> route) => false);
        return Future.value(true);
      },
      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarWidget().myAppBar(context, "Order Placed", scaffoldKey),
            body: connectionStatus.toString() != "ConnectivityStatus.Offline"
                ? StreamBuilder(
              stream: paymentBloc.fetchPaymentStatus,
              builder: (context, AsyncSnapshot<PaymentStatus> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.code == 0
                      ? Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                _itemDesignModule(
                                    context,
                                    snapshot.data.bannerImage,
                                    snapshot.data.heading,
                                    snapshot.data.sub_heading)
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(top: 10, left: 20),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            child: Align(
                                              alignment: Alignment
                                                  .centerLeft,
                                              child: Text("Name :" +
                                                snapshot.data.customer_name!=""?snapshot.data.customer_name:snapshot
                                                    .data
                                                    .shippingAddress
                                                    .firstName +
                                                    " " +
                                                    snapshot
                                                        .data
                                                        .shippingAddress
                                                        .lastName,
                                                textAlign:
                                                TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight
                                                        .normal,
                                                    fontFamily:
                                                    "Helvetica",
                                                    color:
                                                    Colors.black),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                  snapshot.data.customer_email!=""?Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            child: Align(
                                              alignment: Alignment
                                                  .centerLeft,
                                              child: Text("Email Address :" +
                                                snapshot.data.customer_email,
                                                textAlign:
                                                TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight
                                                        .normal,
                                                    fontFamily:
                                                    "Helvetica",
                                                    color:
                                                    Colors.black),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ):Center(),
                                  Padding(
                                    padding:
                                    EdgeInsets.only(bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.data.shippingAddress.addressOne +
                                            ", " +
                                            snapshot
                                                .data
                                                .shippingAddress
                                                .cityName +
                                            snapshot
                                                .data
                                                .shippingAddress
                                                .postalCode +
                                            ", " +
                                            snapshot
                                                .data
                                                .shippingAddress
                                                .stateName +
                                            " , " +
                                            snapshot
                                                .data
                                                .shippingAddress
                                                .countryName,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.normal,
                                            fontFamily: "Helvetica",
                                            color:
                                            HexColor("#666666")),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5, bottom: 10),
                                        child: Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child: Text(
                                            "Mobile :",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.normal,
                                                fontFamily:
                                                "Helvetica",
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5, bottom: 10),
                                        child: Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child: Text(
                                            snapshot
                                                .data
                                                .shippingAddress
                                                .mobileNo,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.normal,
                                                fontFamily:
                                                "Helvetica",
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Divider(
                                color: Colors.grey,
                                endIndent: 20,
                                indent: 20,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                    bottom: 25),
                                child: Container(
                                    color: HexColor("#e0e0e0"),
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        1,
                                    height: 45,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacement(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext
                                                context) {
                                                  return MainHome();
                                                }));
                                      },
                                      child: Text(
                                        'CONTINUE SHOPPING',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight:
                                            FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ))),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 10, left: 20, right: 20),
                              color: Colors.grey[200],
                              height: 160,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0),
                                    child: Text(
                                      "Enjoying Aza Fashions?",
                                      style: TextStyle(
                                          fontFamily:
                                          "PlayfairDisplay",
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0),
                                    child: Text(
                                      "Share your experience & rate us on play store",
                                      style: TextStyle(
                                          fontFamily: "Helvetica",
                                          fontSize: 16,
                                          color: HexColor("#666666")),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 15,
                                                bottom: 15,
                                                right: 10),
                                            child: Align(
                                                alignment: Alignment
                                                    .centerLeft,
                                                child:
                                                SmoothStarRating(
                                                    allowHalfRating:
                                                    false,
                                                    onRated: (v) {

                                                      setState(
                                                              () {
                                                            rating =
                                                                v;

                                                              });
                                                    },
                                                    starCount: 5,
                                                    rating:
                                                    rating,
                                                    size: 30.0,
                                                    filledIconData: (rating >
                                                        0.0)
                                                        ? Icons
                                                        .star
                                                        : Icons
                                                        .star_border,
                                                    //halfFilledIconData: Icons.blur_on,
                                                    color: Colors
                                                        .black,
                                                    borderColor:
                                                    Colors.grey[
                                                    400],
                                                    spacing:
                                                    0.0))),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 15,
                                              right: 10),
                                          child: Container(
                                            color:
                                            HexColor("#e0e0e0"),
                                            width:
                                            MediaQuery.of(context)
                                                .size
                                                .width /
                                                2.8,
                                            height: 40,
                                            child: FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: HexColor(
                                                          "#e0e0e0"),
                                                      width: 1,
                                                      style:
                                                      BorderStyle
                                                          .solid),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          1.0))),
                                              child: Text(
                                                'RATE US NOW',
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily:
                                                    "Helvetica",
                                                    color:
                                                    Colors.black),
                                              ),
                                              color: Colors.black12,
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                    FocusNode());
                                                if (rating > 0.0) {
                                                  ToastMsg().getFailureMsg(
                                                      context,
                                                      "Thanks for rating us");
                                                  WebEngagePlugin.trackEvent("Rate Aza Shopping: ${rating}");


                                                  /*    order_bloc.fetchProductShareFeedback(orderId,itemId,rating,suggestions);
                                                      order_bloc.productFeedbackList.listen((event) {
                                                        if(event.success!=null){
                                                          print("PRODUCT FEEDBACK: ${event.success} ${event.error}");
                                                          ToastMsg().getLoginSuccess(context," ${event.success}");
                                                        }
                                                        else{
                                                          ToastMsg().getLoginSuccess(context," ${event.error}");
                                                        }

                                                      });

                                                      paymentBloc.orderPlacedFeedback(rating.toInt());
                                                      paymentBloc.recordOrderPlacedFeedback.listen((event) {
                                                        if(event.success!=null){
                                                          print("PRODUCT FEEDBACK: ${event.success} ${event.error}");
                                                          ToastMsg().getLoginSuccess(context, "${event.success}");
                                                        }
                                                        else{
                                                          ToastMsg().getLoginSuccess(context," ${event.error}");
                                                        }

                                                      });
*/
                                                } else {
                                                  ToastMsg()
                                                      .getFailureMsg(
                                                      context,
                                                      "Please rate the product.");
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            snapshot.data.completeTheLook.isNotEmpty
                                ? completeTheLook(context,
                                snapshot.data.completeTheLook)
                                : Center()
                          ],
                        ),
                      ),
                    ],
                  )
                      : Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                _itemDesignModule(
                                    context,
                                    snapshot.data.bannerImage,
                                    snapshot.data.heading,
                                    snapshot.data.sub_heading)
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 25,
                                    bottom: 25),
                                child: Container(
                                    color: HexColor("#e0e0e0"),
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        1,
                                    height: 45,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacement(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext
                                                context) {
                                                  return ShoppingBag();
                                                }));
                                      },
                                      child: Text(
                                        'CONTINUE SHOPPING',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight:
                                            FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ))),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            )
                : ErrorPage(
              appBarTitle: "You are offline.",
            )),
      ),
    );
  }

  Widget completeTheLook(context, List<ModelList> model) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              padding:
              EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Complete The Look',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 22,
                                    fontFamily: "PlayfairDisplay",
                                    color: Colors.black),
                              ),
                            ))),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ])),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            height: 350,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: model.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                      padding: EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 20),
                      width: 210,
                      height: 300,
                      child: PatternOne(
                        designertitle: model[index].designer_name,
                        designerImage: model[index].image,
                        you_pay: model[index].display_you_pay,
                        mrp: model[index].display_mrp,
                        sizeList: model[index].sizeList,
                        designDescription: model[index].name,
                        tag: "",
                        id: model[index].id,
                        wishlist: false,
                        discount: model[index].discount_percentage,
                      ));
                }),
          )
        ],
      ),
    );
  }

  Widget _itemDesignModule(BuildContext context, String image, String heading, String subHeading) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          child: Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: new CachedNetworkImageProvider("${image}")
                  //Can use CachedNetworkImage
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0))),
          ),
        ),
        Positioned(
          bottom: -22,
          left: 25,
          right: 25,
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: double.infinity,
                height: 120,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "${heading}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "PlayfairDisplay",
                            fontWeight: FontWeight.normal,
                            fontSize: 22,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "${subHeading}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
              )),
        )
      ],
    );
  }
}
