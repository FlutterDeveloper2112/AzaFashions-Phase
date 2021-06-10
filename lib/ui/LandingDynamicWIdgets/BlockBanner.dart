import 'dart:io';
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/models/LandingPages/FiveBlocks.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FiveBlockItems.dart';

//FIVEBLOCK UI INDICATES ONE INDIVIDUAL IMAGE AND REST WILL BE DISPLAYED IN GRIDVIEW FORMAT

class BlockBanner extends StatefulWidget{
  FiveBlocks fiveBlocks;
  String tag;
  BlockBanner({this.fiveBlocks,this.tag});


  @override
  ItemDesignState createState() => ItemDesignState();
}


class ItemDesignState extends State<BlockBanner>{

  int length=0;

  @override
  void initState() {
    setState(() {
      length= widget.fiveBlocks.blockList.length;
    });

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children:<Widget> [
          widget.fiveBlocks.title!="" ? Container(
              padding: EdgeInsets.only(top:15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                    Expanded(
                        flex: 2,
                        child:Container(
                            padding: EdgeInsets.only(left:5,right: 5),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${widget.fiveBlocks.title.toString().toUpperCase()}", textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: TargetPlatform.iOS!=null?15:16,
                                    fontFamily: "Helvetica",
                                    color: Colors.black),),

                            )
                        )),
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),

                  ]
              )
          ) : Container(),
          InkWell(
            onTap: ()async{
              if(widget.fiveBlocks.blockList[0].url_tag=="landing"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new ChildDynamicLanding(widget.fiveBlocks.blockList[0].url,widget.fiveBlocks.blockList[0].section_heading)));

              }
              else if(widget.fiveBlocks.blockList[0].url_tag=="collection"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new DetailPage(widget.fiveBlocks.blockList[0].section_heading, widget.fiveBlocks.blockList[0].url)));
              }
              else if (widget.fiveBlocks.blockList[0].url_tag == "web_view") {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) =>
                        new WebViewContainer(
                            widget.fiveBlocks.blockList[0].url,
                            widget.fiveBlocks.blockList[0].section_heading, "WEBVIEW")));
              }

              else if(widget.fiveBlocks.blockList[0].url_tag=="external_browser"){
                await launch(widget.fiveBlocks.blockList[0].url);
              }

            },

            child: Container(
              padding: EdgeInsets.only(left:20,right: 20,top: 20,bottom: 20),
              child: Container(
                width: 374,
                height:465/*Platform.isIOS != null?460:435*/,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image:CachedNetworkImageProvider(widget.fiveBlocks.blockList[0].image),

                      //Can use CachedNetworkImage
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0))),
              ),
            ),
          ),

          new StaggeredGridView.countBuilder(
            shrinkWrap: true,
            physics:  NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left:20.0,right:20,top:10),
            crossAxisCount: 4,
            itemCount: widget.fiveBlocks.blockList.length,
            itemBuilder: (BuildContext context, int index) => new Container(
              color: Colors.white,
              child: new Container(
                  child: InkWell(
                    onTap: ()async{
                      if(widget.fiveBlocks.blockList[index].url_tag=="landing"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new ChildDynamicLanding(widget.fiveBlocks.blockList[index+1].url,widget.fiveBlocks.blockList[index+1].section_heading)));

                      }
                      else if(widget.fiveBlocks.blockList[index].url_tag=="collection"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DetailPage(widget.fiveBlocks.blockList[index+1].section_heading, widget.fiveBlocks.blockList[index+1].url)));
                      }
                      else if (widget.fiveBlocks.blockList[0].url_tag == "web_view") {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) =>
                                new WebViewContainer(
                                    widget.fiveBlocks.blockList[index+1].url,
                                    widget.fiveBlocks.blockList[index+1].section_heading, "WEBVIEW")));
                      }

                      else if(widget.fiveBlocks.blockList[index+1].url_tag=="external_browser"){
                        await launch(widget.fiveBlocks.blockList[index+1].url);
                      }


                    },
                    child: FiveBlocktems(
                      designerImage:"${widget.fiveBlocks.blockList[index+1].image}" ,
                      designertitle:"${widget.fiveBlocks.blockList[index+1].section_heading}" ,
                      tag: "",
                      designDescription: "${widget.fiveBlocks.blockList[index+1].section_description}",
                    ),
                  )),
            ),
            staggeredTileBuilder: (int index) =>
            index!=widget.fiveBlocks.blockList.length-1 && index!=widget.fiveBlocks.blockList.length-2?new StaggeredTile.count(2, index.isEven ? 2.5 : 2.5):null,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),

          InkWell(
            onTap: () async{
              if(widget.fiveBlocks.blockList[length-1].url_tag=="landing"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new ChildDynamicLanding(widget.fiveBlocks.blockList[length-1].url,widget.fiveBlocks.blockList[length-1].section_heading)));

              }
              else if(widget.fiveBlocks.blockList[length-1].url_tag=="collection"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new DetailPage("${widget.fiveBlocks.blockList[length-1].section_heading}", widget.fiveBlocks.blockList[length-1].url)));
              }
              else if (widget.fiveBlocks.blockList[length-1].url_tag == "web_view") {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) =>
                        new WebViewContainer(
                            widget.fiveBlocks.blockList[length-1].url,
                            widget.fiveBlocks.blockList[length-1].section_heading, "WEBVIEW")));
              }

              else if(widget.fiveBlocks.blockList[length-1].url_tag=="external_browser"){
                await launch(widget.fiveBlocks.blockList[0].url);
              }


            },

            child: Container(
              padding: EdgeInsets.only(left:20,right: 20,top: 20,bottom: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height:Platform.isIOS != null?240:250,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image:CachedNetworkImageProvider(widget.fiveBlocks.blockList[length-1].image),
                      //Can use CachedNetworkImage
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0))),
              ),
            ),
          ),

        ]);

  }




}
