import 'dart:io';
import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/bloc/CartBloc/CartBloc.dart';
import 'package:azaFashions/bloc/ProductBloc/SimilarProductBloc.dart';
import 'package:azaFashions/bloc/ProfileBloc/OrderBloc.dart';
import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/models/Cart/CartModel.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/Filters.dart';
import 'package:azaFashions/models/Listing/SortList.dart';
import 'package:azaFashions/models/Orders/CancelReasonsListing.dart';
import 'package:azaFashions/models/Orders/ItemListing.dart';
import 'package:azaFashions/models/ProductDetail/ProductSize.dart';
import 'package:azaFashions/models/Listing/SizeList.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsi_signin.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsu_signup.dart';
import 'package:azaFashions/ui/PRODUCTS/RecentlyViewedCatalogueList.dart';
import 'package:azaFashions/ui/PRODUCTS/SimilarProductList.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import 'ToastMsg.dart';

class CustomBottomSheet {
  BuildContext context;
  int size;
  int itemIndex = 0;
  bool productSelectSize = false;
  bool selectSize = false;
  int sizeIndex = 0;
  int sort_index = 0;
  String filter;
  List fil = [];
  int rating = 0;
  String suggestions = "";
  String sort_value = "", sort_url="";
  Future<bool> saveChanges(context) async {
    bool submit;
    await showModalBottomSheet(
        isDismissible: false,
        context: context,
        backgroundColor: Colors.white,
        builder: (context) {
          return MediaQuery(
            data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              height: 155,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right:10.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.pop(context);
                            } ,
                            child: Icon(
                              Icons.close,
                            ))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              top: 5, right: 10, left: 20, bottom: 10),
                          child: Text(
                            "Are you sure you want to leave this page?",
                            style: TextStyle(
                                fontSize:
                                TargetPlatform.iOS != null
                                    ? 16
                                    : 20,
                                fontFamily: "Helvetica"),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 5, right: 10, left: 20, bottom: 5),
                          child: Text(
                            "Changes  made will be lost.",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Helvetica"),
                          )),
                    ],
                  ),

                  StatefulBuilder(builder: (context,setState){
                    return Padding(
                        padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right: BorderSide(color: Colors.grey),
                                          bottom: BorderSide(color: Colors.grey))),
                                  child: FlatButton(
                                    child: Text(
                                      "ok".toUpperCase(),
                                      style: TextStyle(fontFamily: "Helvetica"),
                                    ),
                                    onPressed: () {
                                      setState((){
                                        submit = true;
                                      });
                                      return Navigator.pop(context,true);
                                    },
                                  ),
                                )),
                            Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right: BorderSide(color: Colors.grey),
                                          bottom: BorderSide(color: Colors.grey))),
                                  child: FlatButton(
                                    child: Text(
                                      "Cancel".toUpperCase(),
                                      style: TextStyle(
                                          color: const Color(0xaaad2810),
                                          fontFamily: "Helvetica"),
                                    ),
                                    onPressed: () {
                                      setState((){
                                        submit = false;
                                      });
                                      return Navigator.pop(context,false);
                                    },
                                  ),
                                )),
                          ],
                        ));
                  })
                ],
              ),
            ),
          );
        });

    return submit;
  }

  Future getDesignerFilterBottomSheet(BuildContext context, List<Filters> filters) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              height: Platform.isIOS?380:350,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 25, top: 10),
                                child: Text("Filter",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        fontFamily: "PlayfairDisplay",
                                        color: Colors.black)),
                              )),
                          Container(
                            padding:
                            EdgeInsets.only(top: 5, right: 10, bottom: 5),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  child: Icon(
                                    Icons.clear,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )),
                          ),
                        ],
                      ),
                      Container(
                        height: 5,
                        padding: EdgeInsets.only(
                            bottom: 5, left: 15, right: 10, top: 10),
                        child: Divider(),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filters[0].items.length,
                          itemBuilder: (context, int index) {
                            FilterItems items = filters[0].items[index];
                            if(items.selected){
                              if(!fil.contains(items.value)){
                                fil.add(items.value);
                                filter= fil.join(",");
                              }
                            }
                            return Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    height: 45,
                                    child: CheckboxListTile(
                                      activeColor: Colors.black87,
                                      checkColor: Colors.white,
                                      value: items.selected,
                                      title: Text(items.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily: "Helvetica",
                                              color: Colors.black,
                                              fontSize: 15)),
                                      controlAffinity:
                                      ListTileControlAffinity.leading,
                                      onChanged: (bool val) {
                                        state(() {
                                          items.selected = !items.selected;
                                          if (items.selected) {
                                            fil.add(items.value);
                                            filter = fil.join(",");
                                          }
                                          else{
                                            fil.remove(items.value);
                                            filter = fil.join(",");
                                            print(fil);
                                          }


                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 5,
                                  padding: EdgeInsets.only(
                                      bottom: 20, left: 15, right: 10),
                                  child: Divider(),
                                ),

                              ],
                            );
                          },
                        ),
                      ),

                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                          child: Container(
                            color: HexColor("#e0e0e0"),
                            width: MediaQuery.of(context).size.width / 1,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'APPLY',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ),)),
                    ],
                  );
                },
              )),
        );
      },
    );
    return filter;
  }

  void getLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) =>MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(2.0),
                  border: new Border.all(color: Colors.grey[400])),
              height: Platform.isIOS?195:185,
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5, right: 10),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                          size: 25,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )),
                ),
                Container(
                    child: new Text("Let's get Personal",textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "PlayfairDisplay",fontSize: 30.0,color: Colors.black),)

                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Sign to sync your devices and shop wherever you are.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Helvetica",
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 10, top: 15),
                          child: Container(

                              width: MediaQuery.of(context).size.width / 3,
                              height: 40,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                padding: const EdgeInsets.all(5.0),
                                textColor: Colors.black,
                                color: HexColor("#e0e0e0"),
                                child: new Text("SIGN IN",
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        color: Colors.black)),
                              ))),
                      Padding(
                          padding: EdgeInsets.only(left: 10, top: 15),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 40,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()),
                                  );
                                },
                                padding: const EdgeInsets.all(5.0),
                                textColor: Colors.black,
                                color: HexColor("#e0e0e0"),
                                child: new Text("REGISTER",
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        color: Colors.black)),
                              ))),
                    ])
              ])),
        ));
  }

  void getShoppingBagBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) =>MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(2.0),
                  border: new Border.all(color: Colors.grey[400])),
              height: Platform.isIOS?180:170,
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5, right: 10),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                          size: 25,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  //width: MediaQuery.of(context).size.width * 0.60,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Please sign in or register to proceed with checkout.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Helvetica",
                          color: Colors.black,

                          fontSize: 18,),
                      ),
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 10, top: 15),
                          child: Container(

                              width: MediaQuery.of(context).size.width / 3,
                              height: 40,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                padding: const EdgeInsets.all(5.0),
                                textColor: Colors.black,
                                color: HexColor("#e0e0e0"),
                                child: new Text("SIGN IN",
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        color: Colors.black)),
                              ))),
                      Padding(
                          padding: EdgeInsets.only(left: 10, top: 15),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 40,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()),
                                  );
                                },
                                padding: const EdgeInsets.all(5.0),
                                textColor: Colors.black,
                                color: HexColor("#e0e0e0"),
                                child: new Text("REGISTER",
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        color: Colors.black)),
                              ))),
                    ])
              ])),
        ));
  }

  void getSimilarProductSheet(BuildContext context, int id) {

    similarBloc.fetchSimilarProducts(id);
    showBottomSheet(
        context: context,
        builder: (context) => MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(2.0),
                  border: new Border.all(color: Colors.grey[400])),
              height: 360,
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Text("Similar Products",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  fontFamily: "PlayfairDisplay",
                                  color: Colors.black)),
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 5, right: 10, bottom: 5),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            child: Icon(
                              Icons.clear,
                              size: 25,
                              color: Colors.black,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )),
                    ),
                  ],
                ),
                StreamBuilder<ChildListingModel>(
                    stream: similarBloc.similarProduct,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {

                        if (snapshot.data?.new_model?.isNotEmpty ?? false) {
                          return Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.new_model.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    ChildModelList items =
                                    snapshot.data.new_model[index];
                                    return new Container(
                                      padding: EdgeInsets.only(
                                          top: 20,
                                          left: 10,
                                          right: 10,
                                          bottom: 5),
                                      width: 180,
                                      height: 250,
                                      child: SimilarProductList(
                                        mrp: items.display_mrp,
                                        id: items.id,
                                        designerImage: "${items.image}",
                                        designertitle: "${items.designer_name}",
                                        designDescription: "${items.name}",
                                        url:"${items.url}",
                                        productTag: "${items.productTag}",
                                      ),
                                    );
                                  }),
                            ),
                          );
                        } else {

                          return Text(
                            "Product Doesn't Exists or is Inactive",
                            style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: "PlayfairDisplay"),
                          );
                          ToastMsg().getLoginSuccess(
                              context, "No Similar Products Found");
                          Navigator.pop(context);
                          return Center();
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
              ])),
        ));
  }

  void getWishListProducts(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(2.0),
                  border: new Border.all(color: Colors.grey[400])),
              height:Platform.isIOS ?450:420,
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Text("Wishlist Products",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  fontFamily: "Helvetica",
                                  color: Colors.black)),
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 5, right: 10, bottom: 5),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            child: Icon(
                              Icons.clear,
                              size: 25,
                              color: Colors.black,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )),
                    ),
                  ],
                ),
                Expanded(
                  child: RecentlyViewCatalogueList(tag: "shoppingBag", patternName: ""),
                )
              ])),
        ));
  }

  Future<String> getSortByBottomSheet(SortList sortList, String query, BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),

              height:60*sortList.sort.length.toDouble(),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 25, top: 10,bottom:5),
                                child: Text("Sort By",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: Platform.isIOS?20:18,
                                        fontFamily: "PlayfairDisplay",
                                        color: Colors.black)),
                              )),
                          Container(
                            padding:
                            EdgeInsets.only(top: 5, right: 10, bottom: 5),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  child: Icon(
                                    Icons.clear,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )),
                          ),
                        ],
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: sortList.sort.map<Widget>(
                              (data) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  height: 5,
                                  padding: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                    bottom: 10,
                                    top: 10,
                                  ),
                                  child: Divider(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Container(
                                    height:40,
                                    child: RadioListTile(

                                        title:Text(
                                          data.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: Platform.isIOS?15:13.5,
                                              fontFamily: "Helvetica",
                                              color: Colors.black),
                                        ),
                                        activeColor: Colors.black,
                                        groupValue: sort_index,
                                        value: data.order,
                                        onChanged: (val) {
                                          state(() {
                                            sort_index = data.order;
                                            sort_value = data.field;
                                            sort_url=data.url;
                                          });
                                          Navigator.of(context).pop();
                                        }),
                                  ),
                                )
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  );
                },
              )),
        );
      },
    );
    return sort_value;
  }
  Future<String> getCelebSortByBottomSheet(SortList sortList, String query, BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),

              height:80*sortList.sort.length.toDouble(),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 25, top: 10,bottom:5),
                                child: Text("Sort By",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: Platform.isIOS?20:18,
                                        fontFamily: "PlayfairDisplay",
                                        color: Colors.black)),
                              )),
                          Container(
                            padding:
                            EdgeInsets.only(top: 5, right: 10, bottom: 5),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  child: Icon(
                                    Icons.clear,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )),
                          ),
                        ],
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: sortList.sort.map<Widget>(
                              (data) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  height: 5,
                                  padding: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                    bottom: 10,
                                    top: 10,
                                  ),
                                  child: Divider(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Container(
                                    height:40,
                                    child: RadioListTile(

                                        title:Text(
                                          data.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: Platform.isIOS?15:13.5,
                                              fontFamily: "Helvetica",
                                              color: Colors.black),
                                        ),
                                        activeColor: Colors.black,
                                        groupValue: sort_index,
                                        value: data.order,
                                        onChanged: (val) {
                                          state(() {
                                            sort_index = data.order;
                                            sort_value = data.field;
                                            sort_url=data.url;
                                          });
                                          Navigator.of(context).pop();
                                        }),
                                  ),
                                )
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  );
                },
              )),
        );
      },
    );
    return sort_value;
  }



  void updateSizeColor(int id, int value, StateSetter setState) {
    setState(() {
      itemIndex = value;
      size = id;
      selectSize = true;
      sizeIndex = value;
    });
  }

  void updateProductSizeColor(int id, int value, StateSetter setState) {
    setState(() {
      itemIndex = value;
      size = id;
      productSelectSize = true;
      sizeIndex = value;
    });
  }

  ///To be used
  Future<void> boughtTogether(
      BuildContext context, String tag, SizeList sizeList, int id) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
              height: MediaQuery.of(context).size.height / 3.5,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 5, top: 10),
                                      child: Text("Choose Your Size",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: TargetPlatform.iOS != null
                                                  ? 16
                                                  : 20,
                                              fontFamily: "PlayfairDisplay",
                                              color: Colors.black)),
                                    )),
                                Container(
                                  padding:
                                  EdgeInsets.only(top: 5, right: 10, bottom: 5),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        child: Icon(
                                          Icons.clear,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      )),
                                ),
                              ],
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: List<Widget>.generate(sizeList.size.length,
                                      (int index) {
                                    return Container(
                                      width: sizeList.size[index].name == "CUSTOMISE" ||
                                          sizeList.size[index].name == "FREE SIZE"
                                          ? MediaQuery.of(context).size.width / 3.5
                                          : MediaQuery.of(context).size.width / 6,
                                      height: 40,
                                      child: FlatButton(
                                        onPressed: () {

                                          // sizeList.size.forEach((element) {
                                          //   state((){
                                          //     element.isSelectedSize = false;
                                          //   });
                                          // });
                                          state((){
                                            sizeList.size[index].isSelectedSize=!sizeList.size[index].isSelectedSize;
                                            sizeList.index = index;
                                            sizeList.openedSheet = true;
                                          });
                                          for(int i = 0; i<=sizeList.size.length;i++){
                                            if(index == i){
                                              Navigator.pop(context);
                                            }
                                            else{
                                              state((){
                                                sizeList.size[i].isSelectedSize = false;
                                              });

                                            }
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.grey[300],
                                                width: 1,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(1.0))),
                                        child: Text(
                                          '${sizeList.size[index].name}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: sizeList.size[index].name ==
                                                  "FREE SIZE" ||
                                                  sizeList.size[index].name ==
                                                      "CUSTOMIZE"
                                                  ? 10
                                                  : 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        color:sizeList.openedSheet &&  sizeList.size[index].isSelectedSize
                                            ? Colors.grey[500]
                                            : Colors.transparent,
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    );
                  })),
        );
      },
    );
  }


  Future<void> getChooseSizeBottomSheet(
      BuildContext context,String tag, SizeList sizeList, int id,String source) async {
    CartModel cartModel;

    // selectSize = false;
    // itemIndex= null;
    List<CartItems> cartItems = new List<CartItems>();
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              height: Platform.isIOS?200:180,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 5, top: 10),
                                      child: Text("Choose Your Size",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: TargetPlatform.iOS != null
                                                  ? 16
                                                  : 20,
                                              fontFamily: "Helvetica",
                                              color: Colors.black)),
                                    )),
                                Container(
                                  padding:
                                  EdgeInsets.only(top: 5, right: 10, bottom: 5),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        child: Icon(
                                          Icons.clear,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      )),
                                ),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            width: double.infinity,
                            height: 60,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: sizeList.size.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          top: 10, bottom: 10, left: 10, right: 5),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        height: 50,
                                        child: Container(
                                          // color:size!=null?Colors.green:Colors.transparent,
                                          child: FlatButton(
                                            onPressed: () {
                                              sizeList.size[index].isSelectedSize = !sizeList.size[index].isSelectedSize;
                                              if(sizeList.size[index].isSelectedSize){
                                                updateSizeColor(sizeList.size[index].id, index, state);
                                                state((){
                                                  sizeList.index = index;
                                                });
                                              }
                                              tag=="buyTogether"?Navigator.pop(context):"";
                                            },
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.grey[300],
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(1.0))),
                                            child: Text(
                                              '${sizeList.size[index].name}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            color: index==itemIndex && sizeList.size[index].isSelectedSize
                                                ? Colors.grey[500]
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ));
                                })),
                        tag!="buyTogether"?  Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Container(
                                width: double.infinity,
                                height: 45,
                                child: RaisedButton(
                                  onPressed: () {
                                    if (size != null && selectSize == true) {
                                      cartItems.add(new CartItems(
                                          productId: id,
                                          sizeId: size,
                                          quantity: 1,
                                          parentId: 0));
                                      cartModel = new CartModel(
                                          pageName: "",
                                          attributeId: 0,
                                          products: cartItems);
                                      wishList.removeWishListData(context, id,source);
                                      wishList.removeWishList.listen((event) {
                                        wishList.getWishList();
                                      });

                                      cartBloc.addCartItems(cartModel);

                                      state((){
                                        refreshData();
                                      });


                                      print("DATA of wishlist for cart: $id, $size");

                                      Navigator.pop(context);
                                    }


                                  },
                                  padding: const EdgeInsets.all(8.0),
                                  textColor: Colors.black,
                                  color: Colors.grey[300],
                                  child: new Text("ADD TO BAG",
                                      style: TextStyle(
                                          fontFamily: "Helvetica",
                                          color: Colors.black)),
                                ))):Center()
                      ],
                    );
                  })),
        );
      },
    );

  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 1));

    cartBloc.fetchAllCartItems();
    wishList.getWishList();

  }

  Future<int> chooseProductSizeBottomSheet(
      BuildContext context, List<ProductSize> sizeList, int id) async {
    int sizeIndex;
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              height: MediaQuery.of(context).size.height / 3.5,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 5, top: 10),
                                      child: Text("Choose Your Size",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: TargetPlatform.iOS != null
                                                  ? 16
                                                  : 20,
                                              fontFamily: "PlayfairDisplay",
                                              color: Colors.black)),
                                    )),
                                Container(
                                  padding:
                                  EdgeInsets.only(top: 5, right: 10, bottom: 5),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        child: Icon(
                                          Icons.clear,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      )),
                                ),
                              ],
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children:
                              List<Widget>.generate(sizeList.length, (int index) {
                                return Container(
                                  width: sizeList[index].name == "CUSTOMISE" ||
                                      sizeList[index].name == "FREE SIZE"
                                      ? MediaQuery.of(context).size.width / 3.5
                                      : MediaQuery.of(context).size.width / 6,
                                  height: 40,
                                  child: FlatButton(
                                    onPressed: () {
                                      updateProductSizeColor(sizeList[index].id, index, state);
                                      Navigator.pop(context);
                                      if(sizeList[index].name== "CUSTOMISE") {
                                        /* Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    Customization()));*/
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.grey[300],
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(1.0))),
                                    child: Text(
                                      '${sizeList[index].name}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: sizeList[index].name ==
                                              "FREE SIZE" ||
                                              sizeList[index].name == "CUSTOMIZE"
                                              ? 10
                                              : 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    color: itemIndex == index && productSelectSize == true
                                        ? Colors.grey[500]
                                        : Colors.transparent,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    );
                  })),
        );
      },
    );
    return sizeIndex;
  }

  //DONE BY AJAY
  void getMeasurementBottomSheet(context, String title, String asset) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return MediaQuery(
            data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              color:Colors.white,
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.cancel),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(bottom:10.0),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 20, fontFamily: "Helvetica"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:20,right: 20,top: 15,bottom:10),
                    child: Container(
                      alignment: Alignment.centerRight,
                      width:350,
                      height: height * 0.5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image:CachedNetworkImageProvider(asset),
                            //Can use CachedNetworkImage
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0))),
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }


  void removeItem(context, bool isWishList, int itemid, String productImg,
      int size_id, int qunatity) {
    if (isWishList) {
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) {
            return MediaQuery(
              data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Container(
                padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
                height: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: 5, left: 10, right: 5, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(productImg)
                                    //Can use CachedNetworkImage
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0))),
                            ),
                            Flexible(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 10),
                                            child: Text(
                                              "Remove From Wishlist",
                                              style: TextStyle(
                                                  fontSize: TargetPlatform.iOS != null
                                                      ? 18
                                                      : 22,
                                                  fontFamily: "Helvetica"),
                                            )),
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                                onTap: () => Navigator.pop(context),
                                                child: Icon(
                                                  Icons.close,
                                                ))),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, right: 10, left: 10, bottom: 5),
                                      child: Text(
                                        "Are you sure you want to remove the item from wishlist?",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Helvetica"),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right: BorderSide(color: Colors.grey),
                                          bottom: BorderSide(color: Colors.grey))),
                                  child: FlatButton(
                                    child: Text(
                                      "Cancel".toUpperCase(),
                                      style: TextStyle(fontFamily: "Helvetica"),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                )),
                            Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right: BorderSide(color: Colors.grey),
                                          bottom: BorderSide(color: Colors.grey))),
                                  child: FlatButton(
                                    child: Text(
                                      "Remove".toUpperCase(),
                                      style: TextStyle(
                                          color: const Color(0xaaad2810),
                                          fontFamily: "Helvetica"),
                                    ),
                                    onPressed: () {
                                      wishList.removeWishListData(context, itemid,"");
                                      wishList.removeWishList.listen((event) {
                                        wishList.getWishList();
                                        print("WISHLIST EVENT: ${event.error}");
                                      });


                                      Navigator.pop(context);
                                    },
                                  ),
                                )),
                          ],
                        ))
                  ],
                ),
              ),
            );
          });
    } else {
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) {
            return Container(
              padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
              height: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: 5, left: 10, right: 10, bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(productImg)
                                  //Can use CachedNetworkImage
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0))),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 10),
                                          child: Text(
                                            "Remove From Cart",
                                            style: TextStyle(
                                                fontSize:
                                                TargetPlatform.iOS != null
                                                    ? 18
                                                    : 22,
                                                fontFamily: "Helvetica"),
                                          )),
                                    ),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                            onTap: () => Navigator.pop(context),
                                            child: Icon(
                                              Icons.close,
                                            ))),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, right: 10, left: 10, bottom: 5),
                                    child: Text(
                                      "Are you sure you want to remove the item from Shopping Bag?",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Helvetica"),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(color: Colors.grey),
                                        left: BorderSide(color: Colors.grey),
                                        right: BorderSide(color: Colors.grey),
                                        bottom: BorderSide(color: Colors.grey))),
                                child: FlatButton(
                                  child: Text(
                                    "Cancel".toUpperCase(),
                                    style: TextStyle(fontFamily: "Helvetica"),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              )),
                          Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(color: Colors.grey),
                                        left: BorderSide(color: Colors.grey),
                                        right: BorderSide(color: Colors.grey),
                                        bottom: BorderSide(color: Colors.grey))),
                                child: FlatButton(
                                  child: Text(
                                    "Remove".toUpperCase(),
                                    style: TextStyle(
                                        color: const Color(0xaaad2810),
                                        fontFamily: "Helvetica"),
                                  ),
                                  onPressed: () {
                                    cartBloc.removeItem(itemid, size_id, 1,"");
                                    cartBloc.removeCartList.listen((event) {
                                      cartBloc.fetchAllCartItems();
                                    });

                                    Navigator.pop(context);
                                  },
                                ),
                              )),
                        ],
                      ))
                ],
              ),
            );
          });
    }
  }

  void priceBreakup(
      BuildContext context, List<OrderDetailList> orderDetailList) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        backgroundColor: Colors.white,
        builder: (context) {
          return MediaQuery(
            data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
                padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
                height: 340,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 15, right: 5, top: 15),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "PRICE BREAKDOWN",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      fontFamily: "PlayfairDisplay",
                                      color: Colors.black),
                                ))),
                        Container(
                          padding: EdgeInsets.only(top: 5, right: 10, bottom: 5),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                child: Icon(
                                  Icons.cancel,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey[200],
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                          orderDetailList[0].priceBreakdown.price.length,
                          itemBuilder: (BuildContext context, int index) =>
                          new Container(
                            color: Colors.white,
                            child: new Column(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5, bottom: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "${orderDetailList[0].priceBreakdown.price[index].name}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            fontFamily: "Helvetica",
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        "${CountryInfo.currencySymbol} ${orderDetailList[0].priceBreakdown.price[index].amount}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: orderDetailList[0]
                                                .priceBreakdown
                                                .price[index]
                                                .name ==
                                                "Bag Discount"
                                                ? Colors.green
                                                : Colors.black),
                                      ),
                                    ],
                                  ))
                            ]),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "ORDER TOTAL",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 17,
                                fontFamily: "PlayfairDisplay",
                                color: Colors.black87),
                          ),
                          Text(
                            "${CountryInfo.currencySymbol} ${orderDetailList[0].order_amount}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey[200],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "PAYMENT MODE",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    fontFamily: "PlayfairDisplay",
                                    color: Colors.black87),
                              ),
                              Text("${orderDetailList[0].payment_mode}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black)),
                            ])),
                  ],
                )),
          );
        });
  }

  void shareFeedback(BuildContext context, int orderId,int itemId) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        useRootNavigator: true,
        isDismissible: true,
        builder: (context) {
          return MediaQuery(
            data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
                  return Container(
                      padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
                      height: MediaQuery.of(context).size.height /2.2  +
                          MediaQuery.of(context).viewInsets.bottom,

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 5, top: 10),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Your Last Delivery",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            fontFamily: "PlayfairDisplay",
                                            color: Colors.black),
                                      ))),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 5, right: 15, bottom: 5),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Icon(
                                        Icons.cancel,
                                        size: 25,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 5, bottom: 5),
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey[200],
                              )),
                          Container(
                            padding: EdgeInsets.only(
                                top: 10, left: 20, right: 20),
                            color: Colors.white,
                            height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    "Based on your recent online purchase, how likely are you to recommend us to your friends.",
                                    style:
                                    TextStyle(fontFamily: "Helvetica",
                                        fontSize: 16,
                                        color: HexColor("#666666")),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0,),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5, right: 10),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: SmoothStarRating(
                                                  allowHalfRating: false,
                                                  onRated: (v) {
                                                    state((){
                                                      rating = v.toInt();
                                                    });
                                                  },
                                                  starCount: 10,
                                                  rating: rating.toDouble(),
                                                  size: 31.0,
                                                  filledIconData: (rating > 0)
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  //halfFilledIconData: Icons.blur_on,
                                                  color: Colors.black,
                                                  borderColor: Colors.grey[400],
                                                  spacing: 0
                                              ))),



                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:20,bottom:5,top: 5.0),
                            child: Text(
                              "Do you have any suggestions for improvement.",
                              style:
                              TextStyle(fontFamily: "Helvetica",
                                  fontSize: 16,
                                  color: HexColor("#666666")),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets
                                .only(
                                left: 20,
                                right: 15),
                            child: Container(
                              padding:
                              EdgeInsets.all(
                                  0),
                              height: MediaQuery.of(
                                  context)
                                  .size
                                  .height *
                                  0.09,
                              child:
                              TextFormField(
                                onChanged: (String value){
                                  suggestions = value;
                                },
                                maxLines: 3,
                                decoration:
                                InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Colors
                                          .black),
                                  enabledBorder:
                                  OutlineInputBorder(
                                    borderSide:
                                    BorderSide(
                                        color:
                                        Colors.grey),
                                  ),
                                  focusedBorder:
                                  OutlineInputBorder(
                                    borderSide:
                                    BorderSide(
                                        color:
                                        Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 25),
                              child: Container(
                                  color: HexColor("#e0e0e0"),
                                  width: MediaQuery.of(context).size.width / 1,
                                  height: 40,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      if(rating>0.0){
                                        print("RATING SUGGESTIONGS : $rating $suggestions");
                                        order_bloc.fetchProductShareFeedback(orderId,itemId,rating,suggestions);
                                        order_bloc.productFeedbackList.listen((event) {
                                          if(event.success!=null){
                                            print("PRODUCT FEEDBACK: ${event.success} ${event.error}");
                                            ToastMsg().getLoginSuccess(context," ${event.success}");
                                          }
                                          else{
                                            ToastMsg().getLoginSuccess(context," ${event.error}");
                                          }

                                        });

                                      }

                                      else{
                                        ToastMsg().getFailureMsg(context,"Please rate the product.");
                                      }

                                    },
                                    child: Text(
                                      'SUBMIT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Helvetica",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                  ))),
                        ],
                      ));
                }
            ),
          );
        });
  }

  cancelItem(BuildContext context, int qty, int orderId, int itemId) async {
    CancelReasons reasons;
    //   List<CancelReasons> cancelreasons = listing.cancelReasons;
    int selectedRadio;

    String comment = "";
    int items = qty;
    bool isSelected = false;
    order_bloc.cancelReasons();
    return await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        useRootNavigator: true,
        isDismissible: true,
        builder: (context) {
          return MediaQuery(
            data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: StreamBuilder<CancelReasonsListing>(
                stream: order_bloc.cancelReasonsList,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.active){
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter state) =>  Container(
                        padding: EdgeInsets.only(bottom: Platform.isIOS?20:0),
                        height: MediaQuery.of(context).size.height /2+
                            MediaQuery.of(context).viewInsets.bottom,
                        //height: MediaQuery.of(context).size.height / 1.6,
                        child: Column(

                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding:
                                    EdgeInsets.only(left: 15, right: 5, top: 15),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Reasons To Cancel Item",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              fontFamily: "PlayfairDisplay",
                                              color: Colors.black87),
                                        ))),
                                Container(
                                  padding:
                                  EdgeInsets.only(top: 15, right: 15, bottom: 5),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 30,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      )),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 15, left: 15, top: 10),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                            if (qty > 1)
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 5, top: 15),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Expanded(
                                                child: Text(
                                                  "Number of items to be cancelled :  ",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "Helvetica",
                                                      color: Colors.black87),
                                                ),
                                              ))),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 05, right: 15, top: 15),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border:
                                                Border.all(color: Colors.black)),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                  onTap: () {
                                                    state(() {
                                                      if (items != 1) {
                                                        items--;
                                                      } else {}
                                                    });
                                                  },
                                                ),
                                                Container(
                                                    height: 20,
                                                    child: VerticalDivider(
                                                      color: Colors.black,
                                                      width: 20,
                                                      thickness: 1.0,
                                                    )),
                                                Text(
                                                  "$items",
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                                Container(
                                                    height: 20,
                                                    child: VerticalDivider(
                                                      color: Colors.black,
                                                      width: 20,
                                                      thickness: 1.0,
                                                    )),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                  onTap: () {
                                                    if (items >= qty) {
                                                    } else
                                                      state(() {
                                                        items++;
                                                      });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 10),
                                    child: Divider(
                                      thickness: 2,
                                    ),
                                  ),
                                ],
                              ),
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.cancelReasons.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        RadioListTile(
                                          value: snapshot.data.cancelReasons[index],
                                          groupValue: reasons,
                                          title: Text("${snapshot.data.cancelReasons[index].reason}",style: TextStyle(
                                              fontFamily: "Helvetica",
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: Colors.black),),
                                          onChanged: (val) {
                                            print("Radio Tile pressed $val");
                                            state(() {
                                              isSelected = true;
                                              selectedRadio = index;
                                              snapshot.data.cancelReasons[index].status =
                                              true;
                                              reasons = snapshot.data.cancelReasons[index];
                                              print("$index $isSelected");
                                            });
                                          },
                                          activeColor: Colors.black,
                                          selected:
                                          reasons == snapshot.data.cancelReasons[index],
                                        ),
                                        if (snapshot.data.cancelReasons[index].status && snapshot.data.cancelReasons[index] == reasons)
                                          Padding(
                                            padding:  EdgeInsets.only(
                                                bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: 27,
                                                right: 30,
                                              ),
                                              height:65,
                                              child: TextFormField(
                                                  onChanged: (String val) {
                                                    comment = "";
                                                    comment = val;
                                                  },
                                                  maxLines: 2,
                                                  decoration: new InputDecoration(
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black12,
                                                          width: 1.0),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black12,
                                                          width: 1.0),
                                                    ),
                                                    hintText: 'Reason',
                                                    hintStyle: TextStyle(
                                                        fontFamily: "Helvetica",
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: 15,
                                                        color: Colors.black38),
                                                  )),
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                                child: Container(
                                    color: HexColor("#e0e0e0"),
                                    width: MediaQuery.of(context).size.width / 1,
                                    height: 40,
                                    child:   RaisedButton(
                                      onPressed: () async {
                                        FocusScope.of(context).requestFocus(FocusNode());

                                        print("Reason ${reasons.reason}");
                                        print(" ID ${reasons.id}");
                                        print(" Quantity $items");
                                        print(comment);
                                        if(reasons!=null){
                                          print(" ID ${reasons.id}");
                                          print(" Quantity $items");
                                          print(comment);
                                          CancelReasons reasonsDetails = CancelReasons(
                                              id: reasons.id,reason: reasons.reason, comments: comment, qty: items);
                                          order_bloc.cancelOrderItem(
                                              reasonsDetails, orderId, itemId);
                                          WebEngagePlugin.trackEvent("Cancel Order Item: ${orderId}, ${reasonsDetails}, ${itemId}");
                                          //
                                          Navigator.pop(context);
                                        }
                                        else{
                                          ToastMsg().getFailureMsg(context, "Please select the reason.");
                                        }
                                      },
                                      child: Text(
                                        'SUBMIT',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ))),

                          ],
                        ),
                      ),
                    );
                  }
                  else{
                    return Center(child: CircularProgressIndicator());
                  }
                }
            ),
          );
        });
  }


}
