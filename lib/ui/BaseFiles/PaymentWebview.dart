import 'dart:convert';
import 'dart:io';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/ERRORS/error.dart';
import 'package:azaFashions/ui/ORDERSUCCESS/ThankYou.dart';
import 'package:azaFashions/ui/PAYMENT/PaymentPage.dart';
import 'package:azaFashions/utils/HeaderFile.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
class PaymentWebView extends StatefulWidget {
  String initialUrl,callBackUrl;

  PaymentWebView(this.initialUrl,this.callBackUrl);
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<PaymentWebView> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  bool isLoading = true;
  String transcId;
  String baseUrl,initialUrl;

  final connectivity=new ConnectivityService();
  var connectionStatus;

  @override
  void initState() {
    super.initState();
    analytics.setCurrentScreen(screenName: "Payment Screen");

    WebEngagePlugin.trackScreen("Payment Screen}");

    setState(() {
      baseUrl=HeaderFile().baseUrl.substring(0,HeaderFile().baseUrl.length-1);
      print("BASE URL: $baseUrl");
    });
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;
  }

  @override
  void dispose() {
    connectivity.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: connectionStatus.toString()!="ConnectivityStatus.Offline"?SafeArea(
          top:true,
          //appBar
          child: Container(
            child: Stack(
              children: <Widget>[
                WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) async{
                    Map<String, String> headers;
                    await HeaderFile().getHeaderDetails(context).then((value) {
                      headers=value;});
                     webViewController.loadUrl("$baseUrl${widget.initialUrl}", headers: headers);
                  },
                  javascriptChannels:Set.from([
                    JavascriptChannel(
                        name: 'PaymentGatewayWindow',
                        onMessageReceived: (JavascriptMessage message) {
                          print("Toast MSG: ${message.message}");
                          Map<String, dynamic> transData = jsonDecode(message.message);
                          transcId=transData["order_id"].toString();
                          print("Transcation ID: ${transcId}");
                        })
                  ]),
                  onPageFinished: (String url) {
                    setState(() {
                      isLoading=false;
                      print("WEBVIEW url: $url");
                      if(url=='https://dormammu.azafashions.com/v1${widget.callBackUrl}'){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {return ThankYou(widget.initialUrl,transcId );}));
                      }
                      else if(url=="${HeaderFile().baseUrl}payment-gateway/cancel-transaction"){
                        ToastMsg().getFailureMsg(context, "Payment Transaction Cancelled.");
                        Navigator.of(context).pop();

                      }
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
          ),
        ):ErrorPage(appBarTitle: "You are offline.",)),
    );
  }


}



