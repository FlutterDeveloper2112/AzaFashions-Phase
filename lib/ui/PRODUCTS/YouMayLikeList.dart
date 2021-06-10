

import 'dart:io';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguesPatternDesign/patternOne.dart';
import 'package:flutter/material.dart';

class YouMayLikeList extends StatefulWidget {
 List<ChildModelList> childModel;
  String designerImage, designertitle, designDescription, tag, patternName;
  final int id;

  YouMayLikeList(
      {this.designerImage,
        this.designertitle,
        this.tag,
        this.designDescription,
        this.patternName,
        this.childModel,
        this.id});

  @override
  _YouMayLikeListState createState() => _YouMayLikeListState();
}

class _YouMayLikeListState extends State<YouMayLikeList> {


  @override
  Widget build(BuildContext context) {
    return widget.childModel != null && widget.childModel.isNotEmpty ?
    Column(
      children: [
        Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                left: 10, right: 10, top: 20, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              " You May Also Like",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22,
                                  fontFamily: "PlayfairDisplay",
                                  color: Colors.black),
                            ),
                          ))),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                ])),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          height: 400,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.childModel.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return new Container(
                    padding: EdgeInsets.only(
                        top: 20, left: 10, right: 10),
                    width: 210,
                    child: PatternOne(
                      designerImage: widget.childModel[index].image,
                      designertitle: widget.childModel[index].designer_name,
                      sizeList: widget.childModel[index].sizeList,
                      mrp: widget.childModel[index].display_mrp,
                      you_pay: widget.childModel[index].display_you_pay,
                      id: widget.childModel[index].id,
                      discount: widget.childModel[index].discount_percentage,
                      designDescription: widget.childModel[index].name,
                      wishlist: widget.childModel[index].wishlist,
                      productTag: widget.childModel[index].productTag,
                      tag: "horizontalListing",

                    ));
              }),
        )
      ],
    ) :
    Center();
  }

}
