
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguesPatternDesign/patternThree.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class ChildCataloguePatternThree extends StatelessWidget{
  final List<ChildModelList> items;
  ChildCataloguePatternThree({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemDesignPage(items: items,);
  }
}

class ItemDesignPage extends StatefulWidget{
  final List<ChildModelList> items;
  ItemDesignPage({Key key, this.items}) : super(key: key);
  @override
  ItemDesignState createState() => ItemDesignState();
}



class ItemDesignState extends State<ItemDesignPage>{
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Column(
        children:<Widget> [
          new ListView.builder(
            shrinkWrap: true,
            physics:  NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(10.0),
            itemCount:widget.items.length,
            itemBuilder: (BuildContext context, int index) => new Container(
              color: Colors.transparent,
              child: new Container(
                  child: PatternThree(
                    id:widget.items[index].id,
                    designerImage:"${widget.items[index].image}" ,
                    designertitle:"${widget.items[index].designer_name}" ,
                    url:"${widget.items[index].url}",
                    tag: "",
                    designDescription: "${widget.items[index].name}",
                    mrp:"${widget.items[index].display_mrp}" ,
                    sizeList: widget.items[index].sizeList,
                    wishlist:widget.items[index].wishlist,
                    discount:widget.items[index].discount_percentage,
                    you_pay:widget.items[index].display_you_pay,
                    productTag: widget.items[index].productTag,
                  )),
            ),
          ),
        ]);
  }




}
