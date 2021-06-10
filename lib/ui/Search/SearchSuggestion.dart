import 'dart:io';

import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/ui/BaseFiles/ChildDetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllText.dart';
import 'package:azaFashions/utils/CountryInfo.dart';

import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/models/Search/SearchModel.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/DynamicLandingPage.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchSuggestion extends StatefulWidget {
  final String title;
  final SearchItemList searchItems;
  final ChildListingModel products;
  final String viewAll;
  final String viewAllTitle;

  const SearchSuggestion(
      {Key key,
        this.title,
        this.searchItems,
        this.products,
        this.viewAll,
        this.viewAllTitle})
      : super(key: key);

  @override
  _SearchSuggestionState createState() => _SearchSuggestionState();
}

class _SearchSuggestionState extends State<SearchSuggestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
        ),
        buildTitle(widget.title),
        SizedBox(
          height: 10,
        ),
        widget.title == "Products"
            ? Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          width: double.infinity,
          height: 320,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.products.new_model.length + 1,
              itemBuilder: (context, int listindex) {
                return listindex + 1 !=
                    widget.products.new_model.length + 1
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 160,
                      height:320,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          _itemDesignModule(context, listindex),
                          Container(
                            height: 80,
                            padding:
                            EdgeInsets.only(top: 2, left: 2),
                            width: double.infinity,
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 2),
                                  child: Text(
                                    "${widget.products.new_model[listindex].designer_name}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.normal,
                                        fontSize: 13.5,
                                        fontFamily:
                                        "Helvetica-Condensed",
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 2, bottom: 5),
                                  child: Text(
                                    "${widget.products.new_model[listindex].name}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.normal,
                                        fontSize: 12.5,
                                        fontFamily: "Helvetica",
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.only(bottom: 5),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[
                                        widget
                                            .products
                                            .new_model[
                                        listindex]
                                            .discount_percentage !=
                                            "0"
                                            ? Padding(
                                          padding:
                                          EdgeInsets.all(
                                              2),
                                          child: Align(
                                            alignment: Alignment
                                                .centerLeft,
                                            child: Text(
                                              "${CountryInfo.currencySymbol} ${widget.products.new_model[listindex].display_you_pay} ",
                                              textAlign:
                                              TextAlign
                                                  .left,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  fontSize:
                                                  10.5,
                                                  fontFamily:
                                                  "Helvetica",
                                                  color: Colors
                                                      .black),
                                            ),
                                          ),
                                        )
                                            : Center(),
                                        Padding(
                                          padding:
                                          EdgeInsets.all(2),
                                          child: Align(
                                            alignment: Alignment
                                                .centerLeft,
                                            child: Text(
                                              "${CountryInfo.currencySymbol} ${widget.products.new_model[listindex].display_mrp} ",
                                              textAlign:
                                              TextAlign.left,
                                              style: TextStyle(
                                                  decoration: widget
                                                      .products
                                                      .new_model[
                                                  listindex]
                                                      .discount_percentage !=
                                                      "0"
                                                      ? TextDecoration
                                                      .lineThrough
                                                      : null,
                                                  fontWeight: widget
                                                      .products
                                                      .new_model[
                                                  listindex]
                                                      .discount_percentage !=
                                                      "0"
                                                      ? FontWeight
                                                      .normal
                                                      : FontWeight
                                                      .bold,
                                                  fontSize: 10.5,
                                                  fontFamily:
                                                  "Helvetica",
                                                  color:
                                                  Colors.black),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.all(1),
                                            child: Align(
                                              alignment: Alignment
                                                  .centerLeft,
                                              child: Text(
                                                widget
                                                    .products
                                                    .new_model[
                                                listindex]
                                                    .discount_percentage !=
                                                    "0"
                                                    ? "(${widget.products.new_model[listindex].discount_percentage}% Off)"
                                                    : "",
                                                overflow:
                                                TextOverflow
                                                    .ellipsis,
                                                textAlign:
                                                TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: widget
                                                        .products
                                                        .new_model[
                                                    listindex]
                                                        .discount_percentage !=
                                                        "0"
                                                        ? FontWeight
                                                        .normal
                                                        : FontWeight
                                                        .bold,
                                                    fontSize: 7,
                                                    fontFamily:
                                                    "Helvetica",
                                                    color: Colors
                                                        .red[900]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                )
                    : Padding(
                    padding: EdgeInsets.only(top:3,bottom: 2),
                    child:Center(
                      child: FlatButton(
                        onPressed: () async{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChildDetailPage("SEARCH",SearchModel.url )));

                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black,width: 1,style: BorderStyle.solid),
                            borderRadius: BorderRadius.all(Radius.circular(1.0))
                        ),
                        child: Text('View All', textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:16,fontFamily: "Helvetica",color: Colors.black),),
                        color: Colors.white,),
                    )
                );
              }),
        )
            : buildText(widget.searchItems, context)
      ],
    );
  }

  buildText(SearchItemList itemList, context) {
    print("Url tag: ${itemList.urlTag}");
    return Wrap(
      runSpacing: 15,
      spacing: 15,
      children: List<Widget>.generate(itemList.searchItems.length, (int index) {
        return InkWell(
          onTap: () async {
            if (itemList.urlTag == "landing") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (__) => new DynamicLandingPage(
                          itemList.searchItems[index].url,
                          itemList.searchItems[index].name)));
            } else if (itemList.urlTag == "collection") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (__) => new DetailPage(
                          itemList.searchItems[index].name,
                          itemList.searchItems[index].url)));
            } else if (itemList.urlTag == "web_view") {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (__) => new WebViewContainer(
                          itemList.searchItems[index].url,
                          itemList.searchItems[index].name,
                          "WEBVIEW")));
            } else {
              await launch(itemList.searchItems[index].url);
            }
          },
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[350],
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(
              itemList.searchItems[index].name,
              style: TextStyle(fontFamily: "Helvetica", color: Colors.black),
            ),
          ),
        );
      }),
    );
  }

  Row buildTitle(String title) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Expanded(
        child: Divider(
          color: Colors.black,
        ),
      ),
      Expanded(
          flex: 1,
          child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: "PlayfairDisplay",
                      color: Colors.black),
                ),
              ))),
      Expanded(
        child: Divider(
          color: Colors.black,
        ),
      ),
    ]);
  }

  Widget _itemDesignModule(BuildContext context, int index) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetail(
                    id: widget.products.new_model[index].id,
                    image: widget.products.new_model[index].image,
                  )));
        },
        child: Container(
          width: 160,
          height: 230,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: new CachedNetworkImageProvider(
                      widget.products.new_model[index].image)
                //Can use CachedNetworkImage
              ),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0))),
        ),
      ),
    ]);
  }
}
