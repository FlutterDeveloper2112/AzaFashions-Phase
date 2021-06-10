import 'dart:io';
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/bloc/ProductBloc/SimilarProductBloc.dart';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/home_menuoptions.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class CataloguePatternOne extends StatelessWidget {
  final List<ModelList> items;
  CataloguePatternOne({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemDesignPage(
      items: items,
    );
  }
}

class ItemDesignPage extends StatefulWidget {
  final List<ModelList> items;
  ItemDesignPage({Key key, this.items}) : super(key: key);

  @override
  ItemDesignState createState() => ItemDesignState();
}

class ItemDesignState extends State<ItemDesignPage>{
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height<700?  4.3: 3.9;


    return Container(
    //  padding: const EdgeInsets.all(15),
      child: Container(
          color: Colors.white,
          child:MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Padding(
            padding: const EdgeInsets.only(left:16,right:15),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: Options.menu=="Home Decor"? 2/3.5:2/height,
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                ),
                shrinkWrap:true,
                itemCount: widget.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return  Container(
                     child: Column(
                       children: [
                         Stack(
                           alignment: Alignment.bottomLeft,
                           children: <Widget>[
                             InkWell(
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => ProductDetail(id: widget.items[index].id,image: widget.items[index].image,url:widget.items[index].url,productTag:widget.items[index].productTag,)));
                               },
                               child:   Container(
                                 width:175,
                                 height:Options.menu=="Home Decor"?Platform.isIOS?200:150:Platform.isIOS?255:250 ,
                               /*  height:Platform.isIOS?200:150,*/
                                 decoration: BoxDecoration(
                                     image: DecorationImage(
                                       fit:BoxFit.fill,
                                       image:CachedNetworkImageProvider(widget.items[index].image),

                                       //Can use CachedNetworkImage
                                     ),
                                     color: Colors.white,
                                     borderRadius: BorderRadius.only(
                                         bottomLeft: Radius.circular(0),
                                         bottomRight: Radius.circular(0))),
                               ),
                             ),
                             Container(
                                 padding: EdgeInsets.only(left:5,bottom:10),
                                 child: Align(
                                     alignment: Alignment.bottomLeft,
                                     child: StreamBuilder<ChildListingModel>(
                                         stream: similarBloc.similarProduct,
                                         builder: (context, snapshot) {
                                           return InkWell(
                                               onTap: () {
                                                 CustomBottomSheet().getSimilarProductSheet(context,widget.items[index].id);
                                               },
                                               child:Image.asset(
                                                 "images/similarproducts_icon.png",
                                                 width: 20,
                                                 height: 25,
                                               ));
                                         }
                                     )


                                 ))

                           ],
                         ),
                         Padding(
                           padding:  EdgeInsets.only(left:3.0,top:2),
                           child: Align(
                             alignment:Alignment.centerLeft,
                             child:  Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                 Expanded(
                                   child: Padding(
                                     padding: EdgeInsets.only(top:5,bottom: 2),
                                     child:  Text(
                                       "${widget.items[index].designer_name}",
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

                                         if (widget.items[index].wishlist == false) {

                                           wishList.addWishListData(
                                               context, widget.items[index].id);
                                           wishList.addWishList.listen((event) {
                                             if(event.success!="Product Doesn't Exists or is Inactive"){
                                               setState(() {
                                                 widget.items[index].wishlist=true;
                                               });
                                             }

                                           });
                                           UserTrackingDetails().addToWishlist( widget.items[index].designer_name, widget.items[index].image,widget.items[index].id.toString(),widget.items[index].you_pay,widget.items[index].url);

                                         }
                                         else {

                                           wishList.removeWishListData(
                                               context, widget.items[index].id,"");
                                           wishList.removeWishList.listen((event) {
                                             if(event.success!=""){
                                               setState(() {
                                                 widget.items[index].wishlist=false;
                                               });
                                             }

                                           });
                                           UserTrackingDetails().removedFromWishlist( widget.items[index].designer_name, widget.items[index].image,widget.items[index].id.toString(),widget.items[index].you_pay,widget.items[index].url);

                                         }

                                       } ,
                                       child: (widget.items[index].wishlist==false)
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
                         ),
                       Padding(
                      padding:  EdgeInsets.only(left:3.0,top:2),
                      child:
                         Align(
                       alignment:Alignment.centerLeft,

                       child:Text(
                           "${widget.items[index].name}",
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                           textAlign: TextAlign.left,
                           style: TextStyle(
                               fontWeight: FontWeight.normal,
                               fontSize: 12.5,
                               fontFamily: "Helvetica",
                               color: Colors.black),
                         ))),

                       Padding(
                      padding:  EdgeInsets.only(left:3.0,top:2),
                      child:Row(
                             mainAxisAlignment: MainAxisAlignment
                                 .start,
                             children: <Widget>[
                               widget.items[index].discount_percentage !=
                                   "0" ? Text(
                                 "${CountryInfo.currencySymbol} ${widget.items[index]
                                     .display_you_pay} ",
                                 textAlign: TextAlign
                                     .left,
                                 style: TextStyle(
                                     fontWeight: FontWeight
                                         .bold,
                                     fontSize: 11.5,
                                     fontFamily: "Helvetica",
                                     color: Colors
                                         .black),
                               ) : Center(),
                               Padding(
                                 padding: EdgeInsets
                                     .all(2),
                                 child: Text(
                                   "${CountryInfo.currencySymbol} ${widget.items[index].display_mrp} ",
                                   textAlign: TextAlign
                                       .left,

                                   style: TextStyle(
                                       decoration: widget.items[index].discount_percentage !=
                                           "0"
                                           ? TextDecoration
                                           .lineThrough
                                           : null,
                                       fontWeight: widget.items[index].discount_percentage!=
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
                               Padding(
                                 padding: EdgeInsets
                                     .all(1),
                                 child: Align(
                                   alignment: Alignment
                                       .centerLeft,
                                   child: Text(
                                       widget.items[index].discount_percentage !=
                                           "0"
                                           ? "(${widget.items[index].discount_percentage}% Off)"
                                           : "",
                                       overflow: TextOverflow.ellipsis,
                                       textAlign: TextAlign
                                           .left,
                                       style: TextStyle(
                                           fontWeight: widget.items[index].discount_percentage!=
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
                             ])),
                         widget.items[index].productTag!=null && widget.items[index].productTag!=""?  Padding(
                             padding:  EdgeInsets.only(left:4,top:3),
                             child:Align(
                           alignment:Alignment.centerLeft,
                           child: Container(
                             width: widget.items[index].productTag.length>20?100:65,
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
                                 " ${widget.items[index].productTag}",
                                 overflow: TextOverflow.ellipsis,
                                 textAlign: TextAlign.left,
                                 style: TextStyle(
                                     color: Colors.black,
                                     fontFamily: "Helvetica",
                                     fontSize: 8.5),
                               ),
                             ),
                           ),
                         )):Center(),

                       ],
                     ),

                  );
                }
            ),
          ),
        )),
    );

  }

}
