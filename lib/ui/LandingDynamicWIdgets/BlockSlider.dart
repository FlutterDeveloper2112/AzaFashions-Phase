
import 'dart:io';

import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/models/LandingPages/FiveBlocks.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//BLOCK SLIDER INDICATES LISTVIEW with HORIZONTAL SCROLL includes IMAGES,HEADING and SUBHEADING

class BlockSlider extends StatefulWidget {
  FiveBlocks fiveBlocks;
  String tag;

  BlockSlider({this.fiveBlocks,this.tag});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<BlockSlider> {

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
         widget.fiveBlocks.title!= null? Container(
              width: double.infinity,
              padding: EdgeInsets.only(left:15,right:15,bottom: 15),
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

          Container(
              padding: EdgeInsets.only(left:10,right:10,bottom: 15,top:10),
              width: double.infinity,
              height:295,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.fiveBlocks.blockList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Container(
                        padding: EdgeInsets.only(left:10,right:10),
                        width: 230,
                        height: 350,
                        child: Column(
                          children: [
                            Expanded(
                              child:  _itemDesignModule(context,index),
                            ),

                          ],
                        )
                    );
                  }
              )),
        ]);
  }
  Widget _itemDesignModule(BuildContext context,int index) {
    return InkWell(
      onTap: ()async{
        if(widget.fiveBlocks.blockList[index].url_tag=="landing"){
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (__) => new ChildDynamicLanding(widget.fiveBlocks.blockList[index].url,widget.fiveBlocks.blockList[index].section_heading)));

        }
        else if(widget.fiveBlocks.blockList[index].url_tag=="collection"){
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (__) => new DetailPage(widget.fiveBlocks.blockList[index].section_heading, widget.fiveBlocks.blockList[index].url)));
        }
        else if (widget.fiveBlocks.blockList[index].url_tag == "web_view") {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (__) =>
                  new WebViewContainer(
                      widget.fiveBlocks.blockList[index].url,
                      widget.fiveBlocks.blockList[index].section_heading, "WEBVIEW")));
        }

        else if(widget.fiveBlocks.blockList[index].url_tag=="external_browser"){
          await launch(widget.fiveBlocks.blockList[index].url);
        }


      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image:CachedNetworkImageProvider(widget.fiveBlocks.blockList[index].image),
                  //Can use CachedNetworkImage
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0))),
          ),
          Positioned(
              bottom:-70,
              left: 10,
              right:10,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  height: widget.fiveBlocks.blockList[index].section_sub_heading!=""|| widget.fiveBlocks.blockList[index].action_text!=""?135: 105,
                  color: Colors.white,
                  child: Column(
                    children:<Widget> [
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: Text("${widget.fiveBlocks.blockList[index].section_heading}",textAlign:TextAlign.center,maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontWeight:FontWeight.normal,fontSize :16, fontFamily: "PlayfairDisplay",color: Colors.black),),
                      ),

                      widget.fiveBlocks.blockList[index].section_sub_heading!=""?Padding(
                        padding: EdgeInsets.only(left:3,right:3,top:5),
                        child: Text("${widget.fiveBlocks.blockList[index].section_sub_heading}",textAlign:TextAlign.center,style: TextStyle(fontSize :13.5, fontFamily: "Helvetica",color: Colors.black45),),
                      ):Padding(padding: EdgeInsets.all(0)),
                      widget.fiveBlocks.blockList[index].action_text!=""? InkWell(

                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("${widget.fiveBlocks.blockList[index].action_text}", textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15,
                                fontFamily: "Helvetica",
                                color: Colors.black45),),
                        ),
                      ):Padding(padding: EdgeInsets.all(0)),

                    ],
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
