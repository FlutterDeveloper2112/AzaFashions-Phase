
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/bloc/CartBloc/CartBloc.dart';
import 'package:azaFashions/bloc/ProductBloc/SimilarProductBloc.dart';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/SizeList.dart';
import 'package:azaFashions/models/Orders/TrackingDetails.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// ignore: must_be_immutable
class PatternOne extends StatefulWidget {
  List<Widget> widgetsList;
  String designerImage, designertitle, designDescription, tag,mrp,discount,you_pay,productTag,url;
  int id;
  SizeList sizeList;
  bool wishlist;

  PatternOne(
      {this.designerImage,
        this.designertitle,
        this.tag,
        this.designDescription,this.mrp,this.discount,this.you_pay,this.id,this.sizeList, this.wishlist,this.productTag,this.url});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<PatternOne> {
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

      return Column(
      children: <Widget>[
          _itemDesignModule(context),

        Container(
          height:widget.tag!="shoppingBag"?90:115,
          padding: EdgeInsets.only(top:2,left: 2),
          width: double.infinity,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top:5,bottom: 4),
                      child:  Text(
                        "${widget.designertitle}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13.5,
                            fontFamily: "Helvetica-Condensed",
                            color: Colors.black),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 2),
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
              Padding(
                  padding: EdgeInsets.only(bottom: 2,right:10),
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${widget.designDescription}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12.5,
                          fontFamily: "Helvetica",
                          color: Colors.black),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
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
                                fontSize: 11.5,
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
                                fontSize: 11.5,
                                fontFamily: "Helvetica",
                                color: Colors
                                    .black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets
                            .all(1),
                        child: Align(
                          alignment: Alignment
                              .centerLeft,
                          child: Text(
                              widget.discount !=
                                  "0"
                                  ? "(${widget
                                  .discount}% Off)"
                                  : "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign
                                  .left,
                              style: TextStyle(
                                  fontWeight: widget.discount!=
                                      "0"
                                      ? FontWeight
                                      .normal
                                      : FontWeight
                                      .bold,
                                  fontSize: 10.5,
                                  fontFamily: "Helvetica",
                                  color:Colors.red[900])
                          ),
                        ),
                      ),
                    ]),
              ),
               widget.productTag!=null && widget.productTag!=""? Container(
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
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Helvetica",
                          fontSize: 8.5),
                    ),
                  ),
                ):Center(),


              (widget.tag=="shoppingBag")?InkWell(
                  onTap: (){
                    CustomBottomSheet().getChooseSizeBottomSheet(context,"patternOne",widget.sizeList, widget.id,"whishlist item remove" );

                  },
                  child:Padding(
                      padding: EdgeInsets.only(top:3,left:4),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("MOVE TO BAG",textAlign:TextAlign.left,style: TextStyle(decoration:TextDecoration.underline,fontSize :12, fontWeight:FontWeight.normal,fontFamily: "Helvetica",color: HexColor("#666666")))
                      ))):Center(),


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
              width: widget.tag=="horizontalListing" || widget.tag=="shoppingBag"?210:160,
              height:widget.tag=="horizontalListing" || widget.tag=="shoppingBag"?290:245 ,
             /* height: widget.tag!="horizontalListing" || widget.tag!="shoppingBag"?MediaQuery.of(context).size.height*0.29:Platform.isIOS?280:550*//*MediaQuery.of(context).size.height*0.35*//*,
             */ decoration: BoxDecoration(
                  image: DecorationImage(
                    fit:BoxFit.fill,
                    image:CachedNetworkImageProvider(widget.designerImage),

                    //Can use CachedNetworkImage
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
            ),
          ),

          (widget.tag=="horizontalListing") || widget.tag=="You May Also Like" ||widget.tag=="Recently Viewed" ? Container():
          Container(
              padding: EdgeInsets.only(left:5,bottom:10),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: StreamBuilder<ChildListingModel>(
                      stream: similarBloc.similarProduct,
                      builder: (context, snapshot) {
                        return InkWell(
                            onTap: () {
                              CustomBottomSheet().getSimilarProductSheet(context,widget.id);
                            },
                            child:Image.asset(
                              "images/similarproducts_icon.png",
                              width: 20,
                              height: 25,
                            ));
                      }
                  )


              ))
        ]);
  }
}
