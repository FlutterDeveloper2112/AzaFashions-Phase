
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/models/LandingPages/FiveBlocks.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllBtn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FiveBlockItems.dart';

//GRIDLOCK UI INDICATES ITEMS IN GRIDVIEW FORMAT

class GridBlock extends StatefulWidget{
  FiveBlocks fiveBlocks;
  String tag;
  GridBlock({this.fiveBlocks,this.tag});


  @override
  ItemDesignState createState() => ItemDesignState();
}


class ItemDesignState extends State<GridBlock>{
  @override
  Widget build(BuildContext context) {
    return Column(
        children:<Widget> [
            Container(
              padding: EdgeInsets.only(top:15,bottom: 15,left:15,right:15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                    Expanded(
                        flex: 3,
                        child:Container(
                            padding: EdgeInsets.only(left:5,right: 5),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${widget.fiveBlocks.title}", textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.normal,
                                    fontSize:22,
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

          new StaggeredGridView.countBuilder(
            shrinkWrap: true,
            physics:  NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left:20.0,right:20,top:12),
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
                                builder: (__) => new ChildDynamicLanding(widget.fiveBlocks.blockList[index].url,widget.fiveBlocks.blockList[index].section_heading)));

                      }
                      else if(widget.fiveBlocks.blockList[index].url_tag=="collection"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DetailPage( widget.fiveBlocks.blockList[index].section_heading, widget.fiveBlocks.blockList[index].url)));
                      }
                      else if( widget.fiveBlocks.blockList[index].url_tag=="web_view"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new WebViewContainer(widget.fiveBlocks.blockList[index].url,widget.fiveBlocks.blockList[index].section_heading,"WEBVIEW")));
                      }

                      else if(widget.fiveBlocks.blockList[index].url_tag=="external_browser"){
                        await launch(widget.fiveBlocks.blockList[index].url);
                      }

                    },
                    child: FiveBlocktems(
                      designerImage:"${widget.fiveBlocks.blockList[index].image}" ,
                      designertitle:"${widget.fiveBlocks.blockList[index].section_heading}" ,
                      tag: "",
                      designDescription: "${widget.fiveBlocks.blockList[index].section_sub_heading}",
                    ),
                  )),
            ),
            staggeredTileBuilder: (int index) =>new StaggeredTile.count(2, index.isEven ? 2.5 : 2.5),
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),

          widget.fiveBlocks.view_all_title!=""?
          Padding(
            padding: const EdgeInsets.only(bottom:10),
            child: ViewAllBtn(widget.fiveBlocks.view_all_url,widget.fiveBlocks.view_all_urltag,widget.fiveBlocks.view_all_title,"",""),
          )
              :Padding(padding: EdgeInsets.all(0)),

        ]);

  }




}
