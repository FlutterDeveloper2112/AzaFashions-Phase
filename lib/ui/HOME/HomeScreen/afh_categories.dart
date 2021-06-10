import 'dart:io';
import 'package:azaFashions/bloc/ListingBloc/ListingDetailBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/CategoryModel.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Categories extends StatefulWidget {
  final ScrollController controller;

  const Categories({Key key, this.controller}) : super(key: key);
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int index = 0;

  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "Categories");
    super.initState();
    // ignore: unnecessary_statements
    listingdetail_bloc.getCategories();
    WebEngagePlugin.trackScreen("Categories Screen");
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    listingdetail_bloc.getCategories();
  }

  @override
  Widget build(BuildContext context) {


    return  MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        bottom:true,
        child: StreamBuilder<CategoryModel>(
            stream: listingdetail_bloc.categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Padding(
                  padding:  EdgeInsets.only(bottom:15),
                  child: ListView.builder(
                      controller: widget.controller,

                      itemCount: snapshot.data.items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, int index) {
                        CategoryItems items = snapshot.data.items[index];
                        String subtitle = items.items.map((e) => e.name).toString().replaceAll("(", "").replaceAll(")", "").replaceAll("..., ", "");
                        print("SUBTITLE: ${subtitle}");
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  snapshot.data.items[index].selected =
                                  !snapshot.data.items[index].selected;
                                  this.index = index;
                                  if(snapshot.data.items[index].selected){
                                    widget.controller.jumpTo(160*index.toDouble());
                                  }
                                });
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              snapshot.data.items[index].name,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "PlayfairDisplay"),
                                            ),
                                            Icon(
                                              snapshot.data.items[index]
                                                  .selected &&
                                                  this.index == index
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Container(
                                          width:200,
                                          child: Padding(
                                              padding: EdgeInsets.only(bottom: 4),
                                              child:Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  subtitle.replaceAll("Explore All, ", ""),
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12.5,
                                                      fontFamily: "Helvetica",
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: index==snapshot.data.items.length-1?60:5),
                                width: double.infinity,
                                height: TargetPlatform.iOS != null ? 150 : 180,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image:NetworkImage("${snapshot.data.items[index].image}")
                                    //Can use CachedNetworkImage
                                  ),

                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            if (snapshot.data.items[index].selected && this.index == index)

                              Padding(
                                padding: const EdgeInsets.only(bottom:40),
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.items[index].items.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, int index) {
                                      CategoryItems itemsList = snapshot.data.items[this.index].items[index];


                                      return Theme(
                                        data: ThemeData(
                                            accentColor: Colors.black,
                                            primaryColor: Colors.black),
                                        child: ExpansionTile(
                                          initiallyExpanded: false,
                                          maintainState: false,
                                          trailing: itemsList.items.isEmpty
                                              ? Text("")
                                              : !itemsList.selected
                                              ? Icon(Icons.arrow_drop_down)
                                              : Icon(Icons.arrow_drop_up),
                                          onExpansionChanged: (bool a) {
                                            if (itemsList.items.isEmpty) {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (__) => new DetailPage(
                                                          itemsList.name,
                                                          itemsList.url)));
                                              setState(() {
                                                itemsList.selected = false;
                                              });
                                            } else {

                                              setState(() {
                                                itemsList.selected =
                                                !itemsList.selected;
                                              });
                                            }
                                          },
                                          childrenPadding: EdgeInsets.only(left: 15),
                                          title: Text(itemsList.name),
                                          children: [
                                            if (itemsList.items==null && itemsList.items.isEmpty)
                                              Center()
                                            else
                                              ListView.builder(
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  itemCount: itemsList.items.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, int index) {
                                                    return ListTile(
                                                      onTap: () {

                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (__) =>
                                                                new DetailPage(
                                                                    itemsList
                                                                        .items[
                                                                    index].name.contains("Explore")? "Collection":itemsList
                                                                        .items[
                                                                    index].name,
                                                                    itemsList
                                                                        .items[
                                                                    index]
                                                                        .url)));
                                                      },
                                                      title: Text(
                                                          itemsList.items[index].name),
                                                    );
                                                  })
                                          ],
                                        ),
                                      );
                                    }),
                              )
                          ],
                        );
                      }),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

}
