import 'package:azaFashions/bloc/DesignerBloc.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'DesignerProfile.dart';
import 'package:azaFashions/models/Designer/DesignerModel.dart';
import 'package:azaFashions/ui/DESIGNER/DesignerProfile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class MyDesigner extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MyDesigner> {
  TextEditingController searchController = TextEditingController();
  ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  Map<String, dynamic> finalMapDesigners = {};
  Map<String, dynamic> searchData = {};
  FirebaseAnalytics analytics = FirebaseAnalytics();
  bool loginDetails;


  String filter = "";
  int alphaIndex =0;
  @override
  void initState() {
    // ignore: unnecessary_statements


    analytics.setCurrentScreen(screenName: "My Designer");
    itemScrollController = ItemScrollController();
    super.initState();
    getLoginDetails();
    WebEngagePlugin.trackScreen("My Designer Screen");
    // designerBloc.getMyDesigners();
  }


  getLoginDetails()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("browseAsGuest")) {
      CustomBottomSheet().getLoginBottomSheet(context);
      setState(() {
        loginDetails=false;
      });
    }
    else{
      setState(() {
        loginDetails=true;
      });
      designerBloc.getMyDesigners();
    }
  }
  @override
  void didUpdateWidget(covariant MyDesigner oldWidget) {
    // getLoginDetails();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {

    designerBloc.clearMyDesigner();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return loginDetails==true?RefreshIndicator(
      onRefresh: refreshData,
      child: StreamBuilder<DesignerModel>(
          stream: designerBloc.myDesigners,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if(DesignerModel.myDesigners!=null && DesignerModel.myDesigners.length>0){

                if(snapshot.data.error!=null && snapshot.data.error!=""){
                  Future.delayed(Duration(seconds: 0),(){
                    setState(() {
                      designerBloc.getMyDesigners();
                    });
                  });
                  return Container();
                }
                else{
                  searchData.clear();
                  searchData.addAll(DesignerModel.myDesigners);
                  // print(DesignerModel.myDesigners);
                  return Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        getWidget(context, snapshot.data),
                        DesignerModel.myDesignersFilters.isEmpty?
                        Center(): Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(color: Colors.grey[300]),
                          child: FlatButton.icon(
                              onPressed: () async{
                                var res = await CustomBottomSheet()
                                    .getDesignerFilterBottomSheet(
                                    context, DesignerModel.myDesignersFilters);
                                print(res);
                                if (res != null) {
                                  setState(() {
                                    // finalMapDesigners.clear();
                                    // searchData.clear();
                                    // searchData = Map<String,dynamic>();
                                    // finalMapDesigners = Map<String,dynamic>();
                                  });
                                  await designerBloc.getMyDesigners(
                                      id: res);
                                }
                                else {
                                  setState(() {
                                    // searchData.clear();
                                    // // searchData = Map<String,dynamic>();
                                    // finalMapDesigners.clear();
                                    // finalMapDesigners = Map<String,dynamic>();
                                  });
                                  // refreshData();
                                  await designerBloc.getMyDesigners();
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
              else{
                return ErrorPage(appBarTitle: "No Designers Found",);
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    ):ErrorPage(appBarTitle: "Log in",);
  }

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
                    bottom:DesignerModel.myDesignersFilters.length>0?60:10
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
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.alphabets.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Container(
                                height: 30,
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
                                            fontSize: alphaIndex==index?14:13),
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
              onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (__) => new DesignerProfile(
                          id: searchData[key][index]['id'],
                          title: "${searchData[key][index]['name']}",
                          // isFollowing: true,
                          url: searchData[key][index]['url']
                      ))),
              child: Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: InkWell(
                      onTap: () async {
                        designerBloc.disposeFollow();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        print(prefs.getBool("browseAsGuest"));
                        if (prefs.getBool("browseAsGuest")) {
                          CustomBottomSheet().getLoginBottomSheet(context);
                        }
                        else{
                          await designerBloc.followDesigner(
                              searchData[key][index]['id'], "unfollow");


                          setState(() {
                            searchData.clear();
                            finalMapDesigners.clear();
                          });
                          await designerBloc.getMyDesigners();
                          setState(() {

                          });
                        }},
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.star,
                            color: Colors.black,
                            size: 20,
                          ))

                  ),
                ),
                // ignore: unrelated_type_equality_checks
                Container(
                    child: InkWell(
                      child: Text('${searchData[key][index]['name']}',
                          style: TextStyle(
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black,
                          )),
                    )),
              ]),
            );
          }
          else{
            if(searchData[key][index]['name'].toString().toLowerCase().startsWith(filter.toLowerCase())){
              return InkWell(
                onTap: () => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new DesignerProfile(
                            id: searchData[key][index]['id'],
                            title: "${searchData[key][index]['name']}",
                            // isFollowing: true,
                            url: searchData[key][index]['url']
                        ))),
                child: Row(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: InkWell(
                        onTap: () async {
                          designerBloc.disposeFollow();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          print(prefs.getBool("browseAsGuest"));
                          if (prefs.getBool("browseAsGuest")) {
                            CustomBottomSheet().getLoginBottomSheet(context);
                          }
                          else{
                            await designerBloc.followDesigner(
                                searchData[key][index]['id'], "unfollow");

                            setState(() {
                              searchData.clear();
                              finalMapDesigners.clear();
                            });
                            await designerBloc.getMyDesigners();

                            setState(() {

                            });
                          }},
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.star,
                              color: Colors.black,
                              size: 20,
                            ))

                    ),
                  ),
                  // ignore: unrelated_type_equality_checks
                  Container(
                      child: InkWell(
                        child: Text('${searchData[key][index]['name']}',
                            style: TextStyle(
                              fontFamily: "PlayfairDisplay",
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
                hintStyle: TextStyle(fontFamily: "PlayfairDisplay"),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder())));
  }

  Future<void> refreshData() async {
    // await Future.delayed(Duration(seconds: 1));
    searchData.clear();
    finalMapDesigners.clear();
    await designerBloc.getMyDesigners();
  }
}
