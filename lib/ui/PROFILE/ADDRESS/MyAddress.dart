import 'dart:io';
import 'package:azaFashions/bloc/ProfileBloc/AddressBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Profile/ProfileAddressList.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/PROFILE/ADDRESS/AddAddress.dart';
import 'package:azaFashions/ui/HEADERS/Drawer/SideNavigation.dart';
import 'package:azaFashions/ui/Headers/AppBar/AppBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import 'package:firebase_analytics/firebase_analytics.dart';


class MyAddress extends StatefulWidget{
  @override
  MyAddressState createState() => MyAddressState();
}


class MyAddressState extends State<MyAddress> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final connectivity=new ConnectivityService();
  var connectionStatus;



  @override
  void initState() {
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    analytics.setCurrentScreen(screenName: "My Address");
    WebEngagePlugin.trackScreen("My Address Page");

    // TODO: implement initState
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
    connectionStatus.toString()!="ConnectivityStatus.Offline"?  addressBloc.fetchAddressList("address"):"";

    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.of(context).pop(true);
      },

      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar:AppBarWidget().myAppBar(context, "My Addresses",scaffoldKey),
            drawer: Drawer(
                child:SideNavigation(title: "My Address",)
            ),
            body: connectionStatus.toString()!="ConnectivityStatus.Offline"?RefreshIndicator(
                child: StreamBuilder(
                  stream: addressBloc.fetchAddressData,
                  builder: (context, AsyncSnapshot<ProfileAddressList> snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data.addressModel!=null && snapshot.data.addressModel.length>0){
                        return   Column(
                            children:<Widget> [
                              Expanded(
                                  flex:7,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics:  AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(10.0),
                                    itemCount: snapshot.data.addressModel.length,
                                    itemBuilder: (BuildContext context, int index) =>
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(top: 10),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(snapshot.data.addressModel[index].isDefault==1?"DEFAULT":"OTHER",textAlign:TextAlign.left,style: TextStyle(fontSize :16, fontWeight:FontWeight.bold,fontFamily: "Helvetica",color: Colors.black),),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 2,
                                                      child:  Padding(
                                                        padding: EdgeInsets.only(top: 5,bottom: 5),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(snapshot.data.addressModel[index].firstName  + " " +snapshot.data.addressModel[index].lastName,textAlign:TextAlign.left,style: TextStyle(fontSize :16, fontWeight:FontWeight.normal,fontFamily: "Helvetica",color: Colors.black),),
                                                        ),
                                                      )
                                                  ),

                                                  Padding(
                                                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                                    child: RaisedButton(
                                                      textColor: Colors.white,
                                                      color: Colors.grey[300],
                                                      child: Text(snapshot.data.addressModel[index].type,textAlign:TextAlign.left,style: TextStyle(fontSize :13, fontWeight:FontWeight.normal,fontFamily: "Helvetica",color:Colors.black),),
                                                      onPressed: () {},
                                                      shape: new RoundedRectangleBorder(
                                                        borderRadius: new BorderRadius.circular(30.0),
                                                      ),
                                                    ),
                                                  )


                                                ],
                                              ),

                                              Padding(
                                                padding: EdgeInsets.only(bottom: 5),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(snapshot.data.addressModel[index].addressOne + "\n"+snapshot.data.addressModel[index].cityName + " : " + snapshot.data.addressModel[index].postalCode + "\n"+snapshot.data.addressModel[index].stateName + " , "+snapshot.data.addressModel[index].countryName,textAlign:TextAlign.left,style: TextStyle(fontSize :15, fontWeight:FontWeight.normal,fontFamily: "Helvetica",color:HexColor("#666666")),),
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5,bottom: 10),
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text("Mobile :",textAlign:TextAlign.left,style: TextStyle(fontSize :15, fontWeight:FontWeight.normal,fontFamily: "Helvetica",color:HexColor("#666666")),),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5,bottom: 10),
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(snapshot.data.addressModel[index].mobileNo,textAlign:TextAlign.left,style: TextStyle(fontSize :14, fontWeight:FontWeight.bold,fontFamily: "Helvetica",color: Colors.black),),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(right:15,top: 5,bottom: 5),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          addressBloc.removeAddress(context,snapshot.data.addressModel[index].addressId);
                                                          await refreshData();

                                                        },
                                                        child:Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text("REMOVE",textAlign:TextAlign.left,style: TextStyle(fontSize :15, fontWeight:FontWeight.normal,fontFamily: "Helvetica",color: Colors.black),),
                                                        ),
                                                      )
                                                  ),
                                                  Container(
                                                    width: 5,
                                                    height: 18,
                                                    child: VerticalDivider(color: Colors.black,thickness: 2,),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(left:25,right:30,top: 5,bottom: 5),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          addressBloc.clearControllerData();
                                                          final result=await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return AddAddress("EDIT","My Address",snapshot.data.addressModel[index]);}));
                                                          result!=null?await refreshData():null;

                                                        },
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text("EDIT",textAlign:TextAlign.left,style: TextStyle(fontSize :15, fontWeight:FontWeight.normal,fontFamily: "Helvetica",color: Colors.black),),
                                                        ),
                                                      )
                                                  ),
                                                ],
                                              )
                                            ],

                                          ),
                                        ),

                                    separatorBuilder: (context, index) {
                                      return Container(
                                          padding: EdgeInsets.only(left:10.0,right: 10),
                                          child: Divider(color: Colors.grey[400],)
                                      );
                                    },
                                  )),
                              lowerHalf(context)



                            ]);
                      }
                      else{
                        return Column (
                          children: [
                            Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),child:ErrorPage(appBarTitle: "Address Not Found",)),
                            Container(
                              height: 43,
                                width: double.infinity,
                                padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.2,right:MediaQuery.of(context).size.width*0.2),
                                child:  RaisedButton(
                                  color:  Colors.grey[300],
                                  onPressed: () async {
                                   final result= await  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return AddAddress("ADD","My Address");}));
                                   result!=null? await refreshData():null;
                                  },
                                  child: Text(
                                    'ADD ADDRESS',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Helvetica",
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),      )),
                          ],
                        );
                      }

                    }
                    else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                onRefresh: refreshData
            ):ErrorPage(appBarTitle: "You are offline.",)
        ),
      ),
    );
  }

  Future<void> refreshData() async{
    await Future.delayed(Duration(seconds: 1));

    if(mounted){
      setState(() {
        addressBloc.fetchAddressList("address");
      });
    }
  }
  Widget lowerHalf(BuildContext context) {
    return Center(
        child:  Align(
            alignment: Alignment.bottomCenter,
            child:Padding(
                padding: EdgeInsets.only(top:5, bottom: Platform.isIOS?25:10,left:20,right: 20),
                child:Container(
                  color: Colors.grey[300],
                  width: double.infinity,
                  height: 43,
                  child:
                  FlatButton(
                    onPressed: () async {
                   final result=   await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return AddAddress("ADD","My Address");}));
                      result!=null?await refreshData():null;
                    },
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[300],width: 1,style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(1.0))
                    ),
                    child: Text(
                      'ADD ADDRESS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black),
                    ),   color: Colors.grey[300],),
                )
            )));
  }
}
