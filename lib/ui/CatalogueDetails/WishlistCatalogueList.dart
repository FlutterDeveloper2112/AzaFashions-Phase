
import 'dart:io';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/models/Profile/WishList.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguesPatternDesign/patternOne.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:flutter/material.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class WishlistCatalogueList extends StatefulWidget {

  String designerImage, designertitle, designDescription, tag, patternName;
  final int id;

  WishlistCatalogueList(
      {this.designerImage,
        this.designertitle,
        this.tag,
        this.designDescription,
        this.patternName,
        this.id});

  @override
  _WishlistCatalogueListState createState() => _WishlistCatalogueListState();
}

class _WishlistCatalogueListState extends State<WishlistCatalogueList> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  List<WishList> wishListItems = [];
  void initState() {
    WebEngagePlugin.trackScreen("Complete the Wishlist Screen");
    analytics.setCurrentScreen(screenName: "Wishlist");
    wishList.getWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: wishList.wishList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              wishListItems = snapshot.data.list;
              if(wishListItems!=null && wishListItems.isNotEmpty){
                return Column(
                  children: [
                    Padding(padding:EdgeInsets.only(top:widget.patternName != ""?20:60)),
                    widget.patternName != ""
                        ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            left: 10, right: 10,bottom: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                  flex: widget.patternName ==
                                      "Complete From Your Wishlist"
                                      ? 7
                                      : 3,
                                  child: Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          " ${widget.patternName} ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: widget
                                                  .patternName ==
                                                  "Complete From Your Wishlist"
                                                  ? 19
                                                  : 22,
                                              fontFamily: "PlayfairDisplay",
                                              color: Colors.black),
                                        ),
                                      ))),
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                            ]))
                        : Container(),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: double.infinity,
                      height: 435,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:wishListItems.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return new Container(
                                padding: EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                width: 210/*Platform.isIOS?(MediaQuery.of(context).size.width*0.62):(MediaQuery.of(context).size.width*0.58)*/,
                                child: PatternOne(designDescription: wishListItems[index].name,
                                  designerImage
                                      : wishListItems[index].url,
                                  designertitle
                                      : wishListItems[index]
                                      .designerName,
                                  tag:  "shoppingBag",
                                  mrp:  wishListItems[index]
                                      .display_mrp,
                                  discount: wishListItems[index].discount,
                                  you_pay: wishListItems[index]
                                      .display_you_pay,
                                  wishlist:true,
                                  id:  wishListItems[index].id,
                                  sizeList:  wishListItems[index].sizeList,
                                ));
                          }),
                    )
                  ],
                );
              }
              else{
                return Center();
              }

            } else {
              return widget.tag == "home" || widget.tag == "shoppingBag"
                  ? Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "NO ITEMS FOUND!",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: "Helvetica",
                      color: Colors.black),
                ),
              )
                  : Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  child: ErrorPage(
                    appBarTitle: "Your wishlist is empty",
                  ));
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
