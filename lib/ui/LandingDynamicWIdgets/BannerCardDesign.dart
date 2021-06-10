import 'dart:io';
import 'package:azaFashions/models/LandingPages/BannerCarousel.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//BANNER IMAGES WITH PAGE VIEW

class BannerCardsDesign extends StatefulWidget {
  BannerList banners;

  BannerCardsDesign(this.banners);

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<BannerCardsDesign> {


  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return _firstDesignModule(context,widget.banners);

}

Widget _firstDesignModule(BuildContext context,BannerList bannerList) {
  return InkWell(
    onTap: () async{
      if(bannerList.url_tag=="landing"){
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (__) => new ChildDynamicLanding(bannerList.url,bannerList.section_heading)));

      }
      else if(bannerList.url_tag=="collection"){
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (__) => new DetailPage("${bannerList.section_heading}",bannerList.url)));
      }
      else if (bannerList.url_tag == "web_view") {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (__) =>
                new WebViewContainer(
                    bannerList.url,
                    bannerList.section_heading, "WEBVIEW")));
      }

      else if(bannerList.url_tag=="external_browser"){
        await launch(bannerList.url);
      }

    },
    child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[

          Container(
            padding: EdgeInsets.only(left:20,right: 20,top: 15,bottom:10),
            child: Container(
              //padding: EdgeInsets.only(value),
              width:374,
               //height: Platform.isIOS != null? 460: 435,
               height:465,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image:CachedNetworkImageProvider(bannerList.image),
                    //Can use CachedNetworkImage
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
            ),
          ),
          Positioned(
              bottom:Platform.isIOS != null?-60:-10,
              left: 18,
              right: 18,
              child:Padding(
                padding: EdgeInsets.only(left:20,right: 20,top: 10,bottom: 15),
                child: Container(
                  width: double.infinity,
                  height: bannerList.designer_description!="" && bannerList.action_text!=""? 150:130,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      bannerList.section_heading!=""? Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text("${bannerList.section_heading}", textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.normal,
                              fontSize: 23,
                              fontFamily: "PlayfairDisplay",
                              color: Colors.black),),
                      ):Padding(padding: EdgeInsets.all(0)),

                      bannerList.designer_description!="" ?Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("${bannerList.designer_description}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14,
                              fontFamily: "Helvetica",
                              color: Colors.black),),
                      ):Padding(padding: EdgeInsets.all(0)),
                      bannerList.action_text!=""? InkWell(

                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("${bannerList.action_text}", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15,
                                fontFamily: "Helvetica",
                                color: Colors.black45),),
                        ),
                      ):Padding(padding: EdgeInsets.all(0)),

                    ],
                  ),

                ),
              )),

        ],

    ),
  );
}
}
