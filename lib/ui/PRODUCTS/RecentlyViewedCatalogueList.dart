import 'dart:io';

import 'package:azaFashions/bloc/ProductBloc/SimilarProductBloc.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguesPatternDesign/patternOne.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:flutter/material.dart';

class RecentlyViewCatalogueList extends StatefulWidget {

  final int id;

  String patternName,tag;
  RecentlyViewCatalogueList(
      {this.id,this.patternName,this.tag});

  @override
  _RecentlyViewCatalogueListState createState() => _RecentlyViewCatalogueListState();
}

class _RecentlyViewCatalogueListState extends State<RecentlyViewCatalogueList> {
  ChildListingModel items=new ChildListingModel();
  void initState() {
    similarBloc.fetchRecentProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: similarBloc.recentlyViewed,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              items = snapshot.data;
             if(items.new_model!=null && items.new_model.isNotEmpty && items.new_model.length-1>0){
               return Column(
                 children: [
                   widget.patternName != ""
                       ? Container(
                       width: double.infinity,
                       padding: EdgeInsets.only(
                           left: 10, right: 10, top: 10, bottom: 10),
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
                     padding: EdgeInsets.only(left: 10, right: 10,),
                     width: double.infinity,
                     height: 460,
                     child: ListView.builder(
                         scrollDirection: Axis.horizontal,
                         itemCount: items.new_model.length - 1,
                         itemBuilder: (BuildContext ctxt, int index) {
                           return new Container(
                               padding: EdgeInsets.only(
                                   top: 20, left: 10, right: 10),
                               width: 210/*Platform.isIOS?(MediaQuery.of(context).size.width*0.63):(MediaQuery.of(context).size.width*0.58)*/,
                               child: PatternOne(
                                 designerImage: items.new_model[index + 1].image,
                                 designertitle: "${items.new_model[index + 1].designer_name}",
                                 tag: "horizontalListing",
                                 designDescription: "${items.new_model[index + 1].name}",
                                 mrp: "${items.new_model[index + 1].display_mrp}",
                                 discount: "${items.new_model[index + 1].discount_percentage}",
                                 you_pay: "${items.new_model[index + 1].display_you_pay}",
                                 wishlist: items.new_model[index + 1].wishlist,
                                 id:items.new_model[index + 1].id,
                                 sizeList:items.new_model[index + 1].sizeList,
                                 productTag:items.new_model[index + 1].productTag ,
                               ));
                         }),
                   )
                 ],
               );
             }
             else{
               return Center();
             }
              }
            else {
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
