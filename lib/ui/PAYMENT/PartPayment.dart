
import 'package:azaFashions/bloc/LoginBloc/RegisterationBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:azaFashions/utils/CountryInfo.dart';


class PartPayment extends StatefulWidget {

  @override
  PartPaymentPageState createState() => PartPaymentPageState();
}

class PartPaymentPageState extends State<PartPayment> {
bool agree=false;
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  ScrollConfiguration(
        behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
    child: SingleChildScrollView(
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
                            "ORDER TOTAL : 180000",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: "Helvetica",
                                color: Colors.black),
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Pay 50% of your order now by debit/credit card & 50% by cash at the time of delivery. As per government rules, Cash payments will be accepted in new currency denominations only. Old ${CountryInfo.currencySymbol} 500 and ${CountryInfo.currencySymbol} 1000 notes will not be accepted. This payment option is applicable on orders above ${CountryInfo.currencySymbol} 80,000",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                fontFamily: "Helvetica",
                                color: Colors.black38),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              value: agree,
                              onChanged: (bool val) {
                                setState(() {
                                  agree= val;
                                });
                              }),

                          Align(
                            alignment: Alignment.center,
                            child:Text("I agree",textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontSize:14,fontFamily: "Helvetica",color: Colors.black),),
                          )],
                      ),
                    ),
                    Divider(thickness: 1,color: Colors.grey[400],),
                    _buildBody(context),
                    lowerHalf(context)
                  ],
                ),
              ));
  }



  Widget _buildBody(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 40),
        alignment: Alignment.center,
        width:double.infinity ,
        child:Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:10),
            ),
            Padding(
              padding: EdgeInsets.only(top:20,left:15,right: 15,bottom: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter Card Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: "Helvetica",
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: Colors.grey[500]),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top:5,left: 15,right: 15),
                child:Card(
                    color: Colors.grey[100],
                    child:Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 10,right: 10,top:10),
                            child:Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    Text("Card Number ",textAlign:TextAlign.start,style: TextStyle(fontSize:15,fontFamily: "Helvetica",color: Colors.black45),),
                                  ),
                                  Container(
                                      height: 50,
                                      padding: EdgeInsets.only(top:5),
                                      child: StreamBuilder<String>(
                                          stream: regisBloc.name,
                                          builder: (context,snapshot)=> TextFormField(
                                            onChanged: regisBloc.nameChanged,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black26),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black26),
                                                ),
                                                errorText: snapshot.error),
                                          )
                                      )
                                  ),

                                ])),
                        Padding(
                            padding: EdgeInsets.only(left: 10,right: 10,top:10),
                            child:Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    Text("Name on the Card ",textAlign:TextAlign.start,style: TextStyle(fontSize:15,fontFamily: "Helvetica",color: Colors.black45),),
                                  ),
                                  Container(
                                      height: 50,
                                      padding: EdgeInsets.only(top:5),
                                      child: StreamBuilder<String>(
                                          stream: regisBloc.name,
                                          builder: (context,snapshot)=> TextFormField(
                                            onChanged: regisBloc.nameChanged,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black26),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black26),
                                                ),
                                                errorText: snapshot.error),
                                          )
                                      )
                                  ),

                                ])),
                        Padding(
                            padding: EdgeInsets.only(left: 10,right: 10,top:10),
                            child:Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    Text("Debit/Credit Type ",textAlign:TextAlign.start,style: TextStyle(fontSize:15,fontFamily: "Helvetica",color: Colors.black45),),
                                  ),
                                  Container(
                                      height: 50,
                                      padding: EdgeInsets.only(top:5),
                                      child: StreamBuilder<String>(
                                          stream: regisBloc.name,
                                          builder: (context,snapshot)=> TextFormField(
                                            onChanged: regisBloc.nameChanged,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black26),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black26),
                                                ),
                                                errorText: snapshot.error),
                                          )
                                      )
                                  ),

                                ])),
                        Padding(
                            padding: EdgeInsets.only(left: 5,right: 10,top:10,bottom: 20),
                            child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:   Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child:
                                          Text("Expiry Date ",textAlign:TextAlign.start,style: TextStyle(fontSize:15,fontFamily: "Helvetica",color: Colors.black45),),
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            Container(
                                                width: 150,
                                                height: 50,
                                                padding: EdgeInsets.only(top:5),
                                                child: StreamBuilder<String>(
                                                    stream: regisBloc.name,
                                                    builder: (context,snapshot)=> TextFormField(
                                                      onChanged: regisBloc.nameChanged,
                                                      keyboardType: TextInputType.text,
                                                      decoration: InputDecoration(
                                                          enabledBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black26),
                                                          ),
                                                          focusedBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black26),
                                                          ),
                                                          errorText: snapshot.error),
                                                    )
                                                )
                                            )),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                        Text("CVV ",textAlign:TextAlign.start,style: TextStyle(fontSize:15,fontFamily: "Helvetica",color: Colors.black45),),
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child:
                                          Container(
                                              width: 80,
                                              height: 50,
                                              padding: EdgeInsets.only(top:5),
                                              child: StreamBuilder<String>(
                                                  stream: regisBloc.name,
                                                  builder: (context,snapshot)=> TextFormField(
                                                    onChanged: regisBloc.nameChanged,
                                                    keyboardType: TextInputType.text,
                                                    decoration: InputDecoration(
                                                        enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.black26),
                                                        ),
                                                        focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.black26),
                                                        ),
                                                        errorText: snapshot.error),
                                                  )
                                              )
                                          )),
                                    ],
                                  )




                                ])),


                      ],
                    )
                ))
          ],
        ));
  }


  Widget lowerHalf(BuildContext context) {
    return Center(
        child:Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(left:20,top:20,bottom:10,right:20),

            width: double.infinity,


            decoration: BoxDecoration(
              border: Border(top: BorderSide( //                    <--- top side
                color: Colors.grey[300],
                width: 3.0,
              )),
              color: Colors.transparent,

            ),
            child:  Container(

              height: MediaQuery.of(context).size.height*0.085,
              decoration: BoxDecoration(

                color: Colors.red[600],

              ),
              child: FlatButton(
                onPressed: () {


                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red[600],
                      width: 1,
                      style: BorderStyle.solid),
                  // borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Text('PAY SECURELY 60,000', textAlign: TextAlign.center,
                  style: TextStyle(fontWeight:FontWeight.bold,fontFamily: "Helvetica",color: Colors.white,fontSize: 15),),
                color: HexColor("#ad2810"),),
            ),
          ),
        ));
  }

}