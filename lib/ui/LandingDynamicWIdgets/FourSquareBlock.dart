
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/models/LandingPages/FiveBlocks.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllBtn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

//GRIDLOCK UI INDICATES ITEMS IN GRIDVIEW FORMAT

class FourSquareBlock extends StatefulWidget{
  FiveBlocks fiveBlocks;
  String tag;
  FourSquareBlock({this.fiveBlocks,this.tag});


  @override
  ItemDesignState createState() => ItemDesignState();
}


class ItemDesignState extends State<FourSquareBlock>{
  @override
  Widget build(BuildContext context) {
    return Column(
        children:<Widget> [
          Container(
              padding: EdgeInsets.only(top:5,bottom: 15,left:15,right:15),
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

          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 1.23,
            padding: const EdgeInsets.all(3.0),
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
            children: new List<Widget>.generate(widget.fiveBlocks.blockList.length, (index) {
              return new GridTile(
                child: InkResponse(
                  child:  Padding(
                          padding: EdgeInsets.only(top: 5,bottom:5,left:5,right:5),
                          child:Container(
                            color:HexColor("#f5f5f5"),
                            width: 10,
                            height: 10,
                            child:
                            FlatButton(
                              onPressed: ()async{
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
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey[300],width: 1,style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(Radius.circular(1.0))
                              ),
                              child: Text('${widget.fiveBlocks.blockList[index].section_heading}', textAlign:TextAlign.center,style: TextStyle(fontFamily: "Helvetica",color: Colors.black),),
                              color: Colors.transparent,),
                          )
                      ),

                  enableFeedback: true,

                ),
              );
            }),
          ),

          widget.fiveBlocks.view_all_title!=""?
          ViewAllBtn(widget.fiveBlocks.view_all_url,widget.fiveBlocks.view_all_urltag,widget.fiveBlocks.view_all_title,"","")
              :Padding(padding: EdgeInsets.all(0)),

        ]);

  }




}
