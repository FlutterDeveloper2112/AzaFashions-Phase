import 'dart:io';
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Listing/SizeList.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class PatternTwo extends StatefulWidget {
  List<Widget> widgetsList;
  String designerImage, designertitle, designDescription,mrp,discount,you_pay, tag,productTag,url;
  int id;
  SizeList sizeList;
  bool wishlist;
  PatternTwo(
      {this.designerImage,
        this.designertitle,
        this.tag,
        this.designDescription,this.mrp,this.discount,this.you_pay,this.id,this.sizeList,this.wishlist,this.productTag,this.url});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<PatternTwo> {
  FirebaseAnalytics analytics = FirebaseAnalytics();


  @override
  void initState() {
    print("IMAGE TWO: ${widget.designerImage}");
    // ignore: unnecessary_statements
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
      return Column(
      children: <Widget>[
     _itemDesignModule(context),
        Container(

          padding: EdgeInsets.only(top:5),
          width: double.infinity,
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:2,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${widget.designertitle}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          fontFamily: "Helvetica-Condensed",
                          color: Colors.black),
                    ),
                    /*   Expanded(
                      child:*/
                    Padding(
                      padding: EdgeInsets.only(right: 25),
                      child: InkWell(
                          onTap: () async {
                            wishList.clearAddWishlist();

                            if (widget.wishlist == false) {
                              wishList.addWishListData(
                                  context, widget.id);
                              wishList.addWishList.listen((event) {
                                if(event.success!="Product Doesn't Exists or is Inactive"){
                                  setState(() {
                                    widget.wishlist=true;
                                  });
                                }
                                UserTrackingDetails().addToWishlist( widget.designertitle, widget.designerImage,widget.id.toString(),widget.mrp,widget.url);

                              });
                            }
                            else {

                              wishList.removeWishListData(
                                  context, widget.id,"");
                              wishList.removeWishList.listen((event) {
                                if(event.success!=""){
                                  setState(() {
                                    widget.wishlist=false;
                                  });
                                }

                              });
                              UserTrackingDetails().removedFromWishlist( widget.designertitle, widget.designerImage,widget.id.toString(),widget.you_pay,widget.url);

                            }

                          } ,
                          child: (widget.wishlist==false)
                              ? Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Colors.black,
                          )
                              : Icon(
                            Icons.favorite,
                            size: 18,
                            color: Colors.redAccent,
                          )),
                    )
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.designDescription}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        fontFamily: "Helvetica",
                        color: Colors.grey),
                  ),
                ),
              ),
             Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start,
                        children: <Widget>[
                          widget.discount !=
                              "0" ? Padding(
                            padding: EdgeInsets
                                .all(2),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft,
                              child: Text(
                                "${CountryInfo.currencySymbol} ${widget
                                    .you_pay} ",
                                textAlign: TextAlign
                                    .left,
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .bold,
                                    fontSize: 13,
                                    fontFamily: "Helvetica",
                                    color: Colors
                                        .black),
                              ),
                            ),
                          ) : Center(),
                          Padding(
                            padding: EdgeInsets
                                .all(2),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft,
                              child: Text(
                                "${CountryInfo.currencySymbol} ${widget.mrp} ",
                                textAlign: TextAlign
                                    .left,

                                style: TextStyle(
                                    decoration: widget.discount !=
                                        "0"
                                        ? TextDecoration
                                        .lineThrough
                                        : null,
                                    fontWeight: widget.discount !=
                                        "0"
                                        ? FontWeight
                                        .normal
                                        : FontWeight
                                        .bold,
                                    fontSize: 13,
                                    fontFamily: "Helvetica",
                                    color: Colors
                                        .black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets
                                .all(2),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft,
                              child: Text(
                                widget.discount !=
                                    "0"
                                    ? "(${widget
                                    .discount}% Off)"
                                    : "",
                                textAlign: TextAlign
                                    .left,
                                style: TextStyle(
                                    fontWeight: widget.discount!=
                                        "0"
                                        ? FontWeight
                                        .normal
                                        : FontWeight
                                        .bold,
                                    fontSize: 13,
                                    fontFamily: "Helvetica",
                                    color: Colors
                                        .red[900]),
                              ),
                            ),
                          ),
                        ]),
                  ),
              widget.productTag!=null && widget.productTag!=""? Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .start,
                  children: [
                    Container(
                      width: widget.productTag.length>20?100:65,
                      child: Container(
                        padding: EdgeInsets.only(top:3,bottom:3),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                              //
                            )),
                        //             <--- BoxDecoration here
                        child: Text(
                          " ${widget.productTag}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Helvetica",
                              fontSize: 8.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ):Center(),

            ],
          ),
        ),
         ],
    );
  }

  Widget _itemDesignModule(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
        children: <Widget>[
          InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetail(id: widget.id,image: widget.designerImage,url:widget.url,productTag: widget.productTag,)));

              },
              child:   Container(

                width:345,
                height: 495,//465,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                      image:CachedNetworkImageProvider(widget.designerImage),
                      //Can use CachedNetworkImage
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0))),
              )),
          (widget.tag=="home")? Container():Container(
              padding: EdgeInsets.only(left:10,bottom:10),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                      onTap: () {
                        CustomBottomSheet().getSimilarProductSheet(context,widget.id);
                      },
                      child:  Image.asset(
                        "images/similarproducts_icon.png",
                        width: 25,
                        height: 25,
                      ))


              ))
        ]);
  }
}
