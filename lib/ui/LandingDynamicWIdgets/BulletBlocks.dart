import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/models/LandingPages/FiveBlocks.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllBtn.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';


//BULLET BLOCKS UI INDICATES GRIDVIEW with CIRCLE IMAGE and NAME (Shop by age in kids)
class BulletBlocks extends StatefulWidget {
  FiveBlocks bullet_blocks;
  String tag;
  BulletBlocks({this.bullet_blocks,this.tag});
  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<BulletBlocks> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Padding(
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
                          padding: EdgeInsets.only(left: 5,right: 5),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2.2,
                          height: 30,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "${widget.bullet_blocks.title}", textAlign: TextAlign.center,
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
          padding: EdgeInsets.only(left:5.0,right:5,top:5),
          crossAxisCount: 3,
          itemCount: widget.bullet_blocks.blockList.length,
          itemBuilder: (BuildContext context, int index) => Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child:   InkWell(
                    onTap: () async{
                      print("BULLET BLOCK :${widget.bullet_blocks.blockList[index].url}");
                      if(widget.bullet_blocks.blockList[index].url_tag=="landing"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new ChildDynamicLanding(widget.bullet_blocks.blockList[index].url,widget.bullet_blocks.blockList[index].section_heading)));

                      }
                      else if(widget.bullet_blocks.blockList[index].url_tag=="collection"){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DetailPage(widget.bullet_blocks.blockList[index].section_heading, widget.bullet_blocks.blockList[index].url)));
                      }
                      else if (widget.bullet_blocks.blockList[index].url_tag == "web_view") {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) =>
                                new WebViewContainer(
                                    widget.bullet_blocks.blockList[index].url,
                                    widget.bullet_blocks.blockList[index].section_heading, "WEBVIEW")));
                      }

                      else if(widget.bullet_blocks.blockList[index].url_tag=="external_browser"){
                        await launch(widget.bullet_blocks.blockList[index].url);
                      }


                    },
                    child: Container(
                      width: 85,
                      height:80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image:CachedNetworkImageProvider(widget.bullet_blocks.blockList[index].image),
                          //Can use CachedNetworkImage
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Align(alignment:Alignment.center,child: new Text("${widget.bullet_blocks.blockList[index].section_heading}",maxLines:1,overflow:TextOverflow.ellipsis,textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "Helvetica-Condensed",fontSize: 16.0,color: Colors.black),))
            ],
          ),
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(1,1.2),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        widget.bullet_blocks.view_all_title!=""?
        ViewAllBtn(widget.bullet_blocks.view_all_url,widget.bullet_blocks.view_all_urltag,widget.bullet_blocks.view_all_title,"",widget.bullet_blocks.title)
            :Padding(padding: EdgeInsets.all(0)),




      ],
    );
  }


}
