import 'package:azaFashions/models/Cart/CartListing.dart';
import 'package:azaFashions/ui/SHOPPINGCART/CartPattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ShoppingCart extends StatefulWidget{
  List<CartModelList> orderItemList;
  String tag;
  ShoppingCart(this.tag,this.orderItemList);
  @override
  ItemDesignState createState() => ItemDesignState();
}


class ItemDesignState extends State<ShoppingCart>{

  @override
  Widget build(BuildContext context) {
    return Column(
        children:<Widget> [
          new ListView.builder(
            shrinkWrap: true,
            physics:  NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left:15.0,right: 15,top: 15,bottom: 10),
            itemCount: widget.orderItemList.length,
            itemBuilder: (BuildContext context, int index) => new Container(
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  CartPattern(
                    model: widget.orderItemList[index],
                    tag: "${widget.tag}",
                  ),
                  Container(
                    padding: EdgeInsets.only(top:5,left:5,right: 5,bottom: 5),
                    child: Divider(thickness: 2,color: Colors.grey[200],),
                  )
                ]),
            ),
          ),

        ]);



  }




}
