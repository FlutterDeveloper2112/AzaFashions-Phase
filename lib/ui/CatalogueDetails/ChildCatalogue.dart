
import 'dart:io';
import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/ui/CatalogueDetails/Catlogue.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:azaFashions/ui/Filter/Single.dart';
import 'package:azaFashions/bloc/ListingBloc/ListingDetailBloc.dart';
import 'package:azaFashions/bloc/SearchBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Listing/ChildListingModel.dart';
import 'package:azaFashions/models/Listing/Filters.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/models/Listing/SortList.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguePatterns/child_catalogue_one.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguePatterns/child_catalogue_three.dart';
import 'package:azaFashions/ui/CatalogueDetails/CataloguePatterns/child_catalogue_two.dart';
import 'package:azaFashions/ui/DESIGNER/designerview.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ChildCatalogue extends StatefulWidget {
  String screen;
  String query;
  String sortOption;
  String url;
  static int count;
  int pageLinks;
  final ScrollController controller;
  static int screenVisit=0;

  ChildCatalogue(this.screen, this.url, this.query, this.sortOption, this.pageLinks,
      {this.controller});

  @override
  CatlogueDesignState createState() => CatlogueDesignState();
}

class CatlogueDesignState extends State<ChildCatalogue> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  CustomBottomSheet bottomSheet = new CustomBottomSheet();
  int itemdesignStyle = 1;
  int res = 0;
  bool isLoading = false;

  List pageLinks = [];
  int count = 0;
  List<ChildModelList> model_item = [];
  SortList sortList;
  List<Filters> filters;
  double height;
  static int clearData;
  String errorMessage = "";
  String currentUrl="";
  String pageLinkUrl="";
  @override
  void initState() {
    widget.pageLinks=1;
    widget.sortOption="";
    WebEngagePlugin.trackScreen("Product Listing Screen: ${widget.url}");

    setState(() {
      MyFilter.isClear=false;
      MyFilter.modified="";
      Catalogue.screenVisit=0;
      MyFilter.filterModel.clear();
      MyFilter.filterModel = new List<FilterModel>();
      Single.radioItem = "";
    });



    // ignore: unnecessary_statements
    MyFilter.filterModel!=null && MyFilter.filterModel.isNotEmpty?getFilteredListingProducts():getListingProducts();

    super.initState();
  }

  void didUpdateWidget(ChildCatalogue oldWidget) {
    if (widget.pageLinks != count) {
      setState(() {
        if (count >= pageLinks.length) {
       //   ToastMsg().getFailureMsg(context, "No More Items");
        } else {
          setState(() {
            widget.url=currentUrl;
          });
          getListingProducts();
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    print("RESULT AFTER CLOSE: $clearData $errorMessage");
    if(clearData==0){
      getListingProducts();
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    height = widget.screen == "NEW"
        ? Platform.isAndroid?1.1: 1.12
        :  Platform.isAndroid?1.08:1.08;

    return StreamBuilder<ChildListingModel>(
      stream: widget.screen != "SEARCH"
          ? listingdetail_bloc.fetchChildList
          : widget.screen == "SEARCH"
          ? searchBloc.searchDetails
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (/*snapshot.data.new_model != null &&*/
          ChildListingModel.finalModel_List != null &&
              ChildListingModel.finalModel_List.length > 0 /*&&
              snapshot.data.new_model.length > 0*/) {

            sortList = snapshot.data.sortList;
            List<ChildModelList> items = ChildListingModel.finalModel_List;
            model_item = ChildListingModel.finalModel_List;
            filters = new List<Filters>();
            print("LISTING MODEL LENGTH:${snapshot.data.error}");
            currentUrl=snapshot.data.currentUrl;
            filters = ChildListingModel.filters;

            pageLinks = snapshot.data.pageLinks;
            //pageLinkUrl=snapshot.data.pageLinks[count].toString();
            return Stack(
                children: [
                  snapshot.data.error == null
                      ? SingleChildScrollView(
                    controller: widget.controller,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        ChildListingModel.banner != "" && ChildListingModel.description != ""
                            ? DesignerView(
                            isFollowing: snapshot.data.isFollowing,
                            id: snapshot.data.attribute_id,
                            img: ChildListingModel.banner,
                            description: ChildListingModel.description)
                            : Center(),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  padding:
                                  EdgeInsets.only(left: 15),
                                  width: double.infinity,
                                  child: Align(
                                    alignment:
                                    Alignment.centerLeft,
                                    child: Text(
                                      "Showing ${snapshot.data.total_records} Styles",
                                      textAlign:
                                      TextAlign.center,
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.normal,
                                          fontSize: 15,
                                          fontFamily:
                                          "Helvetica",
                                          color: Colors.black),
                                    ),
                                  )),
                            ),
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.only(right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 25,
                                      child: IconButton(
                                        iconSize: 25,
                                        padding:
                                        EdgeInsets.all(5),
                                        onPressed: () {
                                          setState(() {
                                            itemdesignStyle = 1;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.grid_on,
                                          color:
                                          itemdesignStyle ==
                                              1
                                              ? Colors.black
                                              : Colors.grey,
                                          size: 20,
                                        ),
                                      )),
                                  Container(
                                      width: 25,
                                      child: IconButton(
                                        iconSize: 25,
                                        padding:
                                        EdgeInsets.all(5),
                                        onPressed: () {
                                          setState(() {
                                            itemdesignStyle = 2;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.crop_square,
                                          color:
                                          itemdesignStyle ==
                                              2
                                              ? Colors.black
                                              : Colors.grey,
                                          size: 25,
                                        ),
                                      )),
                                  Container(
                                      width: 25,
                                      child: IconButton(
                                          iconSize: 25,
                                          padding:
                                          EdgeInsets.all(5),
                                          onPressed: () {
                                            setState(() {
                                              itemdesignStyle =
                                              3;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.view_list,
                                            color:
                                            itemdesignStyle == 3
                                                ? Colors
                                                .black
                                                : Colors
                                                .grey,
                                            size: 25,
                                          ))),
                                ],
                              ),
                            )
                          ],
                        ),
                        buildWidget(items),
                      ],
                    ),
                  )
                      :Center(),
                  Align(
                      alignment: Alignment(0.0,height),
                      child: lowerHalf(context)),
                ]);
          } else {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.25),
              child: ErrorPage(
                appBarTitle: "${widget.screen}",
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget lowerHalf(BuildContext context) {
    print("Sort: ${sortList} ${filters}");
    return Container(
      height: Platform.isIOS ? 110 : 95,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.065,
                  decoration: BoxDecoration(
                    color: HexColor("#f5f5f5"),
                  ),
                  child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: HexColor("#e0e0e0"),
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    onPressed: () async {
                      await bottomSheet.getSortByBottomSheet(
                          sortList, widget.query, context);
                      setState(() {
                        widget.sortOption = bottomSheet.sort_value;
                        widget.url=bottomSheet.sort_url;
                        Catalogue.count = 1;
                        widget.pageLinks = 1;
                        Single.radioItem = "";
                        widget.sortOption!=null && widget.sortOption!=""? getListingProducts():"";
                        widget.controller.jumpTo(0.0);
                      });

                    },
                    label: Text(
                      'Sort',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    icon: new Image.asset(
                      "images/sort.png",
                      width: 20,
                      height: 20,
                    ),
                    color: Colors.transparent,
                  ),
                )),

            Container(
              color: HexColor("#e0e0e0"),
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.065,
                  decoration: BoxDecoration(
                    color: HexColor("#f5f5f5"),
                  ),
                  child: FlatButton.icon(
                    onPressed: () async {
                      if(filters!=null && filters.length>0){
                        bool result = await Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new MyFilter(
                                  filter: filters,
                                )));
                        print("FILTER RESULT $result");
                        if(result==true){
                          setState(() {
                            print("CUrrent URL :$currentUrl");
                            widget.url=currentUrl!=""?currentUrl:widget.url;
                            DetailPageState.count = 1;
                            widget.pageLinks = 1;
                            print("FILTER RESULT: $result");

                          });

                          print("${MyFilter.filterModel}");
                          widget.controller.jumpTo(0.0);
                          getFilteredListingProducts();
                          Catalogue.screenVisit++;
                        }
                        else {
                          if (result == false && Catalogue.screenVisit == 0 && MyFilter.modified != "") {
                            setState(() {
                              widget.url=currentUrl;
                              DetailPageState.count = 1;
                              widget.pageLinks = 1;
                              print("FILTER RESULT: $result  ${widget.url}");
                            });

                            print("${MyFilter.filterModel}");
                            widget.controller.jumpTo(0.0);
                            getFilteredListingProducts();
                          }

                          if (result == false && Catalogue.screenVisit == 0 && MyFilter.modified == "") {
                            setState(() {
                              widget.url = currentUrl;
                              DetailPageState.count = 1;
                              widget.pageLinks = 1;
                              print("FILTER RESULT: $result");
                            });

                            print("${MyFilter.filterModel}");
                            widget.controller.jumpTo(0.0);
                            getFilteredListingProducts();


                          }
                        }
                      }
                      else{
                        ToastMsg().getFailureMsg(context, "No Filters.");
                      }



                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: HexColor("#e0e0e0"),
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    label: Text(
                      'Filter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          color: Colors.black,
                          fontSize: 15),
                    ),
                    icon: Container(
                      height: 25,
                      child: Stack(children: [
                        Positioned(
                          child: new Icon(
                            Icons.filter_list,
                            size: 25,
                          ),
                        ),
                      ]),
                    ),
                    color: Colors.transparent,
                  ),
                )),
          ]),
    );
  }


  getListingProducts() {
    print("LISTING URL :${widget.url}");
    setState(() {
      widget.screen != "SEARCH"
          ? listingdetail_bloc.fetchAllChildNewData(widget.url, widget.sortOption,
          MyFilter.filterModel, widget.pageLinks)
          : widget.screen == "SEARCH"
          ? searchBloc.getSearchDetails(widget.url, widget.sortOption,
          MyFilter.filterModel, widget.pageLinks)
          : null;
    });

  }

  getFilteredListingProducts() {
    print("SCREEN VISIT:${Catalogue.screenVisit}");
    setState(() {
      widget.screen != "SEARCH"
          ?  listingdetail_bloc.fetchAllChildNewData(widget.url, widget.sortOption,
          MyFilter.filterModel, widget.pageLinks)
          : widget.screen == "SEARCH"
          ? searchBloc.getSearchDetails(widget.url, widget.sortOption,
          MyFilter.filterModel, widget.pageLinks)
          : null;
    });
  }


  Widget buildWidget(List<ChildModelList> items) {
    if (itemdesignStyle == 1) {
      return Padding(
        padding: const EdgeInsets.only(left:0.0,bottom:50),
        child: ChildCataloguePatternOne(
          items: items,
        ),
      );
    } else if (itemdesignStyle == 2) {
      return Padding(
        padding: const EdgeInsets.only(left:0.0,bottom:50),
        child: ChildCataloguePatternTwo(
          items: items,
        ),
      );
    } else if (itemdesignStyle == 3) {
      return Padding(
        padding: const EdgeInsets.only(left:0.0,bottom:50),
        child: ChildCataloguePatternThree(
          items: items,
        ),
      );
    }
  }
}
