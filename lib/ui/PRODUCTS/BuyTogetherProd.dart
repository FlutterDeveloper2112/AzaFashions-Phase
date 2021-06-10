import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/bloc/CartBloc/CartBloc.dart';
import 'package:azaFashions/models/Cart/CartModel.dart';
import 'package:azaFashions/models/ProductDetail/ProductItemDetail.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'ProductDetails.dart';

class BuyTogetherProd extends StatefulWidget {
  final int id;
  String mrp;
  int bottomSheetIndex;
  ProductItemDetail productDetails;
  String youPay;
  List<ChildModelList> buyTogetherItems;
  static bool checkValue = false;
  bool productSize;
  String displayTotal;
  ChildListingModel model;
  static int count = 0;
  BuyTogetherProd(
      {Key key,
        this.id,
        this.mrp,
        this.productDetails,
        this.youPay,
        this.productSize,
        this.buyTogetherItems,
        this.model,
        this.bottomSheetIndex})
      : super(key: key);

  @override
  ItemDesignState createState() => ItemDesignState();
}

class ItemDesignState extends State<BuyTogetherProd> {
  double amt = 0.0;

  List<CartItems> cartItems = new List<CartItems>();
  CartModel cartModel;
  CustomBottomSheet bottomSheet = CustomBottomSheet();
  bool elementSize = false;


  @override
  void initState() {
    super.initState();
    widget.buyTogetherItems.forEach((element) {
      setState(() {
        element.isSelected = true;
        if(element.sizeList.size.length==1){
          element.sizeList.size[0].isSelectedSize = true;
          element.sizeList.openedSheet = true;
        }
        else{
          element.sizeList.size[0].isSelectedSize = true;
          element.sizeList.openedSheet = true;
        }
        double amt = this.amt +
            double.parse(element.sizeList.size[element.sizeList.index].youPay);
        this.amt = amt;
      });
    });

  }

  String updateTheTotalAMt(String amount) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    String result = (amount.split(".").first).replaceAllMapped(reg, mathFunc);
    // print('$amount -> $result');
    return result;
  }



  @override
  void didUpdateWidget(covariant BuyTogetherProd oldWidget) {
    print("COUNT ${BuyTogetherProd.count}");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.buyTogetherItems == null || widget.buyTogetherItems.isEmpty
        ? Container()
        : Column(children: <Widget>[
      Container(
          width: double.infinity,
          padding:
          EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: Container(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Frequently Bought Together",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                                fontFamily: "PlayfairDisplay",
                                color: Colors.black),
                          ),
                        ))),
                Expanded(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ])),
      new ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(10.0),
        itemCount: widget.buyTogetherItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              buildCard(context, widget.buyTogetherItems[index], index,
                  widget.model.new_model),
              Positioned(
                top: 0,
                left: 0,
                right: 10,
                child: new Align(
                  alignment: Alignment.topLeft,
                  child: new Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                        color: Colors.grey[600], shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: new Text(
                      '${index + 1}',
                      style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
      Divider(
        thickness: 3,
        color: Colors.grey[300],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, top:  amt==0.0?20:5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amt==0.0?"Please select product": "Total",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black45),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, top: 5, right: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amt==0.0?"":  "${CountryInfo.currencySymbol} ${amt}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Container(
                height: 43,
                decoration: BoxDecoration(
                  color: HexColor("#e0e0e0"),
                ),
                child: FlatButton(
                  onPressed: amt!=0.0? () {
                    // print(amt);
                    widget.model.new_model.forEach((element) {
                      if (element.isSelected  && element.sizeList.openedSheet) {
                        element.sizeList.size.forEach((elem) {
                          if (element.sizeList.size.length == 1) {
                            setState(() {
                              elem.isSelectedSize = true;
                              elementSize = true;
                            });
                          }
                          if (elem.isSelectedSize == false) {
                            // return ToastMsg().getFailureMsg(context, "Please select size");
                          } else {
                            setState(() {
                              elementSize = true;
                            });
                            cartItems.add(new CartItems(
                                productId: element.id,
                                sizeId: element
                                    .sizeList.size[element.sizeList.index].id,
                                quantity: 1,
                                parentId: 0));
                            print(cartItems.length);
                            cartModel = new CartModel(
                                pageName: "",
                                attributeId: 0,
                                products: cartItems);
                          }
                        });
                      }
                    });

                    print("Length ${cartItems.length}");

                    if(elementSize==false){
                      ToastMsg().getFailureMsg(context, "Please select size");
                    }
                    else{
                      cartBloc.addCartItems(cartModel);
                    }

                    // if (elementSize == false && widget.productSize==true) {
                    //   ToastMsg().getFailureMsg(context, "Please select size");
                    // } else {
                    //   if (cartItems != null && cartItems.length > 0) {
                    //     if (widget.productSize) {
                    //       cartItems.add(new CartItems(
                    //           productId: widget.id,
                    //           sizeId: widget.productDetails
                    //               .sizes[widget.bottomSheetIndex].id,
                    //           quantity: 1,
                    //           parentId: 0));
                    //       cartModel = new CartModel(
                    //           pageName: "",
                    //           attributeId: 0,
                    //           products: cartItems);
                    //     }
                    //     cartBloc.addCartItems(cartModel);
                    //   }
                    // }
                  }:null ,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.grey[400],
                        width: 1,
                        style: BorderStyle.solid),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: Text(
                    'BUY TOGETHER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: "Helvetica",
                        color: Colors.black,
                        fontSize: 15),
                  ),
                  color: HexColor("#e0e0e0"),
                ),
              )),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      Divider(
        thickness: 3,
        color: Colors.grey[300],
      ),
    ]);
  }

  Card buildCard(BuildContext context, ChildModelList items, int index,
      List<ChildModelList> modelList) {
    // print(items.sizeList.size[items.sizeList.index].display_you_pay);
    return Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _itemDesignModule(
                context, items.id, items.image, items.url, items.productTag, index),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: 5,
                  top: 10,
                ),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      //  padding: EdgeInsets.only(top:5),
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Text("${items.designer_name}",
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.5,
                                        fontFamily: "Helvetica-Condensed",
                                        color: Colors.black)),
                              ),
                              Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        items.isSelected = !items.isSelected;
                                        BuyTogetherProd.count++;
                                        if (items.isSelected == false) {
                                          setState(() {
                                            // if (this.amt.toString().contains(",")) {
                                            //   this.amt = this
                                            //       .amt
                                            //       .toString()
                                            //       .replaceAll(",", "");
                                            // }
                                            double amt = this.amt -
                                                double.parse(items.sizeList
                                                    .size[items.sizeList.index].youPay);
                                            this.amt = amt;
                                            if(items.sizeList.size.length==1){

                                            }
                                            else{
                                              items.sizeList.index = 0;
                                              items.sizeList.openedSheet = false;
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            // if (this.amt.toString().contains(",")) {
                                            //   this.amt = this
                                            //       .amt
                                            //       .toString()
                                            //       .replaceAll(",", "");
                                            // }
                                            double amt = this.amt +
                                                double.parse(items.sizeList
                                                    .size[items.sizeList.index].youPay);
                                            this.amt = amt;
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black87),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: items.isSelected
                                            ? Icon(
                                          Icons.check,
                                          size: 12.0,
                                          color: Colors.white,
                                        )
                                            : Icon(
                                          Icons.check_box_outline_blank,
                                          size: 12.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  items.name,
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12.5,
                                      fontFamily: "Helvetica",
                                      color: HexColor("#646464")),
                                ),
                              )),
                          SizedBox(
                            height: 7,
                          ),
                          Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${CountryInfo.currencySymbol} ${items.sizeList.size[items.sizeList.index].display_you_pay}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.5,
                                      fontFamily: "Helvetica",
                                      color: Colors.black),
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0, top: 5),
                            child: InkWell(
                              onTap: () async {
                                print(items.sizeList.size.length);
                                BuyTogetherProd.count++;
                                if (items.sizeList.size.length > 1) {
                                  await bottomSheet.boughtTogether(context,
                                      "buyTogether", items.sizeList, widget.id);

                                  setState(() {
                                    // double value = 0;
                                    this.amt = 0.0;
                                    double value = 0;

                                    // print("AMOUNT PAY $amt");
                                    widget.model.new_model.forEach((element) {
                                      element.sizeList.size.forEach((elem) {
                                        if (elem.isSelectedSize) {
                                          setState(() {
                                            value =
                                                value + double.parse(elem.youPay);
                                            // print("VALUE $value");
                                          });
                                          element.isSelected = true;
                                        }
                                      });
                                      setState(() {
                                        this.amt = value;
                                      });
                                    });
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      items.sizeList.openedSheet &&  items.sizeList.size[items.sizeList.index]
                                          .isSelectedSize
                                          ? 'Size : ${items.sizeList.size[items.sizeList.index].name}'
                                          : "Please Select Size",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Helvetica",
                                          color:items.sizeList.openedSheet &&  items.sizeList.size[items.sizeList.index]
                                          .isSelectedSize? Colors.black:Colors.red ),
                                    ),
                                  ),
                                  if (items.sizeList.size.length > 1)
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black87,
                                            size: 18,
                                          ),
                                        ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _itemDesignModule(BuildContext context, int id, String img, String url,
      String productTag, int index) {
    return new Container(
      width: 130.0,
      height: 160.0,
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              print(url);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        id: id,
                        image: img,
                        url: url,
                        productTag: productTag,
                      )));
            },
            child: Container(
              width: 130,
              height: 160,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: CachedNetworkImageProvider(img)

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
    );
  }
}
