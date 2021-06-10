import 'dart:io';

import 'package:azaFashions/bloc/DesignerBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class DesignerView extends StatefulWidget {
  List<Widget> categories;
  final String img,description;
  bool isFollowing;
  final int id;

  DesignerView({this.isFollowing, this.id, this.img, this.description});

  @override
  _DesignerViewState createState() => _DesignerViewState();
}

class _DesignerViewState extends State<DesignerView> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  var connectionStatus;
  final connectivity=new ConnectivityService();
  final ScrollController controller= new ScrollController();


  @override
  void initState() {
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    super.initState();
  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    return Column(
      children: <Widget>[
        _firstDesignModule(context),
        Padding(
            padding: EdgeInsets.only(right: 10, top: 20,bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.7,
              height: 35,//50 changed to 40
              child: FlatButton.icon(
                onPressed: () async{
                  print(widget.isFollowing);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  print(prefs.getBool("browseAsGuest"));
                  if (prefs.getBool("browseAsGuest")) {
                    CustomBottomSheet().getLoginBottomSheet(context);
                  }
                  else{
                  setState(() {
                    if (!widget.isFollowing) {
                      designerBloc.followDesigner(widget.id, "follow");
                      designerBloc.follow.listen((event) {
                        if(event.success.isNotEmpty && event.success!="Product Doesn't Exists or is Inactive"){
                          if (mounted) {
                            setState(() {
                              widget.isFollowing = true;
                            });

                          }
                        } else {

                          return ToastMsg().getFailureMsg(context, event.error);
                        }
                      });
                    }
                    else {
                      designerBloc.followDesigner(widget.id, "unfollow");
                      designerBloc.follow.listen((event) {
                        print(event);
                        if(event.success.isNotEmpty && event.success!="Product Doesn't Exists or is Inactive"){
                          if (mounted) {
                            setState(() {
                              widget.isFollowing = false;
                            });

                          }
                        } else {

                          return ToastMsg().getFailureMsg(context, event.error);
                        }
                      });
                    }
                  });
                }},
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(1.0))),
                label: Text(
                  widget.isFollowing ? 'UNFOLLOW' : "FOLLOW",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily:"Helvetica",color: Colors.black, fontSize: 15),
                ),
                icon: widget.isFollowing
                    ? new Icon(Icons.star)
                    : new Icon(Icons.star_border),
                color: Colors.transparent,
              ),
            )),
        // Catalogue("DESIGNER",widget.img,"","")
        // getDetails()
      ],
    );
  }



  Widget _firstDesignModule(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
         Container(
            padding: EdgeInsets.only(left:5,right: 5,top: 15,bottom:10),
            child: Container(

              width:410,
              // height: MediaQuery.of(context).size.height * 0.55,
              height:165/*TargetPlatform.iOS != null?190:175*/,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                    image:CachedNetworkImageProvider(widget.img),                    //Can use CachedNetworkImage
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
            ),
          ),

        Positioned(
            bottom:TargetPlatform.iOS != null?-65:-35,
            left: 18,
            right: 18,
            child:Padding(
              padding: EdgeInsets.only(left:15,right: 15,top: 15,bottom: 15),
              child: Container(
                width: double.infinity,
                height: widget.description.length>=100?140:120,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    widget.description!=""? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left:25,right:25,top: 10),
                        child: Text("${widget.description}", textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.normal,
                              fontSize: 15,
                              fontFamily: "Helvetica",
                              color: Colors.black),),
                      ),
                    ):Padding(padding: EdgeInsets.all(0)),
                  ],
                ),

              ),
            )),

      ],
    );
  }

}
