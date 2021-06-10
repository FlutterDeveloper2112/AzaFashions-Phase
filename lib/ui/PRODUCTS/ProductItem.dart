
import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/models/Listing/SizeList.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  List<Widget> widgetsList;
  String designerImage, designertitle, designDescription, tag, mrp;
  SizeList size;
  int id;

  ProductItem(
      {this.designerImage,
        this.designertitle,
        this.tag,
        this.designDescription,
        this.mrp,
        this.size,
        this.id});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<ProductItem> {
  String imageValue = "";
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _itemDesignModule(context),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: 5,
                  top: 5,
                ),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 120,
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
                                child: Text(
                                  "${widget.designertitle}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      fontFamily: "Helvetica",
                                      color: Colors.black),
                                ),
                              ),
                              Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _value = !_value;
                                        print(_value);
                                        print("${_value} ${widget.designertitle}");
                                      });
                                    },
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black87),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: _value
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
                            height: 5,
                          ),
                          Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.designDescription,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12.5,
                                      fontFamily: "Helvetica",
                                      color: Colors.grey),
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${CountryInfo.currencySymbol} ${widget.mrp}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      // fontFamily: "Helvetica",
                                      color: Colors.black),
                                ),
                              )),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          InkWell(
                            onTap: (){
                               CustomBottomSheet().getChooseSizeBottomSheet(
                                  context,"", widget.size, widget.id,"");
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Size : ${widget.size.size[0].name}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Helvetica",
                                        color: Colors.black),
                                  ),
                                ),
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

  Widget _itemDesignModule(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        width: 120,
        height: 180,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage("${widget.designerImage}")
              //Can use CachedNetworkImage
            ),
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0))),
      ),
    ]);
  }
}
