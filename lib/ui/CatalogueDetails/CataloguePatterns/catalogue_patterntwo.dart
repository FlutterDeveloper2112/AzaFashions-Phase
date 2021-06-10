
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguesPatternDesign/patternTwo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class CataloguePatternTwo extends StatelessWidget{
  final List<ModelList> items;
  CataloguePatternTwo({Key key, this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ItemDesignPage(items: items,);
  }
}

class ItemDesignPage extends StatefulWidget{
  final List<ModelList> items;
  ItemDesignPage({Key key, this.items}) : super(key: key);
  @override
  ItemDesignState createState() => ItemDesignState();
}



class ItemDesignState extends State<ItemDesignPage>{
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  void initState() {
    print("IMAGE TWO: ${widget.items[0].large_image}");
    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height<700?  3.8: 3.5;
    return Column(
        children:<Widget> [
          Container(
              color: Colors.white,
              child:MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Padding(
                  padding: const EdgeInsets.only(left:16,right:15),
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2/height,
                        crossAxisCount: 1,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 20,
                      ),
                      shrinkWrap:true,
                      itemCount: widget.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  Container(
                          // padding: EdgeInsets.only(top:10,bottom:10,left:15,right:15),
                            width: double.infinity,
                            child: PatternTwo(
                              id:widget.items[index].id,
                              designerImage:"${widget.items[index].large_image}" ,
                              designertitle:"${widget.items[index].designer_name}" ,
                              url:"${widget.items[index].url}",
                              tag: "",
                              designDescription: "${widget.items[index].name}",
                              mrp:"${widget.items[index].display_mrp}" ,
                              sizeList: widget.items[index].sizeList,
                              wishlist: widget.items[index].wishlist,
                              discount:widget.items[index].discount_percentage,
                              you_pay:widget.items[index].display_you_pay,
                              productTag: widget.items[index].productTag,
                            ));
                      }
                  ),
                ),
              )),

        ]);
  }




}
