import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguePatterns/catalogue_patternone.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguePatterns/catalogue_patternthree.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguePatterns/catalogue_patterntwo.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LimitedCollection extends StatefulWidget {
  ListingModel listingModel;
  LimitedCollection(this.listingModel);

  @override
  CatlogueDesignState createState() => CatlogueDesignState();
}

class CatlogueDesignState extends State<LimitedCollection> {
  CustomBottomSheet bottomSheet = new CustomBottomSheet();
  int itemdesignStyle = 1;

  @override
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
                      flex:3,
                      child:Container(
                          child:Align(
                            alignment: Alignment.center,
                            child: Text("New Collections",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:22,fontFamily: "PlayfairDisplay",color: Colors.black),),
                          )
                      )),
                  Expanded(
                    child: Divider(color: Colors.black,),
                  ),
                ]
            )),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 15,top:3),
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Showing ${widget.listingModel.total_records} Styles",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.black),
                    ),
                  )),
            ),
            Container(
              width: 100,
              padding: EdgeInsets.only(right: 10,top:3),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 25,
                      child: IconButton(
                        iconSize: 25,
                        padding: EdgeInsets.all(5),
                        onPressed: () {
                          setState(() {
                            itemdesignStyle = 1;
                          });
                        },
                        icon: Icon(
                          Icons.grid_on,
                          color: itemdesignStyle == 1
                              ? Colors.black
                              : Colors.grey,
                          size: 20,
                        ),
                      )),
                  Container(
                      width: 25,
                      child: IconButton(
                        iconSize: 25,
                        padding: EdgeInsets.all(5),
                        onPressed: () {
                          setState(() {
                            itemdesignStyle = 2;
                          });
                        },
                        icon: Icon(
                          Icons.crop_square,
                          color: itemdesignStyle == 2
                              ? Colors.black
                              : Colors.grey,
                          size: 25,
                        ),
                      )),
                  Container(
                      width: 25,
                      child: IconButton(
                          iconSize: 25,
                          padding: EdgeInsets.all(5),
                          onPressed: () {
                            setState(() {
                              itemdesignStyle = 3;
                            });
                          },
                          icon: Icon(
                            Icons.view_list,
                            color: itemdesignStyle == 3
                                ? Colors.black
                                : Colors.grey,
                            size: 25,
                          ))),
                ],
              ),
            )
          ],
        ),
        buildWidget(widget.listingModel.collectionList),
      ],
    );
  }





  Widget buildWidget(List<ModelList> items) {
    if (itemdesignStyle == 1) {
      return CataloguePatternOne(
        items: items,
      );
    } else if (itemdesignStyle == 2) {
      return CataloguePatternTwo(
        items: items,
      );
    } else if (itemdesignStyle == 3) {
      return CataloguePatternThree(
        items: items,
      );
    }
  }
}




