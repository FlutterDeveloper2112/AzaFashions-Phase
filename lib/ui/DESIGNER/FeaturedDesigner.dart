
import 'package:azaFashions/bloc/DesignerBloc.dart';
import 'package:azaFashions/models/Designer/DesignerModel.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/DESIGNER/DesignerProfile.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FeaturedDesigner extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<FeaturedDesigner> {
  bool validate = false;

  TextEditingController searchController = TextEditingController();
  ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  Map<String, dynamic> finalMapDesigners = {};
  Map<String, dynamic> searchData = {};
  FirebaseAnalytics analytics = FirebaseAnalytics();

  int alphaIndex =0;
  String filter = "";

  @override
  void initState() {
    // ignore: unnecessary_statements
    analytics.setCurrentScreen(screenName: "Featured Designer");
    designerBloc.getFeaturedDesigners();
    itemScrollController = ItemScrollController();
    WebEngagePlugin.trackScreen("Featured Designer Screen");
    super.initState();
  }

  @override
  void dispose() {
    designerBloc.clearFeaturedDesigner();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // connectionStatus.toString()!="ConnectivityStatus.Offline"?   designerBloc.getFeaturedDesigners():"";


    return  RefreshIndicator(
        onRefresh: refreshData,
        child: StreamBuilder<DesignerModel>(
            stream: designerBloc.featuredDesigners,
            builder: (context, snapshot) {
              // print(snapshot.connectionState);


              if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState ==ConnectionState.done) {

                if(DesignerModel.featuredDesigners.isEmpty){
                  return ErrorPage(appBarTitle: "No Designers Found",);
                }
                else{
                  if(snapshot.data.error!=null && snapshot.data.error!=""){
                    Future.delayed(Duration(seconds: 0),(){
                      setState(() {
                        designerBloc.getFeaturedDesigners();
                      });
                    });
                    return Container();

                  }
                  else{
                    finalMapDesigners.addAll(DesignerModel.featuredDesigners);
                    searchData.isNotEmpty
                        ? searchData
                        : searchData.addAll(finalMapDesigners);
                    // print(searchData.length);
                    return Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          getWidget(context,snapshot.data),
                          DesignerModel.featuredDesignersFilters.isEmpty
                              ? Padding(padding: EdgeInsets.all(0))
                              : Container(
                            width: double.infinity,
                            height: 50,
                            decoration:
                            BoxDecoration(color: Colors.grey[300]),
                            child: FlatButton.icon(
                                onPressed: () async {
                                  var res = await CustomBottomSheet()
                                      .getDesignerFilterBottomSheet(
                                      context, DesignerModel.featuredDesignersFilters);
                                  print(res);
                                  if (res != null) {
                                    setState(() {
                                      finalMapDesigners.clear();
                                      searchData.clear();
                                      // searchData = Map<String,dynamic>();
                                      // finalMapDesigners = Map<String,dynamic>();
                                    });
                                    await designerBloc.getFeaturedDesigners(
                                        id: res);
                                  }
                                  else {
                                    setState(() {
                                      searchData.clear();
                                      // searchData = Map<String,dynamic>();
                                      finalMapDesigners.clear();
                                      // finalMapDesigners = Map<String,dynamic>();
                                    });
                                    // refreshData();
                                    await designerBloc.getFeaturedDesigners();
                                  }
                                  setState(() {
                                  });

                                },
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey[400],
                                      width: 1,
                                      style: BorderStyle.solid),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                                label: Text(
                                  'Filter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "PlayfairDisplay",
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                icon: new Icon(
                                  Icons.filter_list,
                                  size: 20,
                                ),
                                color: Colors.transparent),
                          )
                        ]);
                  }


                }


              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      searchData.clear();
      designerBloc.getAllDesigners();
    });
  }

  // void filterQuery(String query) {
  //   print(query);
  //   Map<String, dynamic> dynamicSearchList = {};
  //   searchData.addAll(finalMapDesigners);
  //   dynamicSearchList.addAll(searchData);
  //   print(dynamicSearchList);
  //   if (query.isNotEmpty) {
  //     Map<String, dynamic> dynamicSearchData = {};
  //     List elem = [];
  //     dynamicSearchList.forEach((key, value) {
  //       dynamicSearchData.clear();
  //       value.forEach((element) {
  //         if (element['name']
  //             .toString()
  //             .toLowerCase()
  //             .startsWith(query.toLowerCase())) {
  //           elem.add(element);
  //           print(elem);
  //           dynamicSearchData.addAll({key: elem});
  //           print("dynamicSearchData $dynamicSearchData");
  //           setState(() {
  //             searchData.clear();
  //             searchData.addAll(dynamicSearchData);
  //             print("searchData $searchData");
  //           });
  //         }
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       searchData.clear();
  //       searchData.addAll(finalMapDesigners);
  //     });
  //   }
  // }

  Widget getWidget(BuildContext context, DesignerModel data) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        buildSearch(),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.only(
                  top: 70,
                  bottom:DesignerModel.featuredDesignersFilters.length>0?60:10,
                ),
                child: buildKeys(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:15.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      padding: EdgeInsets.only(top: 70, right: 10, bottom: 50),
                      height: double.infinity,
                      width: 40,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.alphabets.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Container(
                                height: 35,
                                width: 10,
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        print(data.alphabets.length);
                                        var alphabet;
                                        // print(alphabet);
                                        searchData.forEach((key, value) {
                                          if (key == data.alphabets[index]) {
                                            alphabet = key;
                                          }
                                        });

                                        List designerKey =
                                        searchData.keys.toList();
                                        int jumpIndex = designerKey
                                            .indexOf(data.alphabets[index]);
                                        if (jumpIndex < 0) {
                                          if( data.alphabets[index].contains("0-9")){
                                            alphaIndex = index;
                                            itemScrollController.jumpTo(
                                              index: 26,
                                            );
                                          }

                                        }  else {

                                          alphaIndex = index;
                                          itemScrollController.jumpTo(
                                            index: jumpIndex,
                                          );
                                        }
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        data.alphabets[index],
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight: alphaIndex==index?FontWeight.bold:FontWeight.normal,
                                            color: Colors.black,
                                            fontSize: alphaIndex==index?16:14),
                                      ),
                                    )));
                          }))),
            )
          ],
        )
      ],
    );
  }

  Widget buildKeys() {
    return ScrollablePositionedList.builder(
        itemCount: searchData.length,
        itemPositionsListener: itemPositionsListener,
        itemScrollController: itemScrollController,
        itemBuilder: (context, int index) {
          String key = searchData.keys.elementAt(index);
          if(filter=="" ||filter==null)
            return Padding(
              padding: const EdgeInsets.only(right: 10, left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    child: Text(
                      "$key",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  buildValues(key)
                ],
              ),
            );
          else{
            if(key.toLowerCase().contains(filter[0].toLowerCase())){
              return Padding(
                padding: const EdgeInsets.only(right: 10, left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey[300],
                      width: double.infinity,
                      child: Text(
                        "$key",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    buildValues(key)
                  ],
                ),
              );
            }
            else{
              return Container();
            }
          }
        });
  }

  Widget buildValues(String key) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: searchData[key].length,
        itemBuilder: (context, int index) {
          if(filter==""||filter == null){
            return InkWell(
              onTap: () {
                return Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new DesignerProfile(
                          id: searchData[key][index]['id'],
                          title: "${searchData[key][index]['name']}",
                          // isFollowing: searchData[key][index]['following'],
                          url: searchData[key][index]['url'],
                        )));
              },
              child: Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: InkWell(
                    onTap: () async{
                      print("Following ${searchData[key][index]['following']}");
                      designerBloc.disposeFollow();
                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      if (prefs.getBool("browseAsGuest")) {
                        CustomBottomSheet().getLoginBottomSheet(context);
                      }else{
                        setState(() {
                          validate = true;
                        });
                        if (validate) {

                          if (searchData[key][index]['following'] == false) {
                            // setState(() {
                            //   follow = true;
                            // });
                            designerBloc.followDesigner(
                                searchData[key][index]['id'], "follow");
                            designerBloc.follow.listen((event) {
                              if (event.error == "" || event.error==null) {
                                setState(() {
                                  searchData[key][index]['following'] = true;
                                });
                              } else {
                                return ToastMsg()
                                    .getFailureMsg(context, event.error);
                              }

                            });
                            // setState(() {
                            //   validate = false;
                            // });
                          } else {
                            designerBloc.followDesigner(
                                searchData[key][index]['id'], "unfollow");
                            designerBloc.unFollow.listen((event) {

                              if (event.error == "") {
                                setState(() {
                                  searchData[key][index]['following'] = false;
                                });
                              } else {
                                return ToastMsg()
                                    .getFailureMsg(context, event.error);
                              }
                              // setState(() {
                              //   validate = false;
                              // });
                            });
                          }

                          setState(() {
                            validate = false;
                          });
                        }

                      }},
                    child: (searchData[key][index]['following'] == true)
                        ? Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.star,
                          color: Colors.black,
                          size: 20,
                        ))
                        : Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.star_border,
                          color: Colors.black,
                          size: 20,
                        )),
                  ),
                ),
                // ignore: unrelated_type_equality_checks
                Container(
                    child: InkWell(
                      child: Text('${searchData[key][index]['name']}',
                          style: TextStyle(
                            fontFamily: "Helvetica",
                            color: Colors.black,
                          )),
                    )),
              ]),
            );
          }
          else{
            if(searchData[key][index]['name'].toString().toLowerCase().startsWith(filter.toLowerCase())){
              return InkWell(
                onTap: () {
                  return Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (__) => new DesignerProfile(
                            id: searchData[key][index]['id'],
                            title: "${searchData[key][index]['name']}",
                            // isFollowing: searchData[key][index]['following'],
                            url: searchData[key][index]['url'],
                          )));
                },
                child: Row(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: InkWell(
                      onTap: () async{
                        print("Following ${searchData[key][index]['following']}");
                        designerBloc.disposeFollow();
                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        if (prefs.getBool("browseAsGuest")) {
                          CustomBottomSheet().getLoginBottomSheet(context);
                        }else{
                          setState(() {
                            validate = true;
                          });
                          if (validate) {

                            if (searchData[key][index]['following'] == false) {
                              // setState(() {
                              //   follow = true;
                              // });
                              designerBloc.followDesigner(
                                  searchData[key][index]['id'], "follow");
                              designerBloc.follow.listen((event) {
                                if (event.error == "" || event.error==null) {
                                  setState(() {
                                    searchData[key][index]['following'] = true;
                                  });
                                } else {
                                  return ToastMsg()
                                      .getFailureMsg(context, event.error);
                                }

                              });
                              // setState(() {
                              //   validate = false;
                              // });
                            } else {
                              designerBloc.followDesigner(
                                  searchData[key][index]['id'], "unfollow");
                              designerBloc.unFollow.listen((event) {

                                if (event.error == "") {
                                  setState(() {
                                    searchData[key][index]['following'] = false;
                                  });

                                } else {
                                  return ToastMsg()
                                      .getFailureMsg(context, event.error);
                                }
                                // setState(() {
                                //   validate = false;
                                // });
                              });
                            }

                            setState(() {
                              validate = false;
                            });
                          }

                        }},
                      child: (searchData[key][index]['following'] == true)
                          ? Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.star,
                            color: Colors.black,
                            size: 20,
                          ))
                          : Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.star_border,
                            color: Colors.black,
                            size: 20,
                          )),
                    ),
                  ),
                  // ignore: unrelated_type_equality_checks
                  Container(
                      child: InkWell(
                        child: Text('${searchData[key][index]['name']}',
                            style: TextStyle(
                              fontFamily: "Helvetica",
                              color: Colors.black,
                            )),
                      )),
                ]),
              );
            }
            else{
              return Container();
            }
          }
        });
  }

  Container buildSearch() {
    return Container(
        height: 50,
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
        child: TextField(
            onChanged: (value) {
              setState(() {
                filter = value;
              });
              // filterQuery(value);
              print("FILTER QUERY: ${value}");
            },
            controller: searchController,
            textAlign: TextAlign.justify,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: "Search for designers",
                hintStyle: TextStyle(fontFamily: "Helvetica"),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder())));
  }
}
