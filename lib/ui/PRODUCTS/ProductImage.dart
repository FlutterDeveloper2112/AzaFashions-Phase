
import 'dart:io';

import 'package:azaFashions/models/ProductDetail/MediaGallery.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductZoom.dart';
import 'package:azaFashions/ui/SHOPPINGCART/ShoppingBag.dart';
import 'package:azaFashions/utils/BagCount.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

import 'ProductDetails.dart';

class ProductImage extends StatefulWidget {
  final List<MediaGallery> items;

  const ProductImage({Key key, this.items}) : super(key: key);

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<ProductImage>
    with SingleTickerProviderStateMixin {
  int totalPages = 0;
  final _currentPageNotifier = ValueNotifier<int>(0);

  void initState() {
    setState(() {
      totalPages = widget.items.length;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      Container(
        width:400,
        height:580/*MediaQuery.of(context).size.height/1.45*/,
        child: PageView.builder(
            onPageChanged: (i) {
              _currentPageNotifier.value = i;
            },
            scrollDirection: Axis.horizontal,
            itemCount: widget.items.length,
            itemBuilder: (BuildContext ctxt, int index) {

            print("IMAGE URL: ${widget.items[index].url}");
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (__) => new ProductZoom(
                              imgList: widget.items,
                            )));
                  },
                  child: Container(
                    width:MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image:CachedNetworkImageProvider(widget.items[index].url)

                          //Can use CachedNetworkImage
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0))),
                  ));
            }),
      ),
      _buildCircleIndicator(),
      Positioned(
          top: 20,
          left:15,
          child:ClipRRect (
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
                height: 30,
                width: 30,
                color: Colors.white,
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        child:InkWell(
                          onTap: (){

                           Navigator.of(context).pop(true);
                          },
                          child: Platform.isAndroid?Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ):Padding(
                            padding: const EdgeInsets.only(left:6.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        )))),
          )
      ),
      Positioned(
          top: 20,
          right:15,
          child:ValueListenableBuilder(
            valueListenable: BagCount.bagCount,
            builder:(context,int index,Widget child)=> BagCount.bagCount.value>0?Badge(
              shape: BadgeShape.circle,
              badgeColor: Colors.black,
              alignment: Alignment.topLeft,
              badgeContent: Text("${BagCount.bagCount.value}",style: TextStyle(
                  color: Colors.white,
                  fontSize:
                  BagCount.wishlistCount.value > 9
                      ? 10
                      : 12)),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (__) => new ShoppingBag()));
                },
                child: ClipRRect (
                  borderRadius: BorderRadius.circular(25.0),
                  child: Container(
                    width:35,
                    height:32,
                    color:Colors.transparent,
                    child: Container(
                        height: 30,
                        width: 28,
                        color: Colors.white,
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                decoration:
                                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom:3.0),
                                  child: Image.asset(
                                    "images/cart_icon.png",
                                    width: 20,
                                    height: 20,),
                                )))),
                  ),
                ),
              ),
            ):ClipRRect (
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                  height: 30,
                  width: 28,
                  color: Colors.white,
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          decoration:
                          BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          child: InkWell(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(builder: (__) => new ShoppingBag()));
                              },
                              child:Padding(
                                padding: const EdgeInsets.only(bottom:3.0),
                                child: Image.asset(
                                  "images/cart_icon.png",
                                  width: 20,
                                  height: 20,),
                              )
                          )))),
            ),
          )
      ),

      // ListView.builder() shall be used here.
    ]);
  }

  _buildCircleIndicator() {
    return
      Padding(
        padding: const EdgeInsets.only(bottom:10),
        child: CirclePageIndicator(
          selectedBorderColor: Colors.black,
          selectedDotColor: Colors.black,
          borderWidth: 1.5,
          dotColor: HexColor("#33000000"),
          itemCount: widget.items.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      );

  }
}
