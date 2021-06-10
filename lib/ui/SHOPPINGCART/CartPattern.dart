import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/bloc/CartBloc/CartBloc.dart';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/models/Orders/OrderModel.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class CartPattern extends StatefulWidget {
  List<Widget> widgetsList;
  CartModelList model;
  String tag;

  CartPattern(
      {this.tag,this.model});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<CartPattern> {
  String imageValue = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top:10,bottom:10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget> [
              _itemDesignModule(context),
              Expanded(
                child:Container(
                    padding: EdgeInsets.only(left: 10,top:5,),
                    color: Colors.white,
                    child: Column(
                        children: <Widget>[
                          Container(
                          //    height: 165,
                              width: double.infinity,
                              color: Colors.white,
                              child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${widget.model.designer_name}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              fontFamily: "Helvetica-Condensed",
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${widget.model.name}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              fontFamily: "Helvetica",
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Color: ${widget.model.colour_name}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13,
                                              fontFamily: "Helvetica",
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Size: ${widget.model.size_name}  |  Qty : ${widget.model.quantity}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13,
                                              fontFamily: "Helvetica",
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 5),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            widget.model
                                                .discount_percentage !=
                                                "0" ? Padding(
                                              padding: EdgeInsets
                                                  .all(2),
                                              child: Align(
                                                alignment: Alignment
                                                    .centerLeft,
                                                child: Text(
                                                  "${CountryInfo.currencySymbol} ${widget
                                                      .model.display_you_pay} ",
                                                  textAlign: TextAlign
                                                      .left,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 12.5,
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
                                                  "${CountryInfo.currencySymbol} ${widget
                                                      .model
                                                      .display_mrp} ",
                                                  textAlign: TextAlign
                                                      .left,

                                                  style: TextStyle(
                                                      decoration: widget
                                                          .model
                                                          .discount_percentage !=
                                                          "0"
                                                          ? TextDecoration
                                                          .lineThrough
                                                          : null,
                                                      fontWeight: widget
                                                          .model
                                                          .discount_percentage !=
                                                          "0"
                                                          ? FontWeight
                                                          .normal
                                                          : FontWeight
                                                          .bold,
                                                      fontSize: 12.5,
                                                      fontFamily: "Helvetica",
                                                      color: Colors
                                                          .black),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets
                                                    .all(2),
                                                child: Align(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: Text(
                                                    widget
                                                        .model
                                                        .discount_percentage !=
                                                        "0"
                                                        ? "(${widget
                                                        .model
                                                        .discount_percentage}% Off)"
                                                        : "",
                                                    textAlign: TextAlign
                                                        .left,
                                                    style: TextStyle(
                                                        fontWeight: widget
                                                            .model
                                                            .discount_percentage !=
                                                            "0"
                                                            ? FontWeight
                                                            .normal
                                                            : FontWeight
                                                            .bold,
                                                        fontSize: 11.5,
                                                        fontFamily: "Helvetica",
                                                        color: Colors
                                                            .red[900]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),

                                    widget.tag=="ShoppingBag"?Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(left:5,right:5,top: 15,bottom: 8),
                                            child:InkWell(
                                              onTap: () {
                                                CustomBottomSheet().removeItem(
                                                    context, false, widget.model.id,
                                                    widget.model.image, widget.model.size_id,
                                                    1);
                                                setState(() {

                                                });


                                              },
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("REMOVE",textAlign:TextAlign.left,style: TextStyle(fontSize :13.5, fontWeight:FontWeight.normal,fontFamily: "Helvetica",color: Colors.black),),
                                              ),
                                            )
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top:5),
                                          width: 2,
                                          height: 24,
                                          child: VerticalDivider(color: Colors.grey[500],thickness: 1,),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left:5,top: 15,bottom: 8),
                                            child: InkWell(
                                              onTap:(){
                                                cartBloc.removeItem(widget.model.id, widget.model.size_id, 1,"cart item moved");
                                                cartBloc.removeCartList.listen((event) {
                                                  cartBloc.fetchAllCartItems();
                                                  wishList.getWishList();
                                                });

                                                wishList.addWishListData(context, widget.model.id);
                                                wishList.addWishList.listen((event) {
                                                  if(event.error.isEmpty){}
                                                  print("WISHLIST EVENT: ${event} ${BagCount.wishlistCount} ${BagCount.bagCount}");
                                                });
                                                UserTrackingDetails().addToWishlist( widget.model.designer_name, widget.model.image,widget.model.id.toString(),widget.model.you_pay,widget.model.url);

                                                setState(() {

                                                });



                                                UserTrackingDetails().removedFromCart( widget.model.designer_name, widget.model.image,widget.model.id.toString(),widget.model.you_pay,widget.model.url);

                                              },
                                              child:Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("MOVE TO WISHLIST",textAlign:TextAlign.left,style: TextStyle(fontSize :13.5, fontWeight:FontWeight.normal,fontFamily: "Helvetica",color: Colors.black),),
                                              ),

                                            )
                                        ),
                                      ],
                                    ):Center()

                                  ])),

                        ])),
              )

            ],

          ),
          widget.tag=="ShoppingBag"?Center()
              :Padding(
            padding: EdgeInsets.only(left:10,right: 15,top:15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Estimated Delivery on ${widget.model.estimated_delivery}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "Helvetica",
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
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
                        builder: (context) => ProductDetail(id: widget.model.id,image: widget.model.image,)));
              },
              child:Container(
                width: 120,
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image:new CachedNetworkImageProvider(widget.model.image)
                      //Can use CachedNetworkImage
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0))),
              )),

        ]);
  }
}
