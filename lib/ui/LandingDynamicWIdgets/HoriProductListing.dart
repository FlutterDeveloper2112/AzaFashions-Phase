
import 'dart:io';

import 'package:azaFashions/models/LandingPages/HoriItemListing.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguesPatternDesign/patternOne.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

//HORIZONTAL PRODUCT LISTING UI INDICATES PRODUCTS(image,name,price,wishlist icon) in LISTVIEW with horizontal scroll

class HoriProductListing extends StatefulWidget {
  HoriItemListing horiItemListing;
  String tag;

  HoriProductListing({this.horiItemListing,this.tag});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<HoriProductListing> {

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return  Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: EdgeInsets.only(left:15,right:15,top:5,bottom: 15),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                    Expanded(
                        flex:widget.horiItemListing.title=="Complete From Your Wishlist"? 3:2,
                        child:Container(
                            child:Align(
                              alignment: Alignment.center,
                              child: Text(" ${widget.horiItemListing.title} ",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:22,fontFamily: "PlayfairDisplay",color: Colors.black),),
                            )
                        )),
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                  ]
              )),
          Container(
            padding: EdgeInsets.only(left:10,right:10,bottom: 5),
            width: double.infinity,
            height: 405,
            child:  CarouselSlider(
              options: CarouselOptions(
                /*height: 400,
                      aspectRatio: 16/9,
                      viewportFraction: 0.55,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,*/
                  height: 490,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  // enlargeCenterPage: true,
                  viewportFraction: 0.55
              ),
              items:widget.horiItemListing.horiList.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return new Container(
                        padding: EdgeInsets.only(top:20,left:10,right:5),
                        width: 210/*Platform.isIOS?(MediaQuery.of(context).size.width*0.65):(MediaQuery.of(context).size.width*0.60)*/,
                        child: PatternOne(
                          designerImage:"${i.image}" ,
                          designertitle:"${i.designer_name}" ,
                          tag: "horizontalListing",
                          designDescription: "${i.name}",
                          mrp: "${i.display_mrp}",
                          id:i.id,
                          wishlist: i.wishlist,
                          discount:i.discount_percentage,
                          you_pay:i.display_you_pay,
                          //  sizeList:widget.horiItemListing.horiList[index].sizeList
                        )
                    );
                  },
                );
              }).toList(),
            ),


            // ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: widget.horiItemListing.horiList.length,
            //     itemBuilder: (BuildContext ctxt, int index) {
            //       return new Container(
            //           padding: EdgeInsets.only(top:20,left:10,right:5),
            //           width: 210/*Platform.isIOS?(MediaQuery.of(context).size.width*0.65):(MediaQuery.of(context).size.width*0.60)*/,
            //           child: PatternOne(
            //               designerImage:"${widget.horiItemListing.horiList[index].image}" ,
            //               designertitle:"${widget.horiItemListing.horiList[index].designer_name}" ,
            //               tag: "horizontalListing",
            //               designDescription: "${widget.horiItemListing.horiList[index].name}",
            //               mrp: "${widget.horiItemListing.horiList[index].display_mrp}",
            //               id:widget.horiItemListing.horiList[index].id,
            //               wishlist: widget.horiItemListing.horiList[index].wishlist,
            //               discount:widget.horiItemListing.horiList[index].discount_percentage,
            //               you_pay:widget.horiItemListing.horiList[index].display_you_pay,
            //             //  sizeList:widget.horiItemListing.horiList[index].sizeList
            //           )
            //       );
            //     }
            // ),
          ),

        ]);
  }
}



















/*
import 'dart:io';

import 'package:azaFashions/models/LandingPages/HoriItemListing.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguesPatternDesign/patternOne.dart';
import 'package:flutter/material.dart';

//HORIZONTAL PRODUCT LISTING UI INDICATES PRODUCTS(image,name,price,wishlist icon) in LISTVIEW with horizontal scroll

class HoriProductListing extends StatefulWidget {
  HoriItemListing horiItemListing;
  String tag;

  HoriProductListing({this.horiItemListing,this.tag});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<HoriProductListing> {

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return  Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
         Container(
              width: double.infinity,
              padding: EdgeInsets.only(left:15,right:15,top:5,bottom: 15),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                    Expanded(
                        flex:widget.horiItemListing.title=="Complete From Your Wishlist"? 3:2,
                        child:Container(
                            child:Align(
                              alignment: Alignment.center,
                              child: Text(" ${widget.horiItemListing.title} ",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:22,fontFamily: "PlayfairDisplay",color: Colors.black),),
                            )
                        )),
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                  ]
              )),
          Container(
            padding: EdgeInsets.only(left:10,right:10,bottom: 5),
            width: double.infinity,
            height: 405,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.horiItemListing.horiList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return new Container(
                      padding: EdgeInsets.only(top:20,left:10,right:5),
                      width: 210*/
/*Platform.isIOS?(MediaQuery.of(context).size.width*0.65):(MediaQuery.of(context).size.width*0.60)*//*
,
                      child: PatternOne(
                          designerImage:"${widget.horiItemListing.horiList[index].image}" ,
                          designertitle:"${widget.horiItemListing.horiList[index].designer_name}" ,
                          tag: "horizontalListing",
                          designDescription: "${widget.horiItemListing.horiList[index].name}",
                          mrp: "${widget.horiItemListing.horiList[index].display_mrp}",
                          id:widget.horiItemListing.horiList[index].id,
                          wishlist: widget.horiItemListing.horiList[index].wishlist,
                          discount:widget.horiItemListing.horiList[index].discount_percentage,
                          you_pay:widget.horiItemListing.horiList[index].display_you_pay,
                        //  sizeList:widget.horiItemListing.horiList[index].sizeList
                      )
                  );
                }
            ),
          ),

        ]);
  }
}
*/
