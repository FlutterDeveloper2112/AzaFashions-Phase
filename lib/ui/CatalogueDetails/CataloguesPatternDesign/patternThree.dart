import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/models/Listing/SizeList.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class PatternThree extends StatefulWidget {
  List<Widget> widgetsList;
  String designerImage, designertitle, designDescription, tag,mrp,discount,you_pay,productTag,url;
  int id;
  SizeList sizeList;
  bool wishlist;
  PatternThree(
      {this.designerImage,
        this.designertitle,
        this.tag,
        this.designDescription,this.mrp,this.discount,this.you_pay,this.id,this.sizeList,this.wishlist,this.productTag,this.url});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<PatternThree> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
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
      return Card(
        child:InkWell(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetail(id: widget.id,image: widget.designerImage,url:widget.url,productTag: widget.productTag,)));

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget> [
              _itemDesignModule(context),
              Expanded(
                child:Container(
                  padding: EdgeInsets.only(left: 5,top:5,),
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 110,
                        //  padding: EdgeInsets.only(top:5),
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                   Text(
                                      "${widget.designertitle}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                          fontFamily: "Helvetica-Condensed",
                                          color: Colors.black),
                                    ),

                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
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

                                            });
                                            UserTrackingDetails().addToWishlist( widget.designertitle, widget.designerImage,widget.id.toString(),widget.you_pay,widget.url);

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
                                          }
                                          UserTrackingDetails().removedFromWishlist( widget.designertitle, widget.designerImage,widget.id.toString(),widget.you_pay,widget.url);

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
                              padding: const EdgeInsets.only(bottom:3.0),
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
                                                fontSize: 12,
                                                fontFamily: "Helvetica",
                                                color: Colors
                                                    .red[900]),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            widget.productTag!=null  && widget.productTag!=""? Row(
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
                            ):Center(),

                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              )

            ],
          ),
        )
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
                        builder: (context) => ProductDetail(id: widget.id,image: widget.designerImage,url:widget.url,productTag: widget.productTag,)));

              },
              child:   Container(
                width: 120,
                height: 150,
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
          (widget.tag=="home")? Container():Positioned(
            bottom: 10,
            left: -95,
            right: 0,
            child: Center(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: InkWell(
                        onTap: () {
                          CustomBottomSheet().getSimilarProductSheet(context,widget.id);
                        },
                        child:Image.asset(
                          "images/similarproducts_icon.png",
                          width: 20,
                          height: 20,
                        ))
                )),

          )
        ]);
  }
}
