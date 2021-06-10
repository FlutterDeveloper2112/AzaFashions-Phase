
import 'dart:io';

import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/CatalogueDetails/CelebrityCatalogue.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CelebrityDetailPage extends StatefulWidget {
  @override
  _CelebrityDetailPageState createState() => _CelebrityDetailPageState();
}

class _CelebrityDetailPageState extends State<CelebrityDetailPage> {
  static int count = 1;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final connectivity=new ConnectivityService();
  var connectionStatus;
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    return Scaffold(
      appBar: AppBarWidget().myAppBar(
          context,
          "Celebrity Style ",
          scaffoldKey,webview: ""),
      body: connectionStatus.toString()!="ConnectivityStatus.Offline"?NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if(CelebrityCatalogue.count==1){
              print("Counter :$count");
            }
            if ( notification is ScrollEndNotification &&
                notification.metrics.atEdge &&
                notification.metrics.maxScrollExtent ==
                    notification.metrics.pixels) {
              setState(() {
                count++;
              });
            }

            return false;
          },
          child: CelebrityCatalogue(pageLinks: count,controller: controller,)):ErrorPage(
        appBarTitle: "You are offline.",
      ),
    );
  }
}
