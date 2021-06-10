import 'dart:io';
import 'package:azaFashions/bloc/CelebrityStyleBloc.dart';
import 'package:azaFashions/bloc/SearchBloc.dart';
import 'package:azaFashions/models/CelebrityList.dart';
import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/models/Listing/Filters.dart';
import 'package:azaFashions/models/Listing/SortList.dart';
import 'package:azaFashions/networkprovider/CelebrityProvider.dart';
import 'package:azaFashions/ui/BaseFiles/ChildDetailPage.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:azaFashions/ui/Filter/Single.dart';
import 'package:azaFashions/ui/PRODUCTS/ProductDetails.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class CelebrityCatalogue extends StatefulWidget {
  String screen="Celebrity";
  static int count = 0;
  final int counter;
  String query;
  String sortOption;
  String url;
  int pageLinks;
  static int screenVisit=0;
  final ScrollController controller;

   CelebrityCatalogue({Key key, this.pageLinks,this.counter, this.controller}) : super(key: key);

  @override
  _CelebrityCatalogueState createState() => _CelebrityCatalogueState();
}

class _CelebrityCatalogueState extends State<CelebrityCatalogue> {
  int oldCounter;
  int itemCount = 2;
  bool isLoading = false;
  double height;

  CustomBottomSheet bottomSheet = new CustomBottomSheet();
  int itemdesignStyle = 1;
  int res = 0;

  List pageLinks = [];
  int count = 0;
  List<CelebrityData> model_item = [];
  SortList sortList;
  List<Filters> filters;
  static int clearData;
  String errorMessage = "";
  String currentUrl="";
  String pageLinkUrl="";
  FirebaseAnalytics analytics = FirebaseAnalytics();
  CelebrityStyleBloc celebrityStyleBloc = CelebrityStyleBloc();

  @override
  void initState() {

    widget.pageLinks = 1;
    widget.sortOption = "";
    setState(() {
      widget.url="celebrity-style";
    });

    WebEngagePlugin.trackScreen("Celebrity Listing Screen: ${widget.url}");

    setState(() {
      MyFilter.isClear=false;
      MyFilter.modified="";
      CelebrityCatalogue.screenVisit=0;
      MyFilter.filterModel.clear();
      MyFilter.filterModel = new List<FilterModel>();
      Single.radioItem = "";
    });

    // ignore: unnecessary_statements
    MyFilter.filterModel!=null && MyFilter.filterModel.isNotEmpty?getFilteredListingProducts():getListingProducts();

    super.initState();
  }
  getListingProducts() {
    setState(() {
      widget.screen != "SEARCH"
          ? celebrityStyleBloc.celebrityStyle(widget.url, widget.sortOption,
          MyFilter.filterModel, widget.pageLinks)
          : widget.screen == "SEARCH"
          ? searchBloc.getSearchDetails(widget.url, widget.sortOption,
          MyFilter.filterModel, widget.pageLinks)
          : null;
    });
  }

  getFilteredListingProducts() {

    setState(() {
      widget.screen != "SEARCH"
          ? celebrityStyleBloc.celebrityStyle(widget.url, widget.sortOption,
          MyFilter.filterModel, widget.pageLinks)
          : widget.screen == "SEARCH"
          ? searchBloc.getSearchDetails(widget.url, widget.sortOption,
          MyFilter.filterModel, widget.pageLinks)
          : null;
    });
  }

  @override
  void didUpdateWidget(covariant CelebrityCatalogue oldWidget) {
    if (widget.pageLinks != count) {
      setState(() {
        if (count >= pageLinks.length) {
          //    ToastMsg().getFailureMsg(context, "No More Items");
        } else {
          setState(() {
            widget.url=currentUrl!=""?currentUrl:widget.url;
            print("PAGE LINK URL: ${widget.url}");
          });
          getListingProducts();
        }
      });

    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    print(MediaQuery.of(context).size.center(Offset.infinite));
    // height = widget.screen == "NEW" ? Platform.isAndroid ? 1.1 : 1.12
    //     : Platform.isAndroid
    //     ? 1.08
    //     : 1.08;
    height = 1.08;
    return StreamBuilder<CelebrityList>(
        stream: celebrityStyleBloc.fetchCelebrity,

        builder: (context, snapshot) {
          // print("SNAMP ${snapshot.data.celebData[3].celebrity_name}");
          if(snapshot.connectionState == ConnectionState.active){
            if(CelebrityList.celebrityData != null && CelebrityList.celebrityData.length > 0){
              sortList = snapshot.data.sortList;
              filters = new List<Filters>();
              filters = CelebrityList.filters;
              pageLinks = snapshot.data.pageLinks;
              print("SLider Count: ${snapshot.data.sliderCount}");
              return Stack(
                overflow: Overflow.visible,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: SingleChildScrollView(
                      controller: widget.controller,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          snapshot.data.celebData!=null && snapshot.data.celebData.length>0 && snapshot.data.sliderCount>0?buildCelebSlider(snapshot.data.celebData,snapshot.data.sliderCount):Center(),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: CelebrityList.celebrityData.length,
                              itemBuilder: (context, int index) {
                                return InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductDetail(id: snapshot.data.celebData[index].product_id,image: snapshot.data.celebData[index].banner_image,url:snapshot.data.celebData[index].product_url,productTag: "",)));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(/*left:10,right:10,*/bottom:5,top:10),
                                        child: Image.network(CelebrityList.celebrityData[index].banner_image),
                                      ),
                                      Text(
                                        CelebrityList.celebrityData[index].celebrity_name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            fontFamily: "PlayfairDisplay",
                                            color: Colors.black),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                      ),
                                      Text(
                                        " In ${CelebrityList.celebrityData[index].designer_name}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            fontFamily: "Helvetica",
                                            color: Colors.grey),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment(0.0, height), child: lowerHalf(context)),
                ],
              );
            }
            else{
              return Center();
            }

          }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

  Container buildCelebSlider(List<CelebrityData> data,int item_count) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
      width: double.infinity,
      height: 405,
      child: CarouselSlider(
          options: CarouselOptions(
            /*height: 400,
                    aspectRatio: 16/9,
                    viewportFraction: 0.55,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,*/
              height: 490,
              autoPlay: true,
              aspectRatio: 2.0,
              // enlargeCenterPage: true,
              viewportFraction: 0.75),
          items:
          data.take(item_count).map((e) =>  buildCeleb(e.image,e.celebrity_name,e.designer_name,e.product_id,e.product_url)).toList()

      ),

    );
  }

  Widget  buildCeleb(String image,String celebrityName,String designerName,int productId,String productUrl) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(id: productId,image: image,url:productUrl,productTag: "",)));
      },
      child: new Container(
          padding: EdgeInsets.only(top: 20, left: 5, right: 5,bottom: 5),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(image))),
                height: 290,
                width: 300,
                // width: double.infinity,
                padding: EdgeInsets.all(10),
                // child: Image.asset("images/indianFlag.png"),
              ),
              Padding(padding: EdgeInsets.only(bottom:5)),
              Text(
                celebrityName,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    fontFamily: "PlayfairDisplay",
                    color: Colors.black),
              ), Padding(padding: EdgeInsets.only(bottom:5)),
              Text(
                " In $designerName",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    fontFamily: "Helvetica",
                    color: Colors.grey),
              ),
            ],
          )

      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
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
                      await bottomSheet.getCelebSortByBottomSheet(
                          sortList, widget.query, context);
                      setState(() {
                        widget.sortOption = bottomSheet.sort_value;
                        widget.url=bottomSheet.sort_url;
                        CelebrityCatalogue.count = 1;
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
                          CelebDetailPageState.count = 1;
                          widget.pageLinks = 1;
                          print("FILTER RESULT: $result");

                        });

                        print("${MyFilter.filterModel}");
                        widget.controller.jumpTo(0.0);
                        getFilteredListingProducts();
                        CelebrityCatalogue.screenVisit++;
                      }
                      else {
                        if (result == false && CelebrityCatalogue.screenVisit == 0 && MyFilter.modified != "") {
                          setState(() {
                            widget.url = currentUrl;
                            CelebDetailPageState.count = 1;
                            widget.pageLinks = 1;
                            print("FILTER RESULT: $result  ${widget.url}");
                          });

                          print("${MyFilter.filterModel}");
                          widget.controller.jumpTo(0.0);
                          getFilteredListingProducts();
                        }

                        if (result == false && CelebrityCatalogue.screenVisit == 0 && MyFilter.modified == "") {
                          setState(() {
                            widget.url = currentUrl;
                            CelebDetailPageState.count = 1;
                            widget.pageLinks = 1;
                            print("FILTER RESULT: $result");
                          });

                          print("${MyFilter.filterModel}");
                          widget.controller.jumpTo(0.0);
                          getFilteredListingProducts();


                        }
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
}
