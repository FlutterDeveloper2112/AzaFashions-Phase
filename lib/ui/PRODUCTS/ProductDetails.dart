import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/bloc/ProductBloc/BoughtTogetherBloc.dart';
import 'package:azaFashions/bloc/ProductBloc/SimilarProductBloc.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/ui/BaseFiles/ChildDetailPage.dart';
import 'package:azaFashions/ui/PRODUCTS/RecentlyViewedCatalogueList.dart';
import 'package:azaFashions/ui/PRODUCTS/YouMayLikeList.dart';
import 'package:azaFashions/ui/SHOPPINGCART/ShoppingBag.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/bloc/CartBloc/CartBloc.dart';
import 'package:azaFashions/bloc/ProductBloc/ProductDetailBloc.dart';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Cart/CartModel.dart';
import 'package:azaFashions/models/ProductDetail/ProductItemDetail.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/PRODUCTS/BuyTogetherProd.dart';
import 'package:azaFashions/ui/PRODUCTS/EmiPage.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductImage.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/utils/SupportDetails.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class ProductDetail extends StatefulWidget {
  int id;
  String url;
  String image, productTag;

  ProductDetail({
    this.image,
    this.productTag,
    this.url,
    this.id,
  });

  //ProductDetail(this.sizeValue);
  ProductDetailPage createState() => ProductDetailPage();
}

class ProductDetailPage extends State<ProductDetail> {
  FirebaseAnalytics analytics = new FirebaseAnalytics();
  final productDetailsBloc = ProductDetailsBloc();
  CustomBottomSheet bottomSheet = CustomBottomSheet();
  String imageValue = "";
  bool validate = false;
  bool error = false;
  int counter = 0;
  bool expandedAbout = false, expandedDetails = false, expandedShipping = false;

  CartModel cartModel;
  List<CartItems> cartItems = new List<CartItems>();
  ProductItemDetail productDetails;
  final connectivity = new ConnectivityService();
  var connectionStatus;
  List<ChildModelList> youMayLikeItems;
  List<ChildModelList> boughtTogetherItems;
  ChildListingModel boughtTogetherModel;

  int count = 0;
  ScrollController _scrollController;
  double _scrollPosition, lastScrollPosition;

  @override
  void dispose() {
    print("DISPOSE CALLED");
    connectivity.dispose();
    productDetailsBloc.clearData();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    analytics.setCurrentScreen(screenName: "Product Detail/${widget.id}");
    _scrollController = ScrollController();
    //  _scrollController.addListener(_scrollListener);

    setState(() {
      ProductItemDetail.error = "";
      BuyTogetherProd.count=0;
    });



    connectionStatus.toString() != "ConnectivityStatus.Offline"
        ? getProductDetails()
        : "";


    WebEngagePlugin.trackScreen(
        "Product Detail Page: ${widget.id} , ${widget.url}");
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    getData();
  }

  getProductDetails() async {
    await firstAsync();
    await secondAsync();
    await thirdAsync();
  }

  Future firstAsync() async {
    await boughtTogetherBloc.fetchBoughtTogether(widget.id);
  }

  Future secondAsync() async {
    await similarBloc.fetchSimilarProducts(widget.id);
  }
  Future thirdAsync() async {
    await productDetailsBloc.getProductDetails(widget.id, widget.url);
  }


  getData() {
    boughtTogetherBloc.boughtTogether.listen((event) {
      boughtTogetherModel = new ChildListingModel();
      boughtTogetherModel = event;
      boughtTogetherItems = new List<ChildModelList>();
      boughtTogetherItems = event.new_model;
    });
    similarBloc.similarProduct.listen((event) {
      youMayLikeItems = new List<ChildModelList>();
      youMayLikeItems = event.new_model;
    });
  }

  @override
  void didUpdateWidget(covariant ProductDetail oldWidget) {
    print("WIDGET UPDATED ONE");
    _scrollPosition = 0.0;
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    print("WIDGET UPDATED TWO");
    _scrollPosition = 0.0;
    // _scrollController.jumpTo(_scrollPosition);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS
        ? connectivity.checkConnectivity1()
        : Provider.of<ConnectivityStatus>(context);

    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: connectionStatus.toString() != "ConnectivityStatus.Offline"
              ? SafeArea(
            top: true,
            child: StreamBuilder<ProductItemDetail>(
                stream: productDetailsBloc.productDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    productDetails = snapshot.data;
                    if(ProductItemDetail.error== "" && productDetails!=null){
                      if(productDetails.sizes.length==1){
                        bottomSheet.productSelectSize = true;
                      }
                    }
                    print("PRODUCT TAG: ${productDetails.tag}");
                    return Stack(
                      children: [
                        ProductItemDetail.error == "" &&
                            productDetails != null
                            ? SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: <Widget>[
                              Container(

                                padding: EdgeInsets.only(top: 0),
                                child: ProductImage(
                                  items: productDetails.mediaGallery,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              //LIKE AND SHARE CONTENT
                              productDetails.tag != null &&
                                  productDetails.tag != ""
                                  ? Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 10),
                                    child: Container(
                                      width: productDetails
                                          .tag.length >
                                          30
                                          ? 210
                                          : productDetails.tag
                                          .length >
                                          25
                                          ? 170
                                          : productDetails
                                          .tag
                                          .length >
                                          15
                                          ? 140
                                          : 100,
                                      padding: EdgeInsets.only(
                                          left: 5, top: 5),
                                      child: Container(
                                        padding:
                                        EdgeInsets.all(5),
                                        decoration:
                                        BoxDecoration(
                                            border:
                                            Border.all(
                                              color: Colors.grey,
                                              width: 1,
                                              //
                                            )),
                                        //             <--- BoxDecoration here
                                        child: Text(
                                          "${productDetails.tag} ",
                                          textAlign:
                                          TextAlign.left,
                                          style: TextStyle(
                                              color:
                                              Colors.black,
                                              fontFamily:
                                              "Helvetica",
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        EdgeInsets.all(10),
                                        child: InkWell(
                                            onTap: () {
                                              if (connectionStatus
                                                  .toString() !=
                                                  "ConnectivityStatus.Offline") {
                                                print(
                                                    "Pressed");
                                                print(snapshot
                                                    .data.url);
                                                String text =
                                                    'https://www.azafashions.com${snapshot.data.url}';
                                                String subject =
                                                    snapshot
                                                        .data
                                                        .url;
                                                final RenderBox
                                                box =
                                                context
                                                    .findRenderObject();
                                                Share.share(
                                                    text,
                                                    subject:
                                                    subject,
                                                    sharePositionOrigin:
                                                    box.localToGlobal(Offset.zero) &
                                                    box.size);
                                              } else {
                                                Scaffold.of(
                                                    context)
                                                    .showSnackBar(SnackBar(
                                                    content:
                                                    Text("No Internet Connection!")));
                                              }
                                            },
                                            child: Image.asset(
                                              "images/share.png",
                                              width: 20,
                                              height: 20,
                                              color:
                                              Colors.black,
                                            )),
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(
                                            left: 5,
                                            right: 5),
                                        child: GestureDetector(
                                            onTap: () async {
                                              if (connectionStatus
                                                  .toString() !=
                                                  "ConnectivityStatus.Offline") {
                                                var whatsApp =
                                                await SupportDetails()
                                                    .getWhatsAppDetails();
                                                await launch(
                                                    whatsApp);
                                              } else {
                                                Scaffold.of(
                                                    context)
                                                    .showSnackBar(SnackBar(
                                                    content:
                                                    Text("No Internet Connection!")));
                                              }
                                            },
                                            child: Image.asset(
                                              "images/whatsapp.png",
                                              width: 25,
                                              height: 25,
                                            )),
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(
                                            left: 5,
                                            right: 5),
                                        child: InkWell(
                                            onTap: () async {
                                              if (connectionStatus
                                                  .toString() !=
                                                  "ConnectivityStatus.Offline") {
                                                setState(() {
                                                  if (productDetails
                                                      .inWishList ==
                                                      false) {
                                                    wishList.addWishListData(
                                                        context,
                                                        widget
                                                            .id);
                                                    wishList
                                                        .addWishList
                                                        .listen(
                                                            (event) {
                                                          if (event
                                                              .success !=
                                                              "Product Doesn't Exists or is Inactive") {
                                                            setState(
                                                                    () {
                                                                  productDetails.inWishList =
                                                                  true;
                                                                });
                                                          }
                                                          UserTrackingDetails().addToWishlist(
                                                              productDetails
                                                                  .designerName,
                                                              widget
                                                                  .image,
                                                              widget
                                                                  .id
                                                                  .toString(),
                                                              productDetails
                                                                  .display_you_pay,
                                                              widget
                                                                  .url);
                                                        });
                                                  } else {
                                                    wishList.removeWishListData(
                                                        context,
                                                        widget
                                                            .id,
                                                        "");
                                                    wishList
                                                        .removeWishList
                                                        .listen(
                                                            (event) {
                                                          if (event
                                                              .success
                                                              .isNotEmpty) {
                                                            setState(
                                                                    () {
                                                                  productDetails.inWishList =
                                                                  false;
                                                                });
                                                          }
                                                          UserTrackingDetails().removedFromWishlist(
                                                              productDetails
                                                                  .designerName,
                                                              widget
                                                                  .image,
                                                              widget
                                                                  .id
                                                                  .toString(),
                                                              productDetails
                                                                  .display_you_pay,
                                                              widget
                                                                  .url);
                                                        });
                                                  }
                                                });
                                              } else {
                                                Scaffold.of(
                                                    context)
                                                    .showSnackBar(SnackBar(
                                                    content:
                                                    Text("No Internet Connection!")));
                                              }
                                            },
                                            child: (productDetails
                                                .inWishList ==
                                                false)
                                                ? Icon(
                                              Icons
                                                  .favorite_border,
                                              size: 25,
                                              color: Colors
                                                  .black87,
                                            )
                                                : Icon(
                                              Icons
                                                  .favorite,
                                              size: 25,
                                              color: Colors
                                                  .redAccent,
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              )
                                  : Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                          bottom: 5),
                                      child: Align(
                                        alignment: Alignment
                                            .centerLeft,
                                        child: Text(
                                          productDetails
                                              .designerName,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          textAlign:
                                          TextAlign.left,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight
                                                  .normal,
                                              fontSize: 21,
                                              fontFamily:
                                              "PlayfairDisplay",
                                              color:
                                              Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 110,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                          EdgeInsets.all(
                                              10),
                                          child: InkWell(
                                              onTap: () {
                                                if (connectionStatus
                                                    .toString() !=
                                                    "ConnectivityStatus.Offline") {
                                                  print(
                                                      "Pressed");
                                                  print(snapshot
                                                      .data
                                                      .url);
                                                  String text =
                                                      'https://www.azafashions.com${snapshot.data.url}';
                                                  String
                                                  subject =
                                                      snapshot
                                                          .data
                                                          .url;
                                                  final RenderBox
                                                  box =
                                                  context
                                                      .findRenderObject();
                                                  Share.share(
                                                      text,
                                                      subject:
                                                      subject,
                                                      sharePositionOrigin:
                                                      box.localToGlobal(Offset.zero) &
                                                      box.size);
                                                } else {
                                                  Scaffold.of(
                                                      context)
                                                      .showSnackBar(SnackBar(
                                                      content:
                                                      Text("No Internet Connection!")));
                                                }
                                              },
                                              child:
                                              Image.asset(
                                                "images/share.png",
                                                width: 20,
                                                height: 20,
                                                color: Colors
                                                    .black,
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsets.only(
                                              left: 5,
                                              right: 5),
                                          child:
                                          GestureDetector(
                                              onTap:
                                                  () async {
                                                if (connectionStatus
                                                    .toString() !=
                                                    "ConnectivityStatus.Offline") {
                                                  var whatsApp =
                                                  await SupportDetails()
                                                      .getWhatsAppDetails();
                                                  await launch(
                                                      whatsApp);
                                                } else {
                                                  Scaffold.of(
                                                      context)
                                                      .showSnackBar(
                                                      SnackBar(content: Text("No Internet Connection!")));
                                                }
                                              },
                                              child: Image
                                                  .asset(
                                                "images/whatsapp.png",
                                                width: 25,
                                                height: 25,
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsets.only(
                                              left: 5,
                                              right: 5),
                                          child: InkWell(
                                              onTap: () async {
                                                if (connectionStatus
                                                    .toString() !=
                                                    "ConnectivityStatus.Offline") {
                                                  setState(() {
                                                    if (productDetails
                                                        .inWishList ==
                                                        false) {
                                                      wishList.addWishListData(
                                                          context,
                                                          widget
                                                              .id);
                                                      wishList
                                                          .addWishList
                                                          .listen(
                                                              (event) {
                                                            if (event.success !=
                                                                "Product Doesn't Exists or is Inactive") {
                                                              setState(
                                                                      () {
                                                                    productDetails.inWishList =
                                                                    true;
                                                                  });
                                                            }
                                                            UserTrackingDetails().addToWishlist(
                                                                productDetails.designerName,
                                                                widget.image,
                                                                widget.id.toString(),
                                                                productDetails.display_you_pay,
                                                                widget.url);
                                                          });
                                                    } else {
                                                      wishList.removeWishListData(
                                                          context,
                                                          widget
                                                              .id,
                                                          "");
                                                      wishList
                                                          .removeWishList
                                                          .listen(
                                                              (event) {
                                                            if (event
                                                                .success
                                                                .isNotEmpty) {
                                                              setState(
                                                                      () {
                                                                    productDetails.inWishList =
                                                                    false;
                                                                  });
                                                            }
                                                            UserTrackingDetails().removedFromWishlist(
                                                                productDetails.designerName,
                                                                widget.image,
                                                                widget.id.toString(),
                                                                productDetails.display_you_pay,
                                                                widget.url);
                                                          });
                                                    }
                                                  });
                                                } else {
                                                  Scaffold.of(
                                                      context)
                                                      .showSnackBar(SnackBar(
                                                      content:
                                                      Text("No Internet Connection!")));
                                                }
                                              },
                                              child: (productDetails
                                                  .inWishList ==
                                                  false)
                                                  ? Icon(
                                                Icons
                                                    .favorite_border,
                                                size: 25,
                                                color: Colors
                                                    .black87,
                                              )
                                                  : Icon(
                                                Icons
                                                    .favorite,
                                                size: 25,
                                                color: Colors
                                                    .redAccent,
                                              )),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              //DESIGNER NAME AND DESCRIPTION
                              productDetails.tag != null &&
                                  productDetails.tag != ""
                                  ? Padding(
                                padding: EdgeInsets.only(
                                    left: 15,
                                    top: 5,
                                    bottom: 5),
                                child: Align(
                                  alignment:
                                  Alignment.centerLeft,
                                  child: Text(
                                    productDetails.designerName,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.normal,
                                        fontSize: 21,
                                        fontFamily:
                                        "PlayfairDisplay",
                                        color: Colors.black),
                                  ),
                                ),
                              )
                                  : Center(),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 15, top:3),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    productDetails.name,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        fontWeight:
                                        FontWeight.normal,
                                        fontSize: 13,
                                        color:
                                        HexColor("#666666")),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              //PRICE CONTENT
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, top: 5, bottom: 5),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[
                                        productDetails
                                            .sizes[bottomSheet
                                            .sizeIndex]
                                            .discountPercentage !=
                                            "0"
                                            ? Padding(
                                          padding:
                                          EdgeInsets.all(2),
                                          child: Align(
                                            alignment: Alignment
                                                .centerLeft,
                                            child: Text(
                                              "${CountryInfo.currencySymbol} ${productDetails.sizes[bottomSheet.sizeIndex].display_you_pay} ",
                                              textAlign:
                                              TextAlign
                                                  .left,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .normal,
                                                  fontSize: 18,
                                                  fontFamily:
                                                  "Helvetica",
                                                  color: Colors
                                                      .black),
                                            ),
                                          ),
                                        )
                                            : Center(),
                                        Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Align(
                                            alignment:
                                            Alignment.centerLeft,
                                            child: Text(
                                              "${CountryInfo.currencySymbol} ${productDetails.sizes[bottomSheet.sizeIndex].display_mrp} ",
                                              textAlign:
                                              TextAlign.left,
                                              style: TextStyle(
                                                  decoration: productDetails
                                                      .sizes[bottomSheet
                                                      .sizeIndex]
                                                      .discountPercentage !=
                                                      "0"
                                                      ? TextDecoration
                                                      .lineThrough
                                                      : null,
                                                  fontWeight: productDetails
                                                      .sizes[bottomSheet
                                                      .sizeIndex]
                                                      .discountPercentage !=
                                                      "0"
                                                      ? FontWeight
                                                      .normal
                                                      : FontWeight
                                                      .normal,
                                                  fontSize: 17,
                                                  fontFamily:
                                                  "Helvetica",
                                                  color:
                                                  Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Align(
                                            alignment:
                                            Alignment.centerLeft,
                                            child: Text(
                                              productDetails
                                                  .sizes[bottomSheet
                                                  .sizeIndex]
                                                  .discountPercentage !=
                                                  "0"
                                                  ? "(${productDetails.sizes[bottomSheet.sizeIndex].discountPercentage}% Off)"
                                                  : "",
                                              textAlign:
                                              TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: productDetails
                                                      .sizes[bottomSheet
                                                      .sizeIndex]
                                                      .discountPercentage !=
                                                      "0"
                                                      ? FontWeight
                                                      .normal
                                                      : FontWeight
                                                      .bold,
                                                  fontSize: 14,
                                                  fontFamily:
                                                  "Helvetica",
                                                  color: Colors
                                                      .red[900]),
                                            ),
                                          ),
                                        ),
                                      ])),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, bottom: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "MRP ${CountryInfo.currencySymbol} ${productDetails.sizes[bottomSheet.sizeIndex].display_mrp} incl. of all taxes in India",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight:
                                            FontWeight.normal,
                                            fontSize: 13,
                                            color:
                                            HexColor("#666666")),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, bottom: 5),
                                    child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext
                                              context) =>
                                                  Container(
                                                      height: 50,
                                                      child: _buildMrpDialog(
                                                          context,
                                                          productDetails
                                                              .youPay,
                                                          productDetails
                                                              .payableTax)));
                                        },
                                        child: Icon(
                                          Icons.info_outline,
                                          size: 20,
                                        )),
                                  ),
                                ],
                              ),

                              //LOYALTY POINTS
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, top: 0, bottom: 3),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "EARN:",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight:
                                            FontWeight.normal,
                                            fontSize: 14,
                                            color:
                                            HexColor("#666666")),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 0, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${productDetails.loyaltyPoints}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight:
                                            FontWeight.normal,
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 0, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Loyalty Points ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight:
                                            FontWeight.normal,
                                            fontSize: 14,
                                            color:
                                            HexColor("#666666")),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 0, bottom: 5),
                                    child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext
                                              context) =>
                                                  _buildAboutDialog(
                                                      context,
                                                      productDetails
                                                          .loyalty_point_info));
                                        },
                                        child: Icon(
                                          Icons.info_outline,
                                          size: 20,
                                        )),
                                  ),
                                ],
                              ),

                              //SELECTION OF SIZE AND COLOR
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(left: 20),
                                        child: Container(
                                          width: productDetails.sizes[bottomSheet.sizeIndex].name == "CUSTOMISE" ||
                                              productDetails.sizes[bottomSheet.sizeIndex].name == "FREE SIZE"
                                              ? MediaQuery.of(context).size.width / 2.5
                                              : productDetails.sizes[bottomSheet.sizeIndex].name.contains("-") && productDetails.sizes.length==0
                                              ? MediaQuery.of(context).size.width / 3.2
                                              : !bottomSheet.productSelectSize
                                              ? MediaQuery.of(context).size.width / 2.5
                                              :productDetails.sizes[bottomSheet.sizeIndex].name.contains("-")?MediaQuery.of(context).size.width / 3.2: MediaQuery.of(context).size.width / 3.5,
                                          child: Align(
                                            alignment:
                                            Alignment.centerLeft,
                                            child: FlatButton(
                                              onPressed: () async {
                                                print(productDetails
                                                    .sizes.length);
                                                if (productDetails
                                                    .sizes
                                                    .length >
                                                    1) {
                                                  await bottomSheet.chooseProductSizeBottomSheet(
                                                      context,
                                                      productDetails
                                                          .sizes,
                                                      productDetails
                                                          .id);
                                                  setState(() {
                                                    count = bottomSheet
                                                        .sizeIndex;
                                                  });
                                                }
                                              },
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors
                                                          .black,
                                                      width: 1,
                                                      style:
                                                      BorderStyle
                                                          .solid),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          1.0))),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Text(
                                                      bottomSheet
                                                          .productSelectSize
                                                          ? 'Size : ${productDetails.sizes[bottomSheet.sizeIndex].name}'
                                                          : "Please Select Size",
                                                      textAlign:
                                                      TextAlign
                                                          .left,
                                                      style: TextStyle(
                                                          fontSize:
                                                          productDetails.sizes[bottomSheet.sizeIndex].name ==
                                                              "CUSTOMISE"
                                                              ? 10
                                                              : 12,
                                                          fontFamily:
                                                          "Helvetica",
                                                          color: Colors
                                                              .black),
                                                    ),
                                                  ),
                                                  if (productDetails
                                                      .sizes
                                                      .length >
                                                      1)
                                                    Align(
                                                        alignment:
                                                        Alignment
                                                            .centerRight,
                                                        child: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: Colors
                                                              .black87,
                                                          size: 15,
                                                        ))
                                                ],
                                              ),
                                              color:
                                              Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),

                              //SIZEGUIDE
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, top: 15),
                                    child: InkWell(
                                        child: Image.asset(
                                          "images/hanger.png",
                                          color: Colors.black87,
                                          width: 15,
                                          height: 15,
                                        )),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print(productDetails.sizeGuide);
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (__) =>
                                              new WebViewContainer(
                                                  productDetails
                                                      .sizeGuide,
                                                  "Size guide",
                                                  "SIZE GUIDE")));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          top: 20,
                                          bottom: 5),
                                      child: Align(
                                        alignment:
                                        Alignment.centerLeft,
                                        child: Text(
                                          "SIZE GUIDE",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily: "Helvetica",
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 15,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              //DELIVERY DATE

                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20, top: 10, bottom: 7),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Product will be shipped by ${productDetails.sizes[bottomSheet.sizeIndex].estimatedDelivery}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        fontFamily: "Helvetica",
                                        color: HexColor("#666666")),
                                  ),
                                ),
                              ),
                              productDetails
                                  .sizes[
                              bottomSheet.sizeIndex]
                                  .fastDelivery !=
                                  ""
                                  ? Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20),
                                    child: Align(
                                      alignment:
                                      Alignment.centerLeft,
                                      child: Text(
                                        "Need faster delivery styles? ",
                                        textAlign:
                                        TextAlign.left,
                                        style: TextStyle(
                                            fontFamily:
                                            "Helvetica",
                                            fontWeight:
                                            FontWeight
                                                .normal,
                                            fontSize: 14,
                                            color: HexColor(
                                                "#666666")),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5),
                                    child: Align(
                                        alignment: Alignment
                                            .centerLeft,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ChildDetailPage(
                                                        "Faster Delivery Styles",
                                                        productDetails
                                                            .sizes[bottomSheet.sizeIndex]
                                                            .fastDelivery)));
                                          },
                                          child: Text(
                                            "CLICK HERE",
                                            textAlign:
                                            TextAlign.left,
                                            style: TextStyle(
                                                fontFamily:
                                                "Helvetica",
                                                fontWeight:
                                                FontWeight
                                                    .normal,
                                                fontSize: 15,
                                                color: Colors
                                                    .black),
                                          ),
                                        )),
                                  ),
                                ],
                              )
                                  : Center(),
                              Divider(
                                thickness: 3,
                                color: HexColor("#59b2b2b2"),
                              ),
                              productDetails.emiEnable
                                  ? Center(
                                  child: Align(
                                    alignment:
                                    Alignment.bottomCenter,
                                    child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 15,
                                            left: 20,
                                            right: 20,
                                            bottom: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 43,
                                          decoration: BoxDecoration(
                                            color:
                                            HexColor("#e0e0e0"),
                                            borderRadius:
                                            const BorderRadius
                                                .all(
                                              Radius.circular(25.0),
                                            ),
                                          ),
                                          child: FlatButton(
                                            shape:
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors
                                                      .grey[400],
                                                  width: 1,
                                                  style: BorderStyle
                                                      .solid),
                                              // borderRadius: BorderRadius.all(Radius.circular(10.0))
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          EmiPage(
                                                            youPay:
                                                            productDetails.youPay,
                                                            display_youpay:
                                                            productDetails.display_you_pay,
                                                          )));
                                            },
                                            child: Text(
                                              'EASY INSTALLMENTS AVAILABLE',
                                              textAlign:
                                              TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily:
                                                  "Helvetica",
                                                  color:
                                                  Colors.black,
                                                  fontSize: 15),
                                            ),
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                                  : Center(),

                              productDetail(
                                  context,
                                  productDetails.styleNote,
                                  productDetails.additionInformation,
                                  productDetails
                                      .sizes[bottomSheet.sizeIndex]
                                      .estimated_delivery_weeks),
                              //DETAILS OF THE PRODUCT

                              //OFFER BANNER
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                      bottom: 15),
                                  child: Container(
                                      color: Colors.grey[300],
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      height: 130,
                                      child: Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              new BorderRadius
                                                  .circular(2.0),
                                              border: new Border.all(
                                                  color: Colors
                                                      .grey[300])),
                                          child: Column(children: <
                                              Widget>[
                                            Expanded(
                                                child: Container(
                                                  color: Colors.white,
                                                  width: double.infinity,
                                                  child: Align(
                                                      alignment: Alignment
                                                          .center,
                                                      child: Text(
                                                          productDetails
                                                              .promoPrompt
                                                              .header,
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              fontSize:
                                                              14,
                                                              fontFamily:
                                                              "PlayfairDisplay",
                                                              color: Colors
                                                                  .black))),
                                                )),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(
                                                  bottom: 10),
                                              child: Container(
                                                height: 40,
                                                decoration:
                                                BoxDecoration(
                                                  color: HexColor(
                                                      "#ad2810"),
                                                ),
                                                child: FlatButton(
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        new ClipboardData(
                                                            text: productDetails
                                                                .promoPrompt
                                                                .code));
                                                    ToastMsg()
                                                        .getLoginSuccess(
                                                        context,
                                                        "Code Copied to Clipboard");
                                                  },
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors
                                                            .red[900],
                                                        width: 1,
                                                        style:
                                                        BorderStyle
                                                            .solid),
                                                    // borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                  ),
                                                  child: Text(
                                                    productDetails
                                                        .promoPrompt
                                                        .message,
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                        "Helvetica",
                                                        color: Colors
                                                            .white,
                                                        fontSize: 15),
                                                  ),
                                                  color: Colors
                                                      .transparent,
                                                ),
                                              ),
                                            ),
                                          ])))),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                      bottom: 10),
                                  child: Container(
                                      color: Colors.grey[300],
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      height: 130,
                                      child: Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              new BorderRadius
                                                  .circular(2.0),
                                              border: new Border.all(
                                                  color: Colors
                                                      .grey[300])),
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceEvenly,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left:
                                                            10,
                                                            top:
                                                            10),
                                                        child: Align(
                                                          alignment:
                                                          Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            productDetails
                                                                .priceMatch
                                                                .title,
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                "PlayfairDisplay",
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                17.5,
                                                                color:
                                                                Colors.black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(
                                                      left: 10,
                                                      top: 6,
                                                      bottom: 20),
                                                  child: Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Text(
                                                      "If you find this product, for less, send us the screenshot,\nWe’ll match it."
                                                      /*productDetails
                                                          .priceMatch
                                                          .description*/
                                                      ,
                                                      textAlign:
                                                      TextAlign
                                                          .left,
                                                      style: TextStyle(
                                                          fontFamily:
                                                          "Helvetica",
                                                          fontWeight:
                                                          FontWeight
                                                              .normal,
                                                          fontSize:
                                                          13,
                                                          color: HexColor(
                                                              "#666666")),
                                                    ),
                                                  ),
                                                ),
                                              ])))),
                              //CHECK COD
                              IntroModelList.currency_iso_code ==
                                  "INR"
                                  ? Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                        bottom: 5),
                                    child: Align(
                                      alignment:
                                      Alignment.centerLeft,
                                      child: Text(
                                        "Check COD Eligibility ",
                                        textAlign:
                                        TextAlign.left,
                                        style: TextStyle(
                                            fontFamily:
                                            "Helvetica",
                                            fontWeight:
                                            FontWeight
                                                .normal,
                                            fontSize: 15,
                                            color:
                                            Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: 70,
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: StreamBuilder<
                                          ResponseMessage>(
                                          stream: productDetailsBloc.codAvail,
                                          builder: (context, snapshot) {
                                            return TextField(
                                              maxLength: 6,
                                              onChanged: (String code) {
                                                if(code==null || code==""){
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                }
                                                if (code.length < 6 || code == "000000" || code.startsWith("0")) {
                                                  setState(() {
                                                    validate = false;
                                                  });
                                                  print(validate);
                                                } else {
                                                  setState(() {
                                                    productDetailsBloc.clearCOD();
                                                    validate = true;
                                                    snapshot.data?.success = "";
                                                    snapshot.data?.error = "";
                                                    productDetailsBloc.codAvailability(code);


                                                  });
                                                  FocusScope.of(context).requestFocus(FocusNode());


                                                  print(validate);

                                                }
                                              },
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter(RegExp(r"[0-9]"))
                                              ],
                                              onSubmitted: (String a) {
                                                FocusScope.of(context).requestFocus(FocusNode());
                                              },
                                              decoration: InputDecoration(
                                                suffix: validate && snapshot.data?.error == ""
                                                    ? Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(shape: BoxShape.circle,
                                                      color: Colors.green),
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Icon(
                                                        Icons.check,
                                                        size: 15.0,
                                                        color: Colors.white,
                                                      )),
                                                )
                                                    : Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red),
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(0.0),
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 15.0,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                                errorText: validate
                                                    ? snapshot.data?.success != null && snapshot.data?.success != ""
                                                    ? snapshot.data.success
                                                    : snapshot.data?.error != null && snapshot.data?.error == ""
                                                    ? snapshot.data.error
                                                    : snapshot.data?.error
                                                    : "",
                                                errorStyle: TextStyle(
                                                    fontFamily: "Helvetica",
                                                    color: validate && snapshot?.data?.success != null && snapshot?.data?.success != ""
                                                        ? Colors.green
                                                        : Colors.red),
                                                hintText:
                                                "Enter Pincode",
                                                errorBorder:
                                                OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors
                                                          .grey,
                                                      width:
                                                      1.0),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors
                                                          .grey,
                                                      width:
                                                      1.0),
                                                ),
                                                hintStyle: TextStyle(
                                                    fontFamily:
                                                    "Helvetica",
                                                    fontWeight:
                                                    FontWeight
                                                        .normal,
                                                    fontSize:
                                                    15,
                                                    color: Colors
                                                        .black),
                                                border:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: HexColor(
                                                          "#e0e0e0"),
                                                      width:
                                                      1.0),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(color: HexColor("#e0e0e0"),
                                                      width: 1.0),
                                                ),
                                              ),
                                            );
                                          })),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              )
                                  : Center(),

                              //ONLINE ADVERTISEMENT
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 2, bottom: 15),
                                  child: Container(
                                    width: double.infinity,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: new AssetImage(
                                                "images/shipping_banner.png")
                                          //Can use CachedNetworkImage
                                        ),
                                        color: Colors.grey[100],
                                        borderRadius:
                                        BorderRadius.only(
                                            bottomLeft:
                                            Radius.circular(
                                                0),
                                            bottomRight:
                                            Radius.circular(
                                                0))),
                                  )),

                              //MORE MATERIALS
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                  NeverScrollableScrollPhysics(),
                                  itemCount: snapshot
                                      .data.moreOptions.length,
                                  itemBuilder: (context, int index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (connectionStatus
                                                .toString() !=
                                                "ConnectivityStatus.Offline") {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (__) => new ChildDetailPage(
                                                          snapshot
                                                              .data
                                                              .moreOptions[
                                                          index]
                                                              .page_title,
                                                          snapshot
                                                              .data
                                                              .moreOptions[
                                                          index]
                                                              .url)));
                                            } else {
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "No Internet Connection!")));
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.only(
                                                      left: 20,
                                                      top: 5),
                                                  child: Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Text(
                                                      snapshot
                                                          .data
                                                          .moreOptions[
                                                      index]
                                                          .title,
                                                      textAlign:
                                                      TextAlign
                                                          .left,
                                                      style: TextStyle(
                                                          fontFamily:
                                                          "Helvetica",
                                                          fontWeight:
                                                          FontWeight
                                                              .normal,
                                                          fontSize:
                                                          16,
                                                          color: Colors
                                                              .black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(
                                                    right: 20,
                                                    top: 10),
                                                child: Icon(
                                                  Icons
                                                      .arrow_forward_ios,
                                                  color:
                                                  Colors.black87,
                                                  size: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                              bottom: 5),
                                          child: Divider(
                                            thickness: 1,
                                            color:
                                            HexColor("#e0e0e0"),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Contact us if you have any questions",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight:
                                            FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey[300],
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                var whatsApp =
                                                await SupportDetails()
                                                    .getWhatsAppDetails();
                                                // print(whatsApp);
                                                await launch(whatsApp);
                                              },
                                              child: Container(
                                                  decoration:
                                                  BoxDecoration(
                                                      color: HexColor(
                                                          "#f5f5f5"),
                                                      border:
                                                      Border.all(
                                                        color: Colors
                                                            .grey[
                                                        400],
                                                      )),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            top: 10),
                                                        child:
                                                        Image.asset(
                                                          "images/whatsapp.png",
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            top: 10,
                                                            bottom:
                                                            10),
                                                        child: Align(
                                                          alignment:
                                                          Alignment
                                                              .center,
                                                          child: Text(
                                                            "WHATSAPP",
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                "Helvetica",
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            )),
                                        Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                var mobile =
                                                await SupportDetails()
                                                    .getMobileSupport();
                                                await launch(
                                                    "tel:$mobile");
                                              },
                                              child: Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    color: HexColor(
                                                        "#f5f5f5"),
                                                    border: Border(
                                                      top: BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .grey[400]),
                                                      bottom: BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .grey[400]),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            top: 10),
                                                        child: Icon(
                                                          Icons.phone,
                                                          color: Colors
                                                              .black,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            top: 10,
                                                            bottom:
                                                            10),
                                                        child: Align(
                                                          alignment:
                                                          Alignment
                                                              .center,
                                                          child: Text(
                                                            "PHONE",
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                "Helvetica",
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            )),
                                        Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                var email =
                                                await SupportDetails()
                                                    .getEmailSupport();

                                                await launch(
                                                    "mailto:${email}");
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: HexColor(
                                                          "#f5f5f5"),
                                                      border: Border.all(
                                                          color:
                                                          Colors.grey[
                                                          400])),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            top: 10),
                                                        child: Icon(
                                                          Icons
                                                              .mail_outline,
                                                          color: Colors
                                                              .black87,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            top: 10,
                                                            bottom:
                                                            10),
                                                        child: Align(
                                                          alignment:
                                                          Alignment
                                                              .center,
                                                          child: Text(
                                                            "EMAIL",
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                "Helvetica",
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                fontSize:
                                                                10,
                                                                color: Colors
                                                                    .black),
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
                              //BUY PRODUCTS TOGETHER

                              boughtTogetherItems != null &&
                                  boughtTogetherItems.length > 0
                                  ? BuyTogetherProd(
                                id: productDetails.id,
                                mrp: productDetails.display_mrp,
                                youPay: productDetails
                                    .sizes[
                                bottomSheet.sizeIndex]
                                    .display_you_pay,
                                productDetails: productDetails,
                                productSize: bottomSheet
                                    .productSelectSize,
                                buyTogetherItems:
                                boughtTogetherItems,
                                model: boughtTogetherModel,
                                bottomSheetIndex:
                                bottomSheet.sizeIndex,
                              )
                                  : Center(),
                              //TOTAL PRICE

                              //OTHER CATALOGUE
                              youMayLikeItems != null &&
                                  youMayLikeItems.length > 0
                                  ? Padding(
                                padding: const EdgeInsets.only(bottom:20.0),
                                child: YouMayLikeList(
                                    id: widget.id,
                                    patternName:
                                    "You May Also Like",
                                    tag: "horizontalListing",
                                    childModel: youMayLikeItems),
                              )
                                  : Center(),


                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 20),
                                child: RecentlyViewCatalogueList(
                                    tag: "horizontalListing",
                                    patternName: "Recently Viewed"),
                              ),
                            ],
                          ),
                        )
                            : productInactive(context, "this product."),
                        ProductItemDetail.error == "" &&
                            productDetails != null
                            ? lowerHalf(context)
                            : Padding(
                          padding: EdgeInsets.all(0),
                        )
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          )
              : ErrorPage(
            appBarTitle: "You are offline.",
          )),
    );
  }

  Widget productInactive(BuildContext context, String text) {
    return Stack(alignment: Alignment.topCenter, children: <Widget>[
      Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
        child: Center(
          child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Image.asset(
                        "images/empty_bag.png",
                      )),
                  Text(
                    "NO ITEM FOUND",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: "PlayfairDisplay"),
                  ),
                ],
              )),
        ),
      ),
      Positioned(
          top: 15,
          left: 15,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
                height: 30,
                width: 30,
                color: Colors.white,
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Platform.isAndroid
                              ? Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          )
                              : Padding(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        )))),
          )),

      // ListView.builder() shall be used here.
    ]);
  }

  Widget lowerHalf(BuildContext context) {
    return Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 2, left: 20, right: 20),
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  /*  gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 143, 158, 1),
                        Color.fromRGBO(255, 188, 143, 1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),*/
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                    if (connectionStatus.toString() !=
                        "ConnectivityStatus.Offline") {
                      if (productDetails.sizes[bottomSheet.sizeIndex].inCart) {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new ShoppingBag()));
                      } else {
                        if(!bottomSheet.productSelectSize){
                          ToastMsg().getFailureMsg(context, "Please Select the Size");
                          return;
                        }
                        else{
                          cartItems.add(new CartItems(
                              productId: widget.id,
                              sizeId: productDetails.sizes[bottomSheet.sizeIndex].id,
                              quantity: 1,
                              parentId: 0));
                          cartModel = new CartModel(
                              pageName: "", attributeId: 0, products: cartItems);
                          cartBloc.addCartItems(cartModel);
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              productDetailsBloc.getProductDetails(
                                  widget.id, widget.url);
                            });
                          });
                          UserTrackingDetails().addToCart(
                              productDetails.designerName,
                              widget.image,
                              widget.id.toString(),
                              productDetails.display_you_pay,
                              widget.url);
                        }

                      }
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("No Internet Connection!")));
                    }
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.red[900],
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Text(
                    !productDetails.sizes[bottomSheet.sizeIndex].inCart
                        ? 'ADD TO BAG'
                        : "GO TO BAG",
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
        ));
  }

  Widget _buildMrpDialog(
      BuildContext context, String you_pay, String payableTax) {
    double value = double.parse(you_pay) - double.parse(payableTax);

    return new Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    child: Icon(
                      Icons.clear,
                      size: 25,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )),
            ),
            Text(
                "Base Price : ${CountryInfo.currencySymbol} ${updateTheTotalAMt(value.toString())}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.black87)),
            SizedBox(
              height: 15,
            ),
            Text(
                "GST : ${CountryInfo.currencySymbol} ${updateTheTotalAMt(payableTax)}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.black87)),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutDialog(BuildContext context, List<String> loyalty_info) {
    return new AlertDialog(
      title: Text(
        "Loyalty Points",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: "PlayfairDisplay",
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87),
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 175,
            child: new ListView.builder(
                itemCount: loyalty_info.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Column(
                    children: [
                      new Text("${loyalty_info[index].toString()}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black87)),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                }),
          ),
          Container(
            width: double.infinity,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.grey[400],
                    width: 1,
                    style: BorderStyle.solid),
                // borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              child: Text(
                'GOT IT',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Helvetica",
                    color: Colors.black,
                    fontSize: 15),
              ),
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
  Widget productDetail(context, String about, String details, String shipping) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: InkWell(
            onTap: () {
              setState(() {
                if (expandedAbout == false) {
                  expandedShipping = false;
                  expandedDetails = false;
                  expandedAbout = true;
                } else {
                  expandedAbout = false;
                  expandedAbout = false;
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "ABOUT",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        fontFamily: "Helvetica",
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: expandedAbout
                      ? Icon(
                    Icons.keyboard_arrow_up,
                    size: 25,
                    color: Colors.black54,
                  )
                      : Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 25,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        expandedAbout == true
            ? Padding(
            padding:
            EdgeInsets.only(left: 22, top: 0, bottom: 5, right: 25),
            child: new Html(
              data: "$about",
              defaultTextStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: "Helvetica",
                  fontSize:
                  13.5), /* Text(about,
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                maxLines: 7,
                style: TextStyle(
                    color: HexColor("#666666"),
                    fontFamily: "Helvetica",
                    fontSize: 14))*/
            ))
            : Padding(padding: EdgeInsets.all(0)),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25),
          child: Divider(thickness: 2, color: Colors.grey[300]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: InkWell(
            onTap: () {
              setState(() {
                if (expandedDetails == false) {
                  expandedShipping = false;
                  expandedAbout = false;
                  expandedDetails = true;
                } else {
                  expandedDetails = false;
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "DETAILS",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        fontFamily: "Helvetica",
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: expandedDetails
                      ? Icon(
                    Icons.keyboard_arrow_up,
                    size: 25,
                    color: Colors.black54,
                  )
                      : Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 25,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        expandedDetails == true
            ? Padding(
            padding:
            EdgeInsets.only(left: 23, top: 0, bottom: 5, right: 25),
            child: new Html(
                data: "$details",
                defaultTextStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: "Helvetica",
                    fontSize: 13.5)))
            : Padding(padding: EdgeInsets.all(0)),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25),
          child: Divider(thickness: 2, color: Colors.grey[300]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: InkWell(
            onTap: () {
              setState(() {
                if (expandedShipping == false) {
                  expandedAbout = false;
                  expandedDetails = false;
                  expandedShipping = true;
                } else {
                  expandedShipping = false;
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "SHIPPING",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        fontFamily: "Helvetica",
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: expandedShipping
                      ? Icon(
                    Icons.keyboard_arrow_up,
                    size: 25,
                    color: Colors.black54,
                  )
                      : Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 25,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        expandedShipping
            ? Column(
          children: [
            Container(

                padding: EdgeInsets.only(
                    left: 25, top: 15, bottom: 5, right: 25),
                child: Text(
                    !bottomSheet.productSelectSize
                        ? "Please select a size for an estimated delivery time"
                        : "Product will be shipped within ${shipping} weeks from the date of purchase.",
                    textAlign: TextAlign.left,
                    softWrap:true,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    style: TextStyle(
                        color: HexColor("#666666"),
                        fontFamily: "Helvetica",
                        fontSize: 14))),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25, top: 5, bottom: 5),
              child: Divider(thickness: 2, color: Colors.grey[200]),
            ),
            productDetails.returnPolicy != ""
                ? Container(
              //width:MediaQuery.of(context).size.width-60,
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Return Policy :",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: "Helvetica",
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 5,right: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${productDetails.returnPolicy}",
                          textAlign: TextAlign.left,
                          softWrap:true,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.normal,
                              fontSize: 13.5,
                              color: Colors.black),
                        ),
                      )),
                ],
              ),
            )
                : Center(),
          ],
        )
            : Padding(padding: EdgeInsets.all(0)),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  String updateTheTotalAMt(String amount) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    String result = (amount.split(".").first).replaceAllMapped(reg, mathFunc);
    print('$amount -> $result');
    return result;
  }
}
