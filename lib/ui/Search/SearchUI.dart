import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:azaFashions/bloc/SearchBloc.dart';
import 'package:azaFashions/models/Search/SearchModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchUI extends StatefulWidget {
  String sortOption;

  SearchUI({this.sortOption});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchUI> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  bool onSubmit = false;
  var _controller = TextEditingController();
  static int count = 1;
  String text = "";
  String sortOption = "";
  final ScrollController controller = new ScrollController();

  bool isChanged = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analytics.setCurrentScreen(screenName: "Search Page");
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: text==""? const Color(0xFFB4C56C).withOpacity(0.01):null,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Platform.isAndroid
                ? Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            )
                : Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
          backgroundColor: Colors.white,
          title: Container(
              width: double.infinity,
              height: 55,
              padding: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
              child: TextField(
                  controller: _controller,
                  onSubmitted: (String query) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      text = query;
                      if (text == "" || text == null) {
                      } else {
                        isChanged = false;
                      }

                    });
                  },
                  onChanged: (String query) {
                    // print(query);
                    setState(() {
                      if (query == "") {
                        print(true);
                        setState(() {
                          text = "";
                        });
                      } else {
                        text = query;
                        searchBloc.searchAutoComplete(query, "");
                      }
                      isChanged = true;
                    });
                  },
                  autofocus: true,
                  textAlign: TextAlign.justify,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      //prefixIcon: Icon(Icons.search, color: Colors.grey[350]),
                      //prefixIcon: Icon(Icons.search, color: Colors.grey[350]),
                      hintText: " What can we help you find?",
                      hintStyle: TextStyle(fontSize:14,fontFamily: "Helvetica"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[350]),
                      ),
                      suffixIcon: InkWell(
                          onTap: (){
                            setState(() {
                              text = "";
                              _controller.clear();

                            });
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close, color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[350]),
                      )))),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.atEdge &&
                notification.metrics.pixels == 0.0) {
              setState(() {
                if (count > 1) {
                  count--;
                } else {
                  setState(() {
                    count = 1;
                  });
                }
              });
            }
            if (notification is ScrollEndNotification &&
                notification.metrics.atEdge &&
                notification.metrics.maxScrollExtent ==
                    notification.metrics.pixels) {
              setState(() {
                count++;
              });
            } else {}

            return false;
          },
          child: text!=""?StreamBuilder<SearchModel>(
            stream: searchBloc.autoCompleteSearch,
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState ==
                  ConnectionState.active) {
                if (snapshot.data.error != null &&
                    snapshot.data.error != "") {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                        "No Result Found for $text",
                        style: TextStyle(
                            fontFamily: "PlayFairDisplay",
                            fontSize: 14),
                      ),
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: (){
                      FocusScope.of(context).requestFocus();
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: snapshot.data.widgets,
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
                : Container(
            color:  const Color(0xFFB4C56C).withOpacity(0.01),
             /*child: Align(
                alignment: Alignment.center,
                child: Image.asset("images/splash_aza_logo.png")),*/

        /* child: text != ""
              ? !isChanged
                  ? Catalogue("SEARCH", "", text, sortOption, count,controller: controller,)
                  : StreamBuilder<SearchModel>(
                stream: searchBloc.autoCompleteSearch,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.data.error != null &&
                        snapshot.data.error != "") {
                      return Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text(
                            "No Result Found for $text",
                            style: TextStyle(
                                fontFamily: "PlayFairDisplay",
                                fontSize: 14),
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: snapshot.data.widgets,
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
              : Container(
            color:  const Color(0xFFB4C56C).withOpacity(0.01),
      */      /*child: Align(
                alignment: Alignment.center,
                child: Image.asset("images/splash_aza_logo.png")),*/

        ),
        )),
    );
  }
}
