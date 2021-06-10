import 'package:azaFashions/models/CelebrityList.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllBtn.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//CELEB BLOCK SLIDER INDICATES LISTVIEW with HORIZONTAL SCROLL includes CELEB IMAGES,HEADING OR SUBHEADING

class CelebBlockSlider extends StatefulWidget {
  CelebrityList celebrityList;
  String tag;

  CelebBlockSlider({this.celebrityList,this.tag});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<CelebBlockSlider> {

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
          Container(
              width: double.infinity,
              padding: EdgeInsets.only(left:15,right:15,top:5,bottom: 15),
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
                              child: Text("Celebrity Style ",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:22,fontFamily: "PlayfairDisplay",color: Colors.black),),
                            )
                        )),
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                  ]
              )),

          Container(
            padding: EdgeInsets.only(left:10,right:10,top:10),
            width: double.infinity,
            height:295,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.celebrityList.celebData.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return new Container(
                      padding: EdgeInsets.only(top:5,left:10,right:10,bottom: 20),
                      width: 240,
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
            widget.celebrityList.view_all_urltag!=""?
            Padding(
              padding: const EdgeInsets.only(top:5,bottom:15.0),
              child: ViewAllBtn(widget.celebrityList.view_all_url,widget.celebrityList.view_all_urltag,widget.celebrityList.view_all_title,"","Celebrity Style"),
            )
                :Padding(padding: EdgeInsets.all(0)),
          
        ]);
  }

  Widget _itemDesignModule(BuildContext context,int index){
    return  InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                  url: widget.celebrityList.celebData[index].product_url,
                  id: widget.celebrityList.celebData[index].product_id,
                  image: widget.celebrityList.celebData[index].product_url,
                )));
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image:CachedNetworkImageProvider(widget.celebrityList.celebData[index].banner_image),

                    //Can use CachedNetworkImage
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
            ),

            Positioned(
              bottom:-65,
              left: 10,
              right:10,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  height: 125,
                  color: Colors.white,
                  child: Column(
                    children:<Widget> [
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: Text("${widget.celebrityList.celebData[index].celebrity_name}",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize :18, fontFamily: "PlayfairDisplay",color: Colors.black),),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left:3,right:3,top:6),
                        child: Text("in ${widget.celebrityList.celebData[index].designer_name}",textAlign:TextAlign.center,style: TextStyle(fontSize :14.5, fontFamily: "Helvetica",color: Colors.black45),),
                      )
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
