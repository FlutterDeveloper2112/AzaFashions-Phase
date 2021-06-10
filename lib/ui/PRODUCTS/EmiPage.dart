import 'package:azaFashions/bloc/ProductBloc/ProductDetailBloc.dart';
import 'package:azaFashions/models/ProductDetail/EmiDetails.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class EmiPage extends StatefulWidget {
  final String youPay, display_youpay;

  const EmiPage({Key key, this.youPay,this.display_youpay}) : super(key: key);

  @override
  _EmiPageState createState() => _EmiPageState();
}

class _EmiPageState extends State<EmiPage> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final productDetailsBloc = ProductDetailsBloc();
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    productDetailsBloc.emiDetails(widget.youPay);
   WebEngagePlugin.trackScreen("EMI PAGE");
    analytics.setCurrentScreen(screenName: "EMI Page");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBarWidget().myAppBar(context, "EMI Details", scaffoldKey),
        body: StreamBuilder<EmiDetails>(
            stream: productDetailsBloc.emi,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom:5,left:15),
                        child: Text("EMI Options for : Rs ${widget.display_youpay} ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: "Helvetica")),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.emi.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, int index) {
                            print("EMI Count:${snapshot.data.emi.length} ");

                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        snapshot.data.emi[index].bankImage!=""?    Image.network(
                                          snapshot.data.emi[index].bankImage,
                                          height: 25,
                                        ):Center(),
                                        snapshot.data.emi[index].bankImage==""?Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              snapshot.data.emi[index].bankName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Helvetica"),
                                            )):Center(),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  GridView.builder(
                                      padding: EdgeInsets.all(15),
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 4 / 4,
                                        crossAxisSpacing: 15.0,
                                        mainAxisSpacing: 15.0,
                                      ),
                                      itemCount: snapshot
                                          .data.emi[index].emiOptions.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, int i) {
                                        return Column(
                                          children: [
                                            Text(
                                                "${snapshot.data.emi[index].emiOptions[i].tenure} Months",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontFamily: "Helvetica")),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color:
                                                    const Color(0xfff5f5f5),
                                                    border: Border.all(
                                                        color: Colors.grey[300],
                                                        width: 1.5)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceAround,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                        "Rs ${snapshot.data.emi[index].emiOptions[i].emi}",
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                            "Helvetica"),
                                                      ),
                                                    ),
                                                    Text(
                                                      "(per month)",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                          "Helvetica"),
                                                    ),
                                                    Text(
                                                      "Finance Charges",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                          "Helvetica"),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
                                                      child: Text(
                                                        "Rs. ${snapshot.data.emi[index].emiOptions[i].interestPayable} (${snapshot.data.emi[index].emiOptions[i].interestRate}%)",
                                                        style: TextStyle(
                                                            fontFamily:
                                                            "Helvetica",
                                                            color: Colors.black),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
