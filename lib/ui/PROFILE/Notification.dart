
import 'package:azaFashions/models/ModelData.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PROFILE/MyWishlist.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';



class NotificationList extends StatefulWidget{
  @override
  NotificationListState createState() => NotificationListState();
}


class NotificationListState extends State<NotificationList> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final _items = [
    IntroModelData("images/intro_image_two.png","Yesterday","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"),
    IntroModelData("images/intro_image_four.png","Today","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"),
    IntroModelData("images/intro_image_five.png","9.24 AM","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"),
    IntroModelData("images/intro_image_two.png","25/08/12","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"),
    IntroModelData("images/intro_image_four.png","Today","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"),
   ];
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar:AppBarWidget().myAppBar(context, "Notifications",scaffoldKey),
          drawer: Drawer(
              child:SideNavigation(title: "Notifications",)
          ),
          body: ScrollConfiguration(
      behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
      child:SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:Column(
                  children:<Widget> [
                    new ListView.separated(
                      shrinkWrap: true,
                      physics:  NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(10.0),
                      itemCount: _items.length,
                      itemBuilder: (BuildContext context, int index) => new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child:   Container(
                              width: 40,
                              height:40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage(_items[index].imageAsset),
                                  //Can use CachedNetworkImage
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                           flex:2,
                              child:Align(
                                  alignment: Alignment.centerLeft,
                                  child:Padding(
                                    padding: EdgeInsets.only(left: 5,bottom: 10,top: 10),
                                  child:Container(
                                      child:Text(
                                    "${_items[index].description}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                        fontFamily: "Helvetica",
                                        color: Colors.black),
                                  ))))
                          ),
                          Padding(
                              padding: EdgeInsets.only(left:5,bottom: 5),
                              child:Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${_items[index].title}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10,
                                      fontFamily: "Helvetica",
                                      color: Colors.grey),
                                ),
                              )),
                        ],
                      ),
                      separatorBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(left:10.0,right: 10),
                          child: Divider()
                        );
                      },
                    ),


                  ])
          ))),
    );
  }


}
