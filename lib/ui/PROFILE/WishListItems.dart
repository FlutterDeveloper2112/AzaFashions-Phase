
import 'dart:io';

import 'package:azaFashions/models/Profile/WishList.dart';
import 'package:azaFashions/models/Listing/SizeList.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:azaFashions/utils/CountryInfo.dart';

// ignore: must_be_immutable
class WishListItem extends StatefulWidget {
  WishList wishlistList;
  SizeList sizeList;
  String designerImage, name, designerName, mrp,tag;
  final int id;

  WishListItem(
      {this.wishlistList,this.designerImage,
        this.name,
        this.tag,
        this.designerName, this.mrp,this.id,this.sizeList});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<WishListItem> {
  String imageValue = "";
  FirebaseAnalytics analytics = FirebaseAnalytics();


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        _itemDesignModule(context),


        Container(

          padding: EdgeInsets.only(left:5,top:5),
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: <Widget>[
               Padding(
                 padding: const EdgeInsets.only(left:5,bottom:5.0),
                 child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${widget.wishlistList.designerName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            fontFamily: "Helvetica-Condensed",
                            color: Colors.black),
                      ),
                    ),
               ),
               Padding(
                 padding: const EdgeInsets.only(left:5,bottom:5.0),
                 child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.wishlistList.name}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12.5,
                              fontFamily: "Helvetica",
                              color: Colors.grey),
                        ),
                      ),
               ),
               Padding(
                padding: EdgeInsets.only(left:5,bottom: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start,
                    children: <Widget>[
                      widget.wishlistList.discount !=
                          "0" ? Padding(
                        padding: EdgeInsets
                            .all(2),
                        child: Align(
                          alignment: Alignment
                              .centerLeft,
                          child: Text(
                            "${CountryInfo.currencySymbol} ${widget
                                .wishlistList.display_you_pay} ",
                            textAlign: TextAlign
                                .left,
                            style: TextStyle(
                                fontWeight: FontWeight
                                    .bold,
                                fontSize: 12,
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
                            "${CountryInfo.currencySymbol} ${widget.wishlistList.display_mrp} ",
                            textAlign: TextAlign
                                .left,

                            style: TextStyle(
                                decoration: widget.wishlistList.discount !=
                                    "0"
                                    ? TextDecoration
                                    .lineThrough
                                    : null,
                                fontWeight: widget.wishlistList.discount !=
                                    "0"
                                    ? FontWeight
                                    .normal
                                    : FontWeight
                                    .bold,
                                fontSize: 12,
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
                            widget.wishlistList.discount !=
                                "0"
                                ? "(${widget
                                .wishlistList.discount}% Off)"
                                : "",
                            textAlign: TextAlign
                                .left,
                            style: TextStyle(
                                fontWeight: widget.wishlistList.discount!=
                                    "0"
                                    ? FontWeight
                                    .normal
                                    : FontWeight
                                    .bold,
                                fontSize: 11,
                                fontFamily: "Helvetica",
                                color: Colors
                                    .red[900]),
                          ),
                        ),
                      ),
                    ]),
              ),

             Align(
                alignment: Alignment.center,
              child:
              Container(
                padding: EdgeInsets.only(left: 2,right: 2,bottom: 5),
                width:double.infinity,
               height: 30,
               decoration: BoxDecoration(
                  color:Colors.transparent,

                ),
                child: FlatButton(
                  onPressed: () {
                    CustomBottomSheet().getChooseSizeBottomSheet(context,"",widget.wishlistList.sizeList, widget.wishlistList.id,"whishlist item remove");
                    setState(() {

                    });

                  },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black54,
                        width: 1,
                        style: BorderStyle.solid),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: Text('MOVE TO BAG', textAlign: TextAlign.center,
                    style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "Helvetica",color: Colors.black,fontSize: 11),),
                  color: Colors.transparent),
              )),
             InkWell(
               onTap: (){
                CustomBottomSheet().removeItem(context, true, widget.id,widget.designerImage,0,0);
                  setState(() {

                  });
                },
               child:Align(
                 alignment: Alignment.center,
                 child: Text(
                   " REMOVE ",
                   style: TextStyle(color: Colors.black45, fontFamily: "Helvetica",fontSize: 12.0),
                 ),
               ),
             ),
            ],
          ),
        ),
       SizedBox(height: 5,)
      ],
    );
  }

  Widget _itemDesignModule(BuildContext context) {
    return Stack(
        children: <Widget>[
        InkWell(
        onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetail(
                id: widget.id,image: widget.designerImage,
              )));
    },
    child:Padding(
      padding: EdgeInsets.only(left:5,right:5),
      child: Align(
              alignment: Alignment.center,
              child:   Container(
                width: widget.tag=="horizontalListing" || widget.tag=="shoppingBag"?210:160,
                height:widget.tag=="horizontalListing" || widget.tag=="shoppingBag"?315:235 ,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                      image:new CachedNetworkImageProvider(widget.wishlistList.url)

                      //Can use CachedNetworkImage
                    ),
                    color: Colors.white,
                    /*border: Border.all(
                    color: Colors.black,
                    width: 1, //                   <--- border width here
                  ),*/
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0))),
              ),
            ),
    )),

          widget.name=="Out of Stock"?Container(
            color: Colors.white54,
          child:Center(
            child: Text("OUT OF STOCK"),
          )):Center()

        ]);
  }
}
