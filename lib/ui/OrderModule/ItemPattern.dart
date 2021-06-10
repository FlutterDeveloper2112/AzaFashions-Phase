import 'package:azaFashions/bloc/ProfileBloc/OrderBloc.dart';
import 'package:azaFashions/models/Orders/CancelReasonsListing.dart';
import 'package:azaFashions/models/Orders/OrderModel.dart';
import 'package:azaFashions/models/Orders/TrackingDetails.dart';
import 'package:azaFashions/ui/OrderModule/OrderDetail.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemPattern extends StatefulWidget {
  String screen_name,
      order_Date,
      designer_name,
      product_name,
      product_image,
      size_name,
      color_name,
      mrp;
  int order_id;
  List<Model> model;
  String tag;
  String orderStatus;
  String customer_id;

  ItemPattern(
      {this.screen_name, this.order_Date, this.order_id, this.model, this.tag,this.customer_id});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<ItemPattern> {
  bool expanded = false;
  int quantity = 4;
  bool trackDownArrow=false;

  Future<void> refreshData() async {
    if (mounted) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        order_bloc.fetchAllOrderData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // order_bloc.cancelReasons();
    return RefreshIndicator(
        onRefresh: refreshData,
        child: Column(
          children: <Widget>[
            //Order Details
            Padding(
                padding: EdgeInsets.only(
                    left: 5, right: 10, top: 10, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Order Date: ${widget.order_Date}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            fontFamily: "Helvetica",
                            color: Colors.black),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.tag=="DetailScreen"? "Order ID: ${widget.customer_id}": "Order ID: ${widget.customer_id}",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            fontFamily: "Helvetica",
                            color: Colors.black),
                      ),
                    ),
                  ],
                )),
            new ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  left: 10.0, right: 10, top: 15, bottom: 10),
              itemCount: widget.model.length,
              itemBuilder: (BuildContext context, int index) =>
              new Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _itemDesignModule(context, index),
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  color: Colors.white,
                                  child: Column(children: <Widget>[
                                    Container(
                                        height: 125,
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                EdgeInsets.all(2),
                                                child: Align(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: Text(
                                                    "${widget.model[index].designer_name}",
                                                    textAlign:
                                                    TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize: 15,
                                                        fontFamily:
                                                        "Helvetica-Condensed",
                                                        color: Colors
                                                            .black),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.all(2),
                                                child: Align(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: Text(
                                                    "${widget.model[index].product_name}",
                                                    textAlign:
                                                    TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize: 13,
                                                        fontFamily:
                                                        "Helvetica",
                                                        color: Colors
                                                            .black),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.all(2),
                                                child: Align(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: Text(
                                                    "Color: ${widget.model[index].colour_name} | Size: ${widget.model[index].size_name} | Qty: ${widget.model[index].qty}",
                                                    textAlign:
                                                    TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize: 13,
                                                        fontFamily:
                                                        "Helvetica",
                                                        color: Colors
                                                            .black),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(
                                                    top: 5),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      widget.model[index]
                                                          .discount_percentage !=
                                                          "0"
                                                          ? Padding(
                                                        padding:
                                                        EdgeInsets.all(
                                                            2),
                                                        child:
                                                        Align(
                                                          alignment:
                                                          Alignment.centerLeft,
                                                          child:
                                                          Text(
                                                            "${CountryInfo.currencySymbol} ${widget.model[index].display_you_pay} ",
                                                            textAlign:
                                                            TextAlign.left,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 13,
                                                                fontFamily: "Helvetica",
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                      )
                                                          : Center(),
                                                      Padding(
                                                        padding:
                                                        EdgeInsets
                                                            .all(2),
                                                        child: Align(
                                                          alignment:
                                                          Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "${CountryInfo.currencySymbol} ${widget.model[index].display_mrp} ",
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                decoration: widget.model[index].discount_percentage !=
                                                                    "0"
                                                                    ? TextDecoration
                                                                    .lineThrough
                                                                    : null,
                                                                fontWeight: widget.model[index].discount_percentage !=
                                                                    "0"
                                                                    ? FontWeight
                                                                    .normal
                                                                    : FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                13,
                                                                fontFamily:
                                                                "Helvetica",
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        EdgeInsets
                                                            .all(2),
                                                        child: Align(
                                                          alignment:
                                                          Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            widget.model[index].discount_percentage !=
                                                                "0"
                                                                ? "(${widget.model[index].discount_percentage} % Off)"
                                                                : "",
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                fontWeight: widget.model[index].discount_percentage !=
                                                                    "0"
                                                                    ? FontWeight
                                                                    .normal
                                                                    : FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                12,
                                                                fontFamily:
                                                                "Helvetica",
                                                                color: Colors
                                                                    .red[400]),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              widget.model[index]
                                                  .item_status ==
                                                  "CANCELED"
                                                  ? Padding(
                                                padding: EdgeInsets.only(left:3,
                                                    right:
                                                    10,
                                                    top: 7,
                                                    bottom:
                                                    2),
                                                child:
                                                Align(
                                                  alignment:
                                                  Alignment
                                                      .centerLeft,
                                                  child:
                                                  Text(
                                                    "ITEM CANCELLED",
                                                    textAlign:
                                                    TextAlign.left,
                                                    style: TextStyle(

                                                        fontSize:
                                                        13,
                                                        fontWeight: FontWeight.normal,
                                                        fontFamily: "Helvetica",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              )
                                                  : Center(),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  widget.model[index].can_cancel && widget.tag !="DetailScreen"
                                                      ? Padding(
                                                      padding: EdgeInsets.only(
                                                          right:
                                                          10,
                                                          top: 7,
                                                          bottom:
                                                          3),
                                                      child:
                                                      InkWell(
                                                        onTap:
                                                            () async {

                                                          await CustomBottomSheet().cancelItem(
                                                              context,
                                                              widget.model[index].qty,
                                                              widget.order_id,
                                                              widget.model[index].item_id);
                                                          refreshData();
                                                        },
                                                        child:
                                                        Align(
                                                          alignment:
                                                          Alignment.centerLeft,
                                                          child:
                                                          Text(
                                                            "CANCEL ITEM",
                                                            textAlign:
                                                            TextAlign.left,
                                                            style: TextStyle(
                                                                decoration: TextDecoration.underline,
                                                                fontSize: 12.5,
                                                                fontWeight: FontWeight.normal,
                                                                fontFamily: "Helvetica",
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                      ))
                                                      : Center(),

                                                  widget.model[index]
                                                      .can_cancel &&
                                                      widget
                                                          .model[
                                                      index]
                                                          .customer_rated
                                                      ? widget.tag !=
                                                      "DetailScreen"
                                                      ? Container(
                                                    padding: EdgeInsets
                                                        .only(
                                                        top: 8),
                                                    width: 2,
                                                    height:
                                                    25,
                                                    child:
                                                    VerticalDivider(
                                                      color: Colors
                                                          .grey[500],
                                                      thickness:
                                                      1,
                                                    ),
                                                  )
                                                      : Center()
                                                      : Center(),
                                                  widget.model[index]
                                                      .customer_rated
                                                      ? widget.tag !=
                                                      "DetailScreen"
                                                      ? Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                        widget.model[index].can_cancel?10:3,
                                                        top:
                                                        13,
                                                        bottom:
                                                        5),
                                                    child:
                                                    Align(
                                                      alignment:
                                                      Alignment.centerLeft,
                                                      child:
                                                      InkWell(
                                                        onTap:
                                                            () {
                                                          CustomBottomSheet().shareFeedback(
                                                              context,
                                                              widget.order_id,
                                                              widget.model[index].item_id);
                                                        },
                                                        child:
                                                        Text(
                                                          "SHARE FEEDBACK",
                                                          textAlign:
                                                          TextAlign.left,
                                                          style: TextStyle(
                                                              decoration: TextDecoration.underline,
                                                              fontSize: 12.5,
                                                              fontWeight: FontWeight.normal,
                                                              fontFamily: "Helvetica",
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                      : Center()
                                                      : Center(),
                                                ],
                                              )
                                            ])),
                                  ])),
                            ),
                            widget.screen_name == "MyOrders"
                                ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: InkWell(
                                    onTap: () {
                                      print(
                                          " Details Screen ${widget.order_id} ${widget.model[index].item_id}");
                                      widget.screen_name ==
                                          "MyOrders"
                                          ? Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder:
                                                  (BuildContext
                                              context) {
                                                return new OrderDetail(
                                                    "OrderDetails",
                                                    widget.order_id,widget.customer_id);
                                              }))
                                          : null;
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 25,
                                      color: Colors.black54,
                                    )),
                              ),
                            )
                                : Center(),
                          ],
                        ),
                      ),
                      widget.orderStatus != "Canceled"
                          ? Container(
                        padding: EdgeInsets.all(5),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey[200],
                        ),
                      )
                          : Center(),

                      widget.size_name=="CUSTOMISE"?Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                    child: Text(
                                      "Customized Measurements",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    color: Colors.grey[350],
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.model[index].root_category_id == 2
                                ? menMeasurement(index)
                                : womenMeasurement(index),
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ):Center(),



                      widget.tag != "DetailScreen" &&
                          widget.model[index].can_track
                          ? InkWell(
                        onTap: () {
                          setState(() {
                            trackDownArrow=true;
                            if (widget.model[index]
                                .isExpanded ==
                                false) {
                              widget.model[index]
                                  .isExpanded = true;
                              print(
                                  "WIDGET ON TAP on index ${widget.model[index]} : ${widget.model[index].isExpanded}");
                            } else {
                              trackDownArrow=false;
                              widget.model[index]
                                  .isExpanded = false;
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Track Your item",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: "Helvetica",
                                        color: Colors.black),
                                  ),
                                )),
                            trackDownArrow==false?Icon(
                              Icons.keyboard_arrow_down,
                              size: 30,
                            ):Icon(
                              Icons.keyboard_arrow_up,
                              size: 30,
                            )
                          ],
                        ),
                      )
                          : Center(),

                      widget.tag != "DetailScreen"
                          ? widget.model[index].isExpanded == true
                          ? itemDeliveryTiles(
                          context,
                          widget.order_id.toString(),
                          widget.model[index].item_id
                              .toString(),
                          widget.model[index].isExpanded)
                          : Center()
                          : Center(),

                      index!=widget.model.length-1?widget.tag == "DetailScreen"
                          ? Center()
                          : Container(
                        padding: EdgeInsets.all(2),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey[200],
                        ),
                      ):Center(),

                      widget.tag != "DetailScreen" &&
                          widget.model[index].can_track?  Container(
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey[200],
                        ),
                      ):Center(),
                    ],
                  )),
            ),

            //Product Details
          ],
        )
    );
  }

  Widget _itemDesignModule(BuildContext context, int index) {
    return Stack(children: <Widget>[
      Container(
        width: 95,
        height: 145,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: CachedNetworkImageProvider(
                    widget.model[index].product_image)
              //Can use CachedNetworkImage
            ),
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0))),
      ),
    ]);
  }

  Widget itemDeliveryTiles(
      BuildContext context, String orderId, String itemId, bool isExpanded) {
    List<TrackItem> itemList = new List<TrackItem>();
    order_bloc.trackItems(context, orderId, itemId);
    return StreamBuilder<TrackingDetails>(
        stream: order_bloc.trackingDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null && snapshot.data.trackItems != null) {
              itemList = snapshot.data.trackItems;
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey[200],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: /* expanded == false ? itemList.length - (itemList.length - 1) :*/ itemList
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            new Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: new Container(
                                width: double.infinity,
                                height: 50.0,
                                color: Colors.transparent,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            itemList[index].description,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                                fontFamily: "Helvetica",
                                                color: Colors.black),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            itemList[index].date,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10,
                                                fontFamily: "Helvetica",
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            new Positioned(
                              top: 2.0,
                              child: new Container(
                                height: 10.0,
                                width: 10.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:itemList[index].status=="1"? Colors.green:Colors.grey[400],
                                ),
                              ),
                            ),
                            itemList.length - 1 != index
                                ? Positioned(
                                top: 2,
                                bottom: 0.0,
                                left: 4.0,
                                child: new Container(
                                  height: double.infinity,
                                  width: 1.0,
                                  color:itemList[index].status=="1"? Colors.green:Colors.grey[400],
                                ))
                                : Center()
                          ],
                        );
                      })
                ],
              );
            } else {
              return Center();
            }
          } else {
            return Center();
          }
        });
  }

  Wrap menMeasurement(int index) {
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 5,
      spacing: 10,
      children: [
        Text(
            "Measurement Unit : ${widget.model[index].customizationModelMen.type},"),
        Text(
            "Shoulder : ${widget.model[index].customizationModelMen.shoulder} ,"),
        Text("Chest : ${widget.model[index].customizationModelMen.chest} ,"),
        Text(
            "Front Shoulder To Waist : ${widget.model[index].customizationModelMen.frontShoulderToWaist} ,"),
        Text("Waist : ${widget.model[index].customizationModelMen.waist} ,"),
        Text("Hip=: ${widget.model[index].customizationModelMen.hip} ,"),
        Text(
            "Arm Length:${widget.model[index].customizationModelMen.armLength} ,"),
        Text(
            "Crotch Depth :${widget.model[index].customizationModelMen.crotchDepth} ,"),
        Text(
            "Waist To Knee :${widget.model[index].customizationModelMen.waistToKnee} ,"),
        Text(
            "Knee Line: ${widget.model[index].customizationModelMen.kneeLine} ,"),
        Text(
            "Neck Circumference: ${widget.model[index].customizationModelMen.neckCircumference} ,"),
        Text(
            "Back Width : ${widget.model[index].customizationModelMen.backWidth} ,"),
        Text(
            "Top Arm Circumference : ${widget.model[index].customizationModelMen.topArmCircumference} ,"),
        Text(
            "Waist To Floor : - ${widget.model[index].customizationModelMen.waistToFloor}"),
        Text(
            "Comments : - ${widget.model[index].customizationModelMen.comment}")
      ],
    );
  }

  Wrap womenMeasurement(int index) {
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 5,
      spacing: 10,
      children: [
        Text(
            "Measurement Unit : ${widget.model[index].customizationModelWomen.type},"),
        Text(
            "Shoulder Length : ${widget.model[index].customizationModelWomen.shoulderLength} ,"),
        Text(
            "Arm Hole : ${widget.model[index].customizationModelWomen.armHole} ,"),
        Text("Bust : ${widget.model[index].customizationModelWomen.bust} ,"),
        Text("Waist : ${widget.model[index].customizationModelWomen.waist} ,"),
        Text("Hips: ${widget.model[index].customizationModelWomen.hips} ,"),
        Text(
            "Sleeve Length:${widget.model[index].customizationModelWomen.sleeveLength} ,"),
        Text("Biceps :${widget.model[index].customizationModelWomen.biceps} ,"),
        Text(
            "Height :${widget.model[index].customizationModelWomen.yourHeight} ,"),
        Text(
            "Front Neck Depth: ${widget.model[index].customizationModelWomen.frontNeckDepth} ,"),
        Text(
            "Back Neck Depth : ${widget.model[index].customizationModelWomen.backNeckDepth} ,"),
        Text(
            "Kurta Length : ${widget.model[index].customizationModelWomen.kurtaLength} ,"),
        Text(
            "Bottom Length : ${widget.model[index].customizationModelWomen.bottomLength} ,"),
        Text(
            "Comments : - ${widget.model[index].customizationModelWomen.comments}")
      ],
    );
  }

}
