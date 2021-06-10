import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:azaFashions/ui/CatalogueDetails/Catlogue.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  final String appBarTitle;

   ErrorPage({Key key, this.appBarTitle}) : super(key: key);
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String image, subtitle, btnText;
  double imgHeight;
  String title="";


  AppBar appBar;

  @override
  Widget build(BuildContext context) {
    MyFilter.filterModel= new List<FilterModel>();
    CatlogueDesignState.clearData=0;

    final height = MediaQuery.of(context).size.height*0.15;
    if (widget.appBarTitle == "Log in") {
      image = "images/no_notification.png";
      title = 'Please login or register to access your favorite designers';
      subtitle = '';
      imgHeight = height;
    }else if (widget.appBarTitle == "You are offline.") {
      image = "images/no_internet.png";
      title = 'You are offline.';
      subtitle = 'Please check your internet connection.';
      btnText = 'RETRY';
      imgHeight = height;
      appBar = AppBarWidget().myAppBar(context, "", scaffoldKey);
    } else if (widget.appBarTitle == "Hey, it feels so light!") {
      image = "images/empty_bag.png";
      title = 'Hey, it feels so light!';
      subtitle = 'Your bag is empty. Let’s add some items.';
      imgHeight = height;
    } else if (widget.appBarTitle == "Your wishlist is empty") {
      image = "images/empty_wishlist.png";
      title = 'Your wishlist is empty';
      subtitle = 'Let’s add some items.';
      imgHeight = height;
     } else if (widget.appBarTitle == "No notification yet") {
      image = "images/no_notification.png";
      title = "No notification yet";
      subtitle = "We’ll let you know when we’ve got something new for you.";
      imgHeight =height;
    }else if(widget.appBarTitle=="No Measurements Found!") {
      image = "images/empty_bag.png";
      title = "No Measurements Found";
      subtitle = "";
      appBar = AppBarWidget().myAppBar(context, "Notification", scaffoldKey);
      imgHeight = height;
    }
    else if(widget.appBarTitle=="Address Not Found") {
      image = "images/empty_bag.png";
      title = "${widget.appBarTitle.toUpperCase()}";
      subtitle = "";
      appBar = AppBarWidget().myAppBar(context, "Notification", scaffoldKey);
      imgHeight = height;
    }
    else if(widget.appBarTitle=="No Designers Found") {
      image = "images/no_notification.png";
      title = "${widget.appBarTitle.toUpperCase()}";
      subtitle = "Follow Your Favourite Designers";
     // appBar = AppBarWidget().myAppBar(context, "Notification", scaffoldKey);
      imgHeight =height;
    }
    else {
      image = "images/empty_bag.png";
      title = "No Items Found";
      subtitle = "No Collection for ${widget.appBarTitle}";
      imgHeight = height;
    }
    return Center(
        child: Container(/*height:250,*/child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
            height: imgHeight,
            child: Image.asset(
              image,
              alignment: Alignment.center,
            )),
        Text(
          title,
          textAlign: TextAlign.center,

          style: TextStyle(fontSize: 16,fontFamily: "PlayfairDisplay"),
        ),
        subtitle!=""? Padding(padding: EdgeInsets.all(10),
        child: Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14,fontFamily: "Helvetica"),
        )):Center(),

      ],
    )));
  }
}
