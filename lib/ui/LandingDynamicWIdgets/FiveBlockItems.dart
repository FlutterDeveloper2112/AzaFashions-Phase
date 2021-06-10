import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FiveBlocktems extends StatefulWidget {
  List<Widget> widgetsList;
  String designerImage, designertitle, designDescription, tag;

  FiveBlocktems(
      {this.designerImage,
        this.designertitle,
        this.tag,
        this.designDescription});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<FiveBlocktems> {
  List<Color> _colors = [Colors.grey[100], Colors.black12];
  List<double> _stops = [0.0, 0.7];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _itemDesignModule(context),
        )
      ],
    );
  }

  Widget _itemDesignModule(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(

            width: double.infinity,
            // height: 210,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image:CachedNetworkImageProvider(widget.designerImage),

                  //Can use CachedNetworkImage
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0))),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height:widget.designDescription!=""?MediaQuery.of(context).size.height*0.095: MediaQuery.of(context).size.height*0.050,
                child: Column(
                  children: <Widget>[
                    Container(
                    //  color:Colors.black12.withOpacity(0.15) ,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "${widget.designertitle}",
                            maxLines:1,
                            overflow:TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                                fontFamily: "PlayfairDisplay",
                                color: Colors.white),
                          ),
                        )),

                    widget.designDescription!=""? Container(
                      //  color:Colors.black12.withOpacity(0.15) ,

                        // padding: EdgeInsets.only(left: 5, top: 5,bottom: 10),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "${widget.designDescription}",
                            maxLines:1,
                            overflow:TextOverflow.ellipsis,

                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                fontFamily: "Helvetica",
                                color: Colors.white),
                          ),
                        )):Center(),
                  ],
                ),
              ),

            ),
          ),

        ]);
  }
}
