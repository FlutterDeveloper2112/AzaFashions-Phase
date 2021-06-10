import 'dart:io';
import 'package:azaFashions/models/LandingPages/BannerCarousel.dart';
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/BannerCardDesign.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllBtn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FiveBlockItems.dart';

//FIVEBLOCK UI INDICATES ONE INDIVIDUAL IMAGE AND REST WILL BE DISPLAYED IN GRIDVIEW FORMAT

class FiveBlocksPage extends StatefulWidget{
  BannerCarousel fiveBlocks;
  String tag;
  FiveBlocksPage({this.fiveBlocks,this.tag});


  @override
  ItemDesignState createState() => ItemDesignState();
}


class ItemDesignState extends State<FiveBlocksPage>{
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          widget.fiveBlocks.title!= ""? Container(
              width: double.infinity,
              padding: EdgeInsets.only(left:15,right:15,top:5,bottom: 15),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                    Expanded(
                        flex:3,
                        child:Container(
                            child:Align(
                              alignment: Alignment.center,
                              child: Text(" ${widget.fiveBlocks.title} ",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:22,fontFamily: "PlayfairDisplay",color: Colors.black),),
                            )
                        )),
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                  ]
              )):Padding(padding: EdgeInsets.all(0)),
          //HEADER
          InkWell(
              onTap: ()async{
                if(widget.fiveBlocks.bannerList[0].url_tag=="landing"){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (__) => new ChildDynamicLanding(widget.fiveBlocks.bannerList[0].url,widget.fiveBlocks.bannerList[0].section_heading)));

                }
                else if(widget.fiveBlocks.bannerList[0].url_tag=="collection"){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (__) => new DetailPage("${widget.fiveBlocks.bannerList[0].section_heading}", widget.fiveBlocks.bannerList[0].url)));
                }
                else if( widget.fiveBlocks.bannerList[0].url_tag=="web_view"){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (__) => new WebViewContainer(widget.fiveBlocks.bannerList[0].url,widget.fiveBlocks.bannerList[0].section_heading,"WEBVIEW")));
                }

                else if(widget.fiveBlocks.bannerList[0].url_tag=="external_browser"){
                  await launch(widget.fiveBlocks.bannerList[0].url);
                }


              },
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                height: 465/*Platform.isIOS != null?460:435*/,
                child: BannerCardsDesign(widget.fiveBlocks.bannerList[0]),
              )
          ),

          new StaggeredGridView.countBuilder(
            shrinkWrap: true,
            physics:  NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left:20.0,right:20,top:10),
            crossAxisCount: 4,
            itemCount: widget.fiveBlocks.bannerList.length-1,
            itemBuilder: (BuildContext context, int index) => new Container(
              color: Colors.white,
              child: new Container(
                  height:465/* Platform.isIOS != null?460:435*/,
                  child: InkWell(
                    onTap: ()async{
                      if(widget.fiveBlocks.bannerList[index+1].url_tag=="landing"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new ChildDynamicLanding(widget.fiveBlocks.bannerList[index+1].url,widget.fiveBlocks.bannerList[index+1].section_heading)));

                      }
                      else if(widget.fiveBlocks.bannerList[index+1].url_tag=="collection"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DetailPage("${widget.fiveBlocks.bannerList[index+1].section_heading}", widget.fiveBlocks.bannerList[index+1].url)));
                      }
                      else if( widget.fiveBlocks.bannerList[index+1].url_tag=="web_view"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new WebViewContainer(widget.fiveBlocks.bannerList[index+1].url,widget.fiveBlocks.bannerList[index+1].section_heading,"WEBVIEW")));
                      }

                      else if(widget.fiveBlocks.bannerList[index+1].url_tag=="external_browser"){
                        await launch(widget.fiveBlocks.bannerList[index+1].url);
                      }



                    },
                    child: FiveBlocktems(
                      designerImage:"${widget.fiveBlocks.bannerList[index+1].image}" ,
                      designertitle:"${widget.fiveBlocks.bannerList[index+1].section_heading}" ,
                      tag: "",
                      designDescription: "${widget.fiveBlocks.bannerList[index+1].section_sub_heading}",
                    ),


                  )),
            ),
            staggeredTileBuilder: (int index) =>
            index!=widget.fiveBlocks.bannerList.length-1?new StaggeredTile.count(2, index.isEven ? 2.5 : 2.5):null,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          widget.fiveBlocks.view_all_title!=""?
          Padding(
            padding: const EdgeInsets.only(bottom:10.0),
            child: ViewAllBtn(widget.fiveBlocks.view_all_url,widget.fiveBlocks.view_all_urltag,widget.fiveBlocks.view_all_title,"",widget.fiveBlocks.title),
          )
              :Padding(padding: EdgeInsets.all(0)),

        ]);
  }




}

