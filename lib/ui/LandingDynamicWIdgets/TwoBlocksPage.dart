
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/models/LandingPages/FiveBlocks.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllBtn.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//TWO BLOCKS UI INDICATES LISTVIEW WITH HORIZONTAL SCROLL INCLUDES IMAGES WITH STACK OF NAME AND SHOP NOW(sho by gender in kids)

class TwoBlocksPage extends StatefulWidget {
  FiveBlocks twoBlocks;

  TwoBlocksPage({this.twoBlocks});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<TwoBlocksPage>{
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
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
                                "${widget.twoBlocks.title}", textAlign: TextAlign.center,
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
          Container(
            padding: EdgeInsets.only(left:10,right:10,top:10,bottom: 15),
            width: double.infinity,
            height: 260,

            child:ListView.builder(
              physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.twoBlocks.blockList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                    onTap: ()async{
                      if(widget.twoBlocks.blockList[index].url_tag=="landing"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new ChildDynamicLanding(widget.twoBlocks.blockList[index].url,widget.twoBlocks.blockList[index].section_heading)));

                      }
                      else if(widget.twoBlocks.blockList[index].url_tag=="collection"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DetailPage( widget.twoBlocks.blockList[index].section_heading, widget.twoBlocks.blockList[index].url)));
                      }
                      else if(widget.twoBlocks.blockList[index].url_tag=="web_view"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new WebViewContainer(widget.twoBlocks.blockList[index].url,widget.twoBlocks.blockList[index].section_heading,"WEBVIEW")));
                      }

                      else if(widget.twoBlocks.blockList[index].url_tag=="external_browser"){
                        await launch(widget.twoBlocks.blockList[index].url);
                      }


                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      /*  width: 185,*/
                        child:Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                              width: MediaQuery.of(context).size.width*0.5 - 15,
                              height: 250,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image:CachedNetworkImageProvider(widget.twoBlocks.blockList[index].image)
                                    //Can use CachedNetworkImage
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0))),
                            ),

                        Positioned(
                          bottom:0,
                          child: Container(
                            color: Colors.white,
                            width: 120,
                            height: 40,
                            child: Column(
                              children:<Widget> [
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: Text("${widget.twoBlocks.blockList[index].section_heading}",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize :18, fontFamily: "PlayfairDisplay",color: Colors.black),),
                                ),

                              ],
                            ),

                          ),
                        ),

                      ],
                    )),
                  );
                }
            ),
          ),
          widget.twoBlocks.view_all_title!=""?
          ViewAllBtn(widget.twoBlocks.view_all_url,widget.twoBlocks.view_all_urltag,widget.twoBlocks.view_all_title,"",widget.twoBlocks.title)
              :Padding(padding: EdgeInsets.all(0)),
          // ListView.builder() shall be used here.
        ]);
  }
}
