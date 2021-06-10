
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class AzaPoints extends StatefulWidget {
  List<Widget> widgetsList;
  String designerImage,designertitle,designDescription,tag,patternName;

  AzaPoints({this.designerImage,this.designertitle,this.tag,this.designDescription,this.patternName});

  @override
  _AzaPointsState createState() => _AzaPointsState();
}

class _AzaPointsState extends State<AzaPoints> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {

    return  Column(
      children: <Widget>[
        //DESIGN MODULE
        _itemDesignModule(context),
      ],
    );
  }

//Common Format for Three Content Patterns
  Widget _itemDesignModule(BuildContext context){

    return  Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left:25,right: 25,top: 20,bottom: 20),
          child: Container(
            width: double.infinity,
            height: 280 ,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: new CachedNetworkImageProvider("${widget.designerImage}")
                  //Can use CachedNetworkImage
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0))),
          ),
        ),
        Positioned(
          bottom:-25,
          left: 35,
          right:35,
          child:Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
          child: Container(
            width: double.infinity,
            height: 110,
            color: Colors.white,
            child: Column(
              children:<Widget> [
                Padding(
                  padding: EdgeInsets.only(top:15),
                  child: widget.designDescription=="AZA Loyalty Points"?Text("${widget.designertitle}",textAlign:TextAlign.center,style: TextStyle(fontFamily: "Helvetica",fontWeight:FontWeight.normal,fontSize :22, color: Colors.black),)
                   :Text(" ${CountryInfo.currencySymbol} ${widget.designertitle}",textAlign:TextAlign.center,style: TextStyle(fontFamily: "Helvetica",fontWeight:FontWeight.normal,fontSize :22, color: Colors.black),),
                ),
                Padding(
                  padding: EdgeInsets.only(top:10),
                  child: Text("${widget.designDescription}",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize :15, fontFamily: "PlayfairDisplay",color: Colors.black),),
                )
              ],
            ),
          )),
        )
      ],
    );
  }



}