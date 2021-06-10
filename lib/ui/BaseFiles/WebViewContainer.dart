
import 'dart:io';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  String webName;
  String type;
  WebViewContainer(this.url,this.webName,this.type);

  @override
  createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var _webViewController;

  final connectivity=new ConnectivityService();
  var connectionStatus;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
    analytics.setCurrentScreen(screenName: "${widget.webName}");
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    WebEngagePlugin.trackScreen("Product Listing Screen: ${widget.webName}");

  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("widget URL: ${widget.url}");
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          appBar: AppBarWidget().myAppBar(
              context,
              widget.webName,
              scaffoldKey,webview: "WEBVIEW"),
          body: connectionStatus.toString()!="ConnectivityStatus.Offline"?
          Builder(builder: (BuildContext context){
            return Container(
              child: Stack(
                children: <Widget>[
                  WebView(
                    initialUrl: "${widget.url}",
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) async{
                      Map<String, String> headers;
                      await HeaderFile().getHeaderDetails(context).then((value) {
                        headers=value;});
                      webViewController.loadUrl(widget.url,headers: headers);

                    },

                    onPageFinished: (String url) {
                      setState(() {
                        isLoading=false;

                      });
                      //hide you progressbar here
                    },
                  ),
                  isLoading ? Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(

                      ),
                    ),
                    backgroundColor: Colors.white.withOpacity(
                        0.70), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
                  ) : Stack()
                ],
              ),
            );}
          ):ErrorPage(appBarTitle: "You are offline.",)),
    );

  }
}