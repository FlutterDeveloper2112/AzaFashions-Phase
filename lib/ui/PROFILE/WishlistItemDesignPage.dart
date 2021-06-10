import 'dart:io';

import 'package:azaFashions/bloc/ProfileBloc/WishListBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Profile/WishList.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'WishListItems.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class WishlistItemDesignPage extends StatefulWidget{
  final ScrollController controller;

  WishlistItemDesignPage({this.controller});
  @override
  ItemDesignState createState() => ItemDesignState();
}


class ItemDesignState extends State<WishlistItemDesignPage>{

  List<WishList> items;
  FirebaseAnalytics analytics = FirebaseAnalytics();


  @override
  void initState() {

    // ignore: unnecessary_statements
    wishList.getWishList();
    analytics.setCurrentScreen(screenName: "My Wishlist");
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    print("DISPOSE CALLED");

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height<700?  4.20: 3.85;
    // connectionStatus.toString()!="ConnectivityStatus.Offline"?  wishList.getWishList():"";

    return SingleChildScrollView(
      controller: widget.controller,
      scrollDirection: Axis.vertical,
      child: RefreshIndicator(
          child: StreamBuilder<WishListArray>(
              stream: wishList.wishList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data.list.length > 0) {
                    items = snapshot.data.list;
                    return Padding(
                      padding:  EdgeInsets.only(bottom:50.0),
                      child: Column(
                          children: <Widget>[
                            GridView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:  2/height,

                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 20,
                                ),
                                shrinkWrap:true,
                                itemCount: items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return  Container(

                                    color: Colors.white,
                                    child: new Container(

                                        child: WishListItem(
                                          wishlistList: items[index],
                                          designerImage: "${items[index].url}",
                                          name: "${items[index].name}",
                                          tag: "",
                                          designerName: "${items[index].designerName}",
                                          mrp: "${items[index].mrp}",
                                          id: items[index].id,
                                          sizeList: items[index].sizeList,
                                        )),
                                  );
                                }
                            ),



                          ]),
                    );
                  }
                  else{
                    return Column (
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.22,bottom:10),
                          child: ErrorPage(appBarTitle: "Your wishlist is empty",),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:10,left:40,right:40,bottom: 10),
                          child: Container(
                              width: double.infinity,
                              child:  RaisedButton(
                                color:  Colors.grey[300],
                                onPressed: () =>  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {return MainHome();})),
                                child: Text("SHOP NOW"),
                              )),
                        ),
                      ],
                    );

                  }
                }
                else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

              }),

          onRefresh: refreshData),
    );



  }


  Future<void> refreshData() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      wishList.getWishList();

    });
  }

}
