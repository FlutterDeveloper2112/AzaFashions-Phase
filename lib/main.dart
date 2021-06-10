import 'dart:async';
import 'dart:io';
import 'package:azaFashions/MyApp.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';
import 'package:azaFashions/networkprovider/LoginProvider.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/HOME/HomeScreen/afh_main_home.dart';
import 'package:azaFashions/ui/HOME/IntroScreens/afis_intro_screen.dart';
import 'package:azaFashions/ui/HOME/IntroScreens/afss_start_shopping.dart';
import 'package:azaFashions/ui/HOME/Maintenance.dart';
import 'package:country_codes/country_codes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'enum/ConnectivityStatus.dart';
import 'utils/SessionDetails.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runZonedGuarded(() {
    runApp(
        new MaterialApp(
          home: new AzaAPP(),
          debugShowCheckedModeBanner: false,
        )
    );
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  await FirebaseAnalytics().setAnalyticsCollectionEnabled(true);
}


class AzaAPP extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityStatus>(create: (context)=>ConnectivityService().connectionStatusController.stream, initialData: null)
      ],
      child: MaterialApp(
        initialRoute: "/",
        theme: ThemeData(primaryColor: Colors.white),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/homePage': (context) => MainHome(),
        },
        navigatorObservers: [RouteObserver(), NavigatorObserver(),FirebaseAnalyticsObserver(analytics: analytics),],
      ),
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  SessionDetails _sessionDetails = SessionDetails();
  bool skippedIntro;
  String _platformVersion = 'Unknown';
  WebEngagePlugin _webEngagePlugin;



  startTime() async {
    LoginProvider().getBagCount(context);
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    await LoginProvider().getIntroScreenList(context);
    initPlatformState();
    initWebEngage();

    await CountryCodes.init();
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if(IntroModelList.maintenanceMode!=null && IntroModelList.maintenanceMode>0){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) {
                return Maintenance();
              }));

    }
    else if(IntroModelList.force_update!=null && IntroModelList.force_update>0){
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return MediaQuery(
              data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: AlertDialog(
                title: Text(
                    "Force Update",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: "PlayfairDisplay",
                        fontSize: 22.0,
                        color: Colors.black)),
                content: Text(
                    "This version is no longer supported. Please update your app to stay in and to know about current fashion trends, new arrivals from top designers, latest offers and more.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: "Helvetica-Condensed",
                      fontSize: 15.0,
                      color: Colors.black),),

                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        child: Text(
                          "CANCEL",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: "Helvetica-Condensed",
                              fontSize: 15.0,
                              color: Colors.black),),
                        onPressed:
                            () async {
                          SystemNavigator.pop();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "OK",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: "Helvetica-Condensed",
                              fontSize: 15.0,
                              color: Colors.black),),
                        onPressed:
                            () async {
                          Platform.isIOS? await launch("https://apps.apple.com/in/app/aza/id1541608860"):await launch("https://play.google.com/store/apps/details?id=com.azaOnline.azaFashions");

                        },
                      )
                    ],
                  )

                ],
              ),
            );
          });
    }
    else{
      if (_sharedPreferences.getBool("skippedIntro") != null && _sharedPreferences.getBool("skippedIntro") == true) {
        print("CONDITION ${_sharedPreferences.getBool("loginStatus")==true && IntroModelList.loginSessionStatus==true}");
        if(_sharedPreferences.getBool("loginStatus")==true && IntroModelList.loginSessionStatus==true){
          _sharedPreferences.setBool("browseAsGuest", false);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MainHome();
                  }));
        }
        else{
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (__) => new StartShoppingUI()));
        }

      } else {
        _sessionDetails.skippedIntro(false);
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (__) => new IntroScreensUI()));
      }
    }

  }
  @override
  void initState() {
    super.initState();

    analytics.setCurrentScreen(screenName: "Splash Screen");
    startTime();
  }

  @override
  void dispose() {
    _webEngagePlugin.pushSink.close();
    _webEngagePlugin.pushActionSink.close();
    _webEngagePlugin.trackDeeplinkURLStreamSink.close();

    super.dispose();
  }



  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityStatus>(create: (context)=>ConnectivityService().connectionStatusController.stream, initialData: null)
      ],
      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: new Scaffold(
          backgroundColor: Colors.white,
          // resizeToAvoidBottomPadding: false,
          body: new Center(
            child: new Image.asset(
              'images/splash_aza_logo.png',
              width: MediaQuery.of(context).size.width*0.25,
              height:  MediaQuery.of(context).size.height*0.25,
            ),
          ),
        ),
      ),
    );
  }

  void _onPushClick(Map<String, dynamic> message, String s) {
    print("This is a push click callback from native to flutter. Payload " +
        message.toString());
    print("This is a push click callback from native to flutter. Payload " +
        s.toString());
  }

  void _onPushActionClick(Map<String, dynamic> message, String s) {
    print(
        "This is a Push action click callback from native to flutter. Payload " +
            message.toString());
    print(
        "This is a Push action click callback from native to flutter. SelectedId " +
            s.toString());
  }

  void _onInAppPrepared(Map<String, dynamic> message) {
    print("This is a inapp prepared callback from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppClick(Map<String, dynamic> message, String s) {
    print("This is a inapp click callback from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppShown(Map<String, dynamic> message) {
    print("This is a callback on inapp shown from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppDismiss(Map<String, dynamic> message) {
    print(
        "This is a callback on inapp dismiss from native to flutter. Payload " +
            message.toString());
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await WebEngagePlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
  void initWebEngage() {
    _webEngagePlugin = new WebEngagePlugin();
    _webEngagePlugin.setUpPushCallbacks(_onPushClick, _onPushActionClick);
    _webEngagePlugin.setUpInAppCallbacks(_onInAppClick, _onInAppShown, _onInAppDismiss, _onInAppPrepared);
    subscribeToPushCallbacks();
    subscribeToTrackDeeplink();
  }
  void subscribeToPushCallbacks() {
    //Push click stream listener
    _webEngagePlugin.pushStream.listen((event) {
      String deepLink = event.deepLink;
      Map<String, dynamic> messagePayload = event.payload;
      showDialogWithMessage("Push click callback: " + event.toString());

    });

    //Push action click listener
    _webEngagePlugin.pushActionStream.listen((event) {
      print("pushActionStream:" + event.toString());
      String deepLink = event.deepLink;
      Map<String, dynamic> messagePayload = event.payload;
      showDialogWithMessage("PushAction click callback: " + event.toString());
    });
  }

  void subscribeToTrackDeeplink() {
    _webEngagePlugin.trackDeeplinkStream.listen((location) {
      print("trackDeeplinkStream: " + location);
      showDialogWithMessage("Track deeplink url callback: " + location);
    });
  }

  final navigatorKey = GlobalKey<NavigatorState>();
  void showDialogWithMessage(String msg) {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.all(5.0),
              child: new Container(
                // padding: new EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                ),
                child: new Text(
                  msg,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: 'helvetica_neue_light',
                  ),
                  textAlign: TextAlign.center,
                ),
              )
          );
        });

  }
}



