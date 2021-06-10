import 'package:azaFashions/bloc/ProfileBloc/OrderBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Orders/ItemListing.dart';
import 'package:azaFashions/models/Orders/OrderListing.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/OrderModule/ItemPattern.dart';
import 'package:azaFashions/utils/SupportDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:webengage_flutter/webengage_flutter.dart';



class OrderScreen extends StatefulWidget{
  @override
  ItemDesignState createState() => ItemDesignState();
}


class ItemDesignState extends State<OrderScreen>{
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final connectivity=new ConnectivityService();
  var connectionStatus;

  @override
  void initState() {
    super.initState();

    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    connectionStatus.toString()!="ConnectivityStatus.Offline"?order_bloc.fetchAllOrderData():"";
    WebEngagePlugin.trackScreen("Order Screen");
    analytics.setCurrentScreen(screenName: "Order Screen");


  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);

    connectionStatus.toString()!="ConnectivityStatus.Offline"?order_bloc.fetchAllOrderData():"";
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar:AppBarWidget().myAppBar(context, "My Orders",scaffoldKey),
          body:  connectionStatus.toString()!="ConnectivityStatus.Offline"?ScrollConfiguration(
          behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
          child:SingleChildScrollView(
              child:Column(
                  children:<Widget> [
                    StreamBuilder<OrderListing>(
                        stream: order_bloc.fetchOrderList,
                        builder: (context, snapshot) {
                          if(snapshot.connectionState==ConnectionState.active){
                            if(snapshot.data.order_modellist!=null){
                              List<ItemListing> _items = snapshot.data.order_modellist;
                              return Column(
                                  children:<Widget> [
                                    new ListView.builder(
                                      shrinkWrap: true,
                                      physics:  NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(left:10.0,right: 10,top: 15,bottom: 10),
                                      itemCount: _items.length,
                                      itemBuilder: (BuildContext context, int index) => new Container(
                                        color: Colors.white,
                                        child: new Column(
                                            children: <Widget>[
                                              ItemPattern(
                                                tag:"MyOrders",
                                                screen_name: "MyOrders",
                                                order_Date:"${_items[index].order_date}" ,
                                                order_id:_items[index].order_id,
                                                customer_id:_items[index].custom_order_id,
                                                model: _items[index].order_model.model,
                                              )
                                            ]),
                                      ),
                                    ),
                                    contactUs(context)
                                  ]);
                            }
                            else{
                              return Column (
                                children: [
                                  Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),child:ErrorPage(appBarTitle: "${snapshot.data.error.toString()}",)),
                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.2,right:MediaQuery.of(context).size.width*0.2),
                                      child:  RaisedButton(
                                        color:  Colors.grey[300],
                                        onPressed: () =>  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {return MainHome();})),
                                        child: Text("SHOP NOW"),
                                      )),
                                ],
                              );
                            }

                          }
                          else{
                            return Center(child: CircularProgressIndicator(),);
                          }
                        }
                    )

                  ])
          )):ErrorPage(appBarTitle: "You are offline.",)),
    );
  }
  Widget contactUs(BuildContext context){
    return  Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Contact us if you have any questions",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Helvetica",
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
        ),
        Container(
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: InkWell(
                    onTap: () async {
                      var whatsApp =
                      await SupportDetails()
                          .getWhatsAppDetails();
                      // print(whatsApp);
                      await launch(whatsApp);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: HexColor("#f5f5f5"),
                            border: Border.all(
                              color: Colors.grey[400],
                            )),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10),
                              child: Image.asset(
                                "images/whatsapp.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10),
                              child: Align(
                                alignment:
                                Alignment.center,
                                child: Text(
                                  "WHATSAPP",
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                      fontFamily:
                                      "Helvetica",
                                      fontWeight:
                                      FontWeight
                                          .normal,
                                      fontSize: 10,
                                      color:
                                      Colors.black),
                                ),
                              ),
                            ),
                          ],
                        )),
                  )),
              Expanded(
                  child: InkWell(
                    onTap: () async {
                      var mobile =
                      await SupportDetails()
                          .getMobileSupport();
                      await launch("tel:$mobile");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: HexColor("#f5f5f5"),
                          border: Border(
                            top: BorderSide(
                                width: 1.0,
                                color:
                                Colors.grey[400]),
                            bottom: BorderSide(
                                width: 1.0,
                                color:
                                Colors.grey[400]),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10),
                              child: Icon(
                                Icons.phone,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10),
                              child: Align(
                                alignment:
                                Alignment.center,
                                child: Text(
                                  "PHONE",
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                      fontFamily:
                                      "Helvetica",
                                      fontWeight:
                                      FontWeight
                                          .normal,
                                      fontSize: 10,
                                      color:
                                      Colors.black),
                                ),
                              ),
                            ),
                          ],
                        )),
                  )),
              Expanded(
                  child: InkWell(
                    onTap: () async {
                      var email = await SupportDetails()
                          .getEmailSupport();

                      await launch("mailto:${email}");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: HexColor("#f5f5f5"),
                            border: Border.all(
                                color:
                                Colors.grey[400])),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10),
                              child: Icon(
                                Icons.mail_outline,
                                color: Colors.black87,
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10),
                              child: Align(
                                alignment:
                                Alignment.center,
                                child: Text(
                                  "EMAIL",
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                      fontFamily:
                                      "Helvetica",
                                      fontWeight:
                                      FontWeight
                                          .normal,
                                      fontSize: 10,
                                      color:
                                      Colors.black),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ))
            ],
          ),
        ),
      ],
    );
  }




}
