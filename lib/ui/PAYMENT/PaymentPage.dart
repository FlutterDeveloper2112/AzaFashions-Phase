

import 'package:azaFashions/WebEngageDetails/UserTrackingDetails.dart';
import 'package:azaFashions/utils/CountryInfo.dart';
import 'dart:convert';
import 'dart:io';
import 'package:azaFashions/bloc/PaymentBloc/PaymentBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/models/Payment/PaymentOptions.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/BaseFiles/PaymentWebview.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PAYMENT/CashOnDelivery.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class PaymentPage extends StatefulWidget {
  String total_amt_payable,mobileNo;
  PaymentPage(this.total_amt_payable,this.mobileNo);
  @override
  PaymentModePage createState() =>PaymentModePage();
}

class PaymentModePage extends State<PaymentPage> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _value=true;
  List<PaymentModel> paymentModel;
  UserLogin _userLogin = new UserLogin();
  String selectedOption="",url,url_tag,callbackUrl,title;
  final connectivity=new ConnectivityService();
  var connectionStatus;

  @override
  void initState() {
    super.initState();
    paymentModel = new List<PaymentModel>();
    paymentBloc.fetchAllPaymentItems();
    WebEngagePlugin.trackScreen("Payment Page Screen");
    analytics.setCurrentScreen(screenName: "Payment Page");

    getUserMobileNo();
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  getUserMobileNo() async{
    sharedPreferences = await SharedPreferences.getInstance();
    _userLogin=UserLogin.fromJson(jsonDecode(sharedPreferences.getString('userDetails')));

  }

  @override
  Widget build(BuildContext context) {
      connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
      // connectionStatus.toString()!="ConnectivityStatus.Offline"?  paymentBloc.fetchAllPaymentItems():"";


    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar:AppBarWidget().myAppBar(context, "Payment Method",scaffoldKey),
          body:connectionStatus.toString()!="ConnectivityStatus.Offline"?StreamBuilder(
            stream: paymentBloc.fetchPaymentItemList,
            builder: (context, AsyncSnapshot<PaymentOptions> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                            alignment: Alignment.center,
                            width:double.infinity ,
                            child: Column(
                                children: <Widget>[
                                  Container(
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "ORDER TOTAL : ${CountryInfo.currencySymbol} ${widget.total_amt_payable}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              fontFamily: "Helvetica",
                                              color: Colors.black),
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(top:15,left:15,right: 15,bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Select payment method",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: "Helvetica",
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Colors.grey[500]),
                                      ),
                                    ),
                                  ),
                                  new ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10, top: 5, bottom: 7),
                                    itemCount: snapshot.data.payment_model.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      paymentModel=snapshot.data.payment_model;
                                      return new Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 5, top: 5),
                                                      child: Divider(
                                                        color: Colors.grey[400],),
                                                    ),
                                                    addPaymentOptions(index,
                                                        snapshot.data
                                                            .payment_model[index]
                                                            .title),

                                                  ],
                                                ),
                                              ),

                                            ],
                                          )
                                      );
                                    }
                                  ),

                                ]))),

                    lowerHalf(context)

                  ],
                );
              }
              else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          ):ErrorPage(appBarTitle: "You are offline.",)),
    );
  }
  Widget lowerHalf(BuildContext context) {
    return    Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: Platform.isIOS?25:10, left: 20, right: 20),
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(

                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                   ),
                child: FlatButton(
                  onPressed: () async{
                    if(selectedOption!=""){
                    if (selectedOption == "Cash on Delivery") {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (__) => new CashOnDelivery(widget.mobileNo,url)));
                    }
                    else{
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (__) => new PaymentWebView(url,callbackUrl,)));
                    }
                    UserTrackingDetails().paymentPage(widget.total_amt_payable,selectedOption);


                  }
                    else{
                      ToastMsg().getFailureMsg(context, "Please select the payment method.");
                 }
                    },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.red[900],
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Text(
                    'PROCEED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Helvetica",
                        color: Colors.white,
                        fontSize: 15),
                  ),
                  color: Colors.red[900],
                ),
              ),
            ),
          ),
        ));
  }


  Widget addPaymentOptions(int btnValue, String title) {
    return RadioListTile(
      title:Text("$title",textAlign:TextAlign.start,style: TextStyle(fontSize:15,fontFamily: "Helvetica",color: Colors.black54,fontWeight: btnValue!=null?FontWeight.bold:FontWeight.normal),),
      activeColor: Colors.black,
      value: paymentModel[btnValue].title,
      groupValue: selectedOption,
      onChanged: (value){
        setState(() {
          print(value);
          selectedOption=value;
          url=paymentModel[btnValue].url;
          url_tag=paymentModel[btnValue].url;
          callbackUrl=paymentModel[btnValue].callback_url;
          title=title;
        });
      },
    );
  }


}
