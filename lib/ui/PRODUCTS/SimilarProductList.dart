
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class SimilarProductList extends StatefulWidget {

  List<Widget> widgetsList;
  String designerImage, designertitle, designDescription, tag,mrp,url, productTag;
  int id;

  SimilarProductList(
      {this.designerImage,
        this.designertitle,
        this.tag,
        this.designDescription,this.mrp,
        this.id,this.url,this.productTag});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<SimilarProductList> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  String imageValue = "";
  bool wishlist = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    analytics.setCurrentScreen(screenName: "Similar Products");
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _itemDesignModule(context),
        Container(
          height: 70,
          padding: EdgeInsets.only(left:5,top: 5),
          width: double.infinity,
        //  color: Colors.grey[400],
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      "${widget.designertitle}",
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          fontFamily: "Helvetica-Condensed",
                          color: Colors.black),
                    ),
                  ),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              if (!wishlist) {
                                setState(() {
                                  wishlist = true;
                                });
                                wishList.addWishListData(context, widget.id);
                                wishList.addWishList.listen((event) {
                                  print("WISHLIST EVENT: ${event}");
                                });
                              } else {
                                setState(() {
                                  wishlist = false;
                                });
                                wishList.removeWishListData(context, widget.id,"");
                                wishList.removeWishList.listen((event) {
                                  print("WISHLIST EVENT: ${event}");
                                });
                              }
                            });
                          },
                          child: (!wishlist)
                              ? Icon(
                            Icons.favorite_border,
                            size: 15,
                            color: Colors.black,
                          )
                              : Icon(
                            Icons.favorite,
                            size: 15,
                            color: Colors.redAccent,
                          ))),
                ],
              ),
               Padding(
                 padding: EdgeInsets.only(top:5,bottom:5),
                 child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.designDescription,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            fontFamily: "Helvetica",
                            color: Colors.black45),
                    )),
               ),
              Padding(
                padding: EdgeInsets.only(top:2,bottom:5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${CountryInfo.currencySymbol} ${widget.mrp}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                       fontFamily: "Helvetica",
                        color: Colors.black),
                  ),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  Widget _itemDesignModule(BuildContext context) {
    return Stack(children: <Widget>[
        InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetail(id: widget.id,image: widget.designerImage,url:widget.url,productTag: widget.productTag,)));
        },
        child: Container(
          width: 149,
          height: 225,

          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image:new CachedNetworkImageProvider(widget.designerImage)
                //Can use CachedNetworkImage
              ),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0))),
        ),
      ),
    ]);
  }
}
