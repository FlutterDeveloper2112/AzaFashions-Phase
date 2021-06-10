import 'dart:io';
import 'package:azaFashions/models/LandingPages/BannerCarousel.dart';
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/BannerCardDesign.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

//ONE CATEGORY SLIDER UI INDICATES ONE INDIVIDUAL IMAGE AND REST WILL BE DISPLAYED IN LISTVIEW with horizontal scroll

class OneCategorySlider extends StatefulWidget{
  BannerCarousel categorySlider;
  String tag;
  OneCategorySlider({this.categorySlider,this.tag});


  @override
  ItemDesignState createState() => ItemDesignState();
}


class ItemDesignState extends State<OneCategorySlider>{
  @override
  Widget build(BuildContext context) {
    return Column(
        children:<Widget> [
          Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 20,left:15,right:15,bottom: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                    Expanded(
                        flex:3,
                        child:Container(
                            padding: EdgeInsets.only(left:5,right: 5),
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${widget.categorySlider.title}", textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.normal,
                                    fontSize: 22,
                                    fontFamily: "PlayfairDisplay",
                                    color: Colors.black),),
                            )
                        )),
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                  ]
              )
          ),

          InkWell(
            onTap: ()async{
              if(widget.categorySlider.bannerList[0].url_tag=="landing"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new ChildDynamicLanding(widget.categorySlider.bannerList[0].url,widget.categorySlider.bannerList[0].section_heading)));

              }
              else if(widget.categorySlider.bannerList[0].url_tag=="collection"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new DetailPage(widget.categorySlider.bannerList[0].section_heading, widget.categorySlider.bannerList[0].url)));
              }
              else if(widget.categorySlider.bannerList[0].url_tag=="web_view"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new WebViewContainer(widget.categorySlider.bannerList[0].url,widget.categorySlider.bannerList[0].section_heading,"WEBVIEW")));
              }

              else if(widget.categorySlider.bannerList[0].url_tag=="external_browser"){
                await launch(widget.categorySlider.bannerList[0].url);
              }

            },
            child: Container(
            padding: EdgeInsets.only(bottom: 10),
              height: 465/*Platform.isIOS != null?460:435*/,
            child: BannerCardsDesign(widget.categorySlider.bannerList[0]),
            )

          ),

          Container(
            padding: EdgeInsets.only(left:5,right:5,bottom: 15),
            width: double.infinity,
            height: 340,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categorySlider.bannerList.length-1,
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                    onTap: () async{
                      if(widget.categorySlider.bannerList[index+1].url_tag=="landing"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new ChildDynamicLanding(widget.categorySlider.bannerList[index+1].url,widget.categorySlider.bannerList[index+1].section_heading)));

                      }
                      else if(widget.categorySlider.bannerList[index+1].url_tag=="collection"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DetailPage( widget.categorySlider.bannerList[index+1].section_heading, widget.categorySlider.bannerList[index+1].url)));
                      }
                      else if(widget.categorySlider.bannerList[index+1].url_tag=="web_view"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new WebViewContainer(widget.categorySlider.bannerList[index+1].url,widget.categorySlider.bannerList[index+1].section_heading,"WEBVIEW")));
                      }

                      else if(widget.categorySlider.bannerList[index+1].url_tag=="external_browser"){
                        await launch(widget.categorySlider.bannerList[index+1].url);
                      }



                    },
                    child: new Container(
                        padding: EdgeInsets.only(top:10,left:5,right:5),
                        width: 250,
                        height: 300,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                           Container(
                              padding: EdgeInsets.only(left:5,right: 5,top: 10,bottom: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:Platform.isIOS != null?320:360,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:CachedNetworkImageProvider(widget.categorySlider.bannerList[index+1].image),
                                      //Can use CachedNetworkImage
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0))),
                              ),
                            ),
                            Positioned(
                                bottom:-45,
                                left: 25,
                                right:25,
                                child: Padding(
                                  padding: EdgeInsets.only(top:10,bottom:4,right:5,left:5),
                                  child: Container(
                                    width: double.infinity,
                                    height: widget.categorySlider.bannerList[index+1].section_sub_heading!="" ||widget.categorySlider.bannerList[index+1].action_text!=""?110:90,
                                    color: Colors.white,
                                    child: Column(
                                      children:<Widget> [
                                        Padding(
                                          padding: EdgeInsets.only(top:10),
                                          child: Text("${widget.categorySlider.bannerList[index+1].section_heading}",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize :14.5, fontFamily: "PlayfairDisplay",color: Colors.black),),
                                        ),

                                        widget.categorySlider.bannerList[index+1].section_sub_heading!=""?Padding(
                                          padding: EdgeInsets.only(left:3,right:3,top:5),
                                          child: Text("${widget.categorySlider.bannerList[index+1].section_sub_heading}",textAlign:TextAlign.center,style: TextStyle(fontSize :13.5, fontFamily: "Helvetica",color: HexColor("#707070")),),
                                        ):Padding( padding: EdgeInsets.all(0)),
                                        widget.categorySlider.bannerList[index+1].action_text!=""?Padding(
                                          padding: EdgeInsets.only(left:3,right:3,top:5),
                                          child: Text("${widget.categorySlider.bannerList[index+1].action_text}",textAlign:TextAlign.center,style: TextStyle(fontSize :13.5, fontFamily: "Helvetica",color: HexColor("#707070")),),
                                        ):Padding( padding: EdgeInsets.all(0)),

                                      ],
                                    ),
                                  ),
                                )
                            )
                          ],
                        )
                    ),
                  );
                }
            ),
          ),


        ]);

  }




}
