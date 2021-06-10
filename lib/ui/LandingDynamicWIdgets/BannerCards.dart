import 'dart:io';

import 'package:azaFashions/models/LandingPages/BannerCarousel.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/BannerCardDesign.dart';
import 'package:flutter/material.dart';

import 'ViewAllBtn.dart';

//BANNER IMAGES WITH PAGE VIEW

class BannerCards extends StatefulWidget {
  BannerCarousel banners;
  String designerImage, designertitle, designDescription, tag,patternName;

  BannerCards({this.banners});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<BannerCards> {

  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            widget.banners.title!= ""? Container(
                width: double.infinity,
                padding: EdgeInsets.only(left:15,right:15,top:5,bottom: 12),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Divider(color: Colors.black,),
                      ),
                      Expanded(
                          flex:2,
                          child:Container(
                              child:Align(
                                alignment: Alignment.center,
                                child: Text(" ${widget.banners.title} ",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:22,fontFamily: "PlayfairDisplay",color: Colors.black),),
                              )
                          )),
                      Expanded(
                        child: Divider(color: Colors.black,),
                      ),
                    ]
                )):Padding(padding: EdgeInsets.all(0)),
            //HEADER
            Container(
              width: double.infinity,
              height: widget.banners.bannerList.length.toDouble()*465/*Platform.isIOS != null? widget.banners.bannerList.length.toDouble()*460: widget.banners.bannerList.length.toDouble()*435*/,
              child:ListView.builder(
                scrollDirection: Axis.vertical,
               physics: NeverScrollableScrollPhysics(),
              itemCount: widget.banners.bannerList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return new Container(
                padding: EdgeInsets.only(top:5),
                width: 374,
                height:465/*Platform.isIOS != null?460:435*/,
                child: Column(
                  children: [
                    Expanded(
                      child:  BannerCardsDesign(widget.banners.bannerList[index]),
                    ),

                  ],
                )
            );
          }
      ),

            ),
            widget.banners.view_all_urltag!=""?
            Padding(
              padding: const EdgeInsets.only(top:5,bottom:15.0),
              child: ViewAllBtn(widget.banners.view_all_url,widget.banners.view_all_urltag,widget.banners.view_all_title,"",widget.banners.title),
            )
                :Padding(padding: EdgeInsets.all(0)),

             ]);

  }


}
