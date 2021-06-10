import 'dart:io';
import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/ui/Filter/Multiple.dart';
import 'package:azaFashions/ui/Filter/PriceSlider.dart';
import 'package:azaFashions/ui/Filter/Single.dart';
import 'package:azaFashions/models/Listing/Filters.dart';
import 'package:azaFashions/ui/CatalogueDetails/Catlogue.dart';
import 'package:azaFashions/ui/PROFILE/ProfileUI.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class MyFilter extends StatefulWidget {
  final List<Filters> filter;
  static List<FilterModel> filterModel = new List<FilterModel>();
  Map<String, dynamic> result;

  static String modified;
  static bool isClear = false;


  MyFilter({Key key, this.filter, this.result}) : super(key: key);

  FilterScreenState createState() => FilterScreenState();
}

class FilterScreenState extends State<MyFilter> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  int tappedIndex = 0, currentIndex;
  TextEditingController searchController = new TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<FilterItems> searchData = List<FilterItems>();
  RangeValues values;
  int categoriesCount = 0;
  int designerCount = 0;
  int priceCount = 1;
  int discountCount = 0;
  int sizeCount = 0;
  int colorCount = 0;
  int genderCount = 1;
  int deliveryCount = 1;


  @override
  void initState() {
    super.initState();
    analytics.setCurrentScreen(screenName: "Filter Page");
    setState((){
      MyFilter.modified="";
      MyFilter.isClear = false;
    });
    tappedIndex = 0;
    currentIndex = 0;
    values = RangeValues(1, 100);
  }

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width / 3;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async{
        if (MyFilter.modified!="") {

          bool res = await CustomBottomSheet().saveChanges(context);
          if (res) {

            setState(() {
              MyFilter.filterModel = new List<FilterModel>();
              Multiple.selectedItems.clear();
              Multiple.selectedItems = new List<FilterModel>();
              MyFilter.filterModel.clear();
              Single.selectedItems.clear();
              Single.radioItem = "";
              Catalogue.screenVisit=0;
            });
            ;
            Navigator.of(context).pop(false);
          }
        }
        else{
          Navigator.of(context).pop(false);
        }
      },
      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: scaffoldKey,
            appBar: _getAppBar(context),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Row(children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      color: HexColor("#f5f5f5"),
                      padding: EdgeInsets.only(
                        top: 5,
                      ),
                      width: maxWidth,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: widget.filter.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                                onTap: () {
                                  setState(() {
                                    tappedIndex = index;
                                  });
                                },
                                child: new Container(
                                    color:
                                    tappedIndex == index ? Colors.white : null,
                                    padding: EdgeInsets.only(left: 10),
                                    width: maxWidth,
                                    height: 55,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${widget.filter[index].name}",
                                          style: TextStyle(
                                              fontWeight: tappedIndex == index
                                                  ? FontWeight.normal
                                                  : FontWeight.normal,
                                              fontSize: 15.5,
                                              fontFamily: "Helvetica",
                                              color: Colors.black),
                                        ))));
                          }),
                    ),
                  ),
                  getSelectedWidgetItems(context),
                ]),
                Container(
                  height: Platform.isIOS ? 70 : 55,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.50,
                                height: MediaQuery.of(context).size.height * 0.065,

                                decoration: BoxDecoration(
                                  color: HexColor("#e0e0e0"),
                                ),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey[400],
                                        width: 1,
                                        style: BorderStyle.solid),
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  onPressed: () async{
                                    if (MyFilter.modified!="") {

                                      bool res = await CustomBottomSheet().saveChanges(context);
                                      if (res) {

                                        setState(() {
                                          MyFilter.filterModel = new List<FilterModel>();
                                          Multiple.selectedItems.clear();
                                          Multiple.selectedItems = new List<FilterModel>();
                                          MyFilter.filterModel.clear();
                                          Single.selectedItems.clear();
                                          Single.radioItem = "";
                                          Catalogue.screenVisit=0;
                                         });
                                        ;
                                        Navigator.of(context).pop(false);
                                      }
                                    }
                                    else{
                                      Navigator.of(context).pop(false);
                                    }
                                 },
                                  child: Text(
                                    'CLOSE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                  color: Colors.transparent,
                                ),
                              ),
                            )),
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.50,
                                height: MediaQuery.of(context).size.height * 0.065,
                                decoration: BoxDecoration(
                                  color: HexColor("#e0e0e0"),
                                ),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey[400],
                                        width: 1,
                                        style: BorderStyle.solid),
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      //MyFilter.isClear=true;
                                      Catalogue.screenVisit++;
                                    });
                                    Navigator.pop(context,true);
                                  },
                                  child: Text(

                                    'APPLY',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                  color: Colors.transparent,
                                ),
                              ),
                            )),

                        //Container(width:0.5,height: MediaQuery.of(context).size.height*0.07, child: VerticalDivider(color: Colors.black45)),
                      ]),
                )
              ],
            )),
      ),
    );
  }

  Widget getSelectedWidgetItems(BuildContext context) {
    if (tappedIndex >= 0) {
      if (widget.filter[tappedIndex].selection == "single") {
        if (Single.selectedItems != null && Single.selectedItems.length > 0) {
          setState(() {
            final index = MyFilter.filterModel.indexWhere((element) =>
            element.parent_id == Single.selectedItems.first.parent_id);
            print("INDEX VALUE: $index");
            if (index != -1) {
              MyFilter.filterModel[index].selectedValue =
                  Single.selectedItems[0].selectedValue;
            } else {
              MyFilter.filterModel.addAll(Single.selectedItems);
            }
          });
          Single.selectedItems.clear();
        }

        return Single(
            items: widget.filter[tappedIndex].items,
            id: widget.filter[tappedIndex].field);
      }
      //Multiple Choice
      else if (widget.filter[tappedIndex].selection == "multiple") {

        return new Multiple(
          items: widget.filter[tappedIndex].items,
          nested: widget.filter[tappedIndex].nested,
          id: widget.filter[tappedIndex].field,
          titleItems: widget.filter[tappedIndex].headings.isNotEmpty
              ? widget.filter[tappedIndex].headings
              : [],
          name: widget.filter[tappedIndex].name,
          isClear: MyFilter.isClear,
        );
      }
      //Price Range
      else if (widget.filter[tappedIndex].selection == 'range') {
        print(double.parse(widget.filter[tappedIndex].max));
        var min = double.parse(widget.filter[tappedIndex].min);
        var max = double.parse(widget.filter[tappedIndex].max);
        return PriceRange(
          id: widget.filter[tappedIndex].field,
          min: min,
          max: max,
        );
      }
    }
    return Container();
  }

  Widget _getAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          Container(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Filter",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 22,
                        fontFamily: "PlayfairDisplay",
                        color: Colors.black),
                  ))),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              CatlogueDesignState.clearData = 0;
              setState(() {
                MyFilter.filterModel = new List<FilterModel>();
                Multiple.selectedItems.clear();
                Multiple.selectedItems = new List<FilterModel>();
                MyFilter.filterModel.clear();
                Single.selectedItems.clear();
                Single.radioItem = "";
                Catalogue.screenVisit=0;
                MyFilter.isClear = true;
                MyFilter.modified="";
              });
              ToastMsg().getLoginSuccess(context, "All Filters Cleared.");

            },
            child: Container(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Clear All",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          fontFamily: "PlayfairDisplay",
                          color: Colors.black),
                    ))),
          ),
        ),
      ],
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,

    );
  }
}
