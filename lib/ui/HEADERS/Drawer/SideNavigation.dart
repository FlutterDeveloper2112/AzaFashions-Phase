import 'dart:convert';
import 'dart:io';
import 'package:azaFashions/networkprovider/LoginProvider.dart';
import 'package:azaFashions/ui/BaseFiles/DynamicLandingPage.dart';
import 'package:azaFashions/models/Login/SideNavigationModel.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/HTMLFile.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/DESIGNER/afh_designerUI.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsi_signin.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsu_signup.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/home_menuoptions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class SideNavigation extends StatefulWidget {
  String title;

  SideNavigation({this.title});

  Navigation createState() => Navigation();
}

class Navigation extends State<SideNavigation> {
  FirebaseAnalytics analytics = new FirebaseAnalytics();
  ScrollController _controller = new ScrollController();
  ItemScrollController _scrollController = ItemScrollController();
  String userName = "";
  bool guest = false;
  UserLogin _userLogin = UserLogin();
  SideNavigationModel  sideNavigationModel = SideNavigationModel();
  bool azaSelected = false, buyingSelected = false, policySelected = false;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "Side Navigation");
    WebEngagePlugin.trackScreen("Hamburger / Side Navigation Screen");
    print("INIT Called");
    beforeBuild();
    super.initState();
    // loginBloc.getLoginDetails(context, "Profile");
  }




  beforeBuild() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sideNavigationModel = SideNavigationModel.fromJson(
          jsonDecode(prefs.getString('sideNavigation')));
      print("SIDE NAVIGATION CALLED");
    });


    if (prefs.getBool("browseAsGuest")) {
      setState(() {
        guest = prefs.getBool("browseAsGuest");
      });
      setState(() {
        userName = "Guest User";
        _userLogin.email = "";
      });
    } else {
      setState(() {
        _userLogin =
            UserLogin.fromJson(jsonDecode(prefs.getString('userDetails')));
        guest = prefs.getBool("browseAsGuest");
        userName = _userLogin.firstname + " " + _userLogin.lastname;
      });
    }
  }


  @override
  void didChangeDependencies() {
    // beforeBuild();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top:true,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                height: 110,
                child: DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:  EdgeInsets.only(bottom:3),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('${userName}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "PlayfairDisplay",
                                  color: Colors.black)),
                        ),
                      ),

                      guest
                          ? Row(
                        children: [
                          InkWell(
                              onTap:(){
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()));
                              },
                              child: Text("Sign In",style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "Helvetica",
                                  color: Colors.black))),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              color: Colors.black,
                              height: 16,
                              width: 2,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SignUp()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Sign Up",style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "Helvetica",
                                  color: Colors.black)),
                            ),
                          ),
                        ],
                      )
                          : Align(
                        alignment: Alignment.centerLeft,
                        child: Text('${_userLogin.email}',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Helvetica",
                                color: Colors.black)),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ),
              //Listing Items

              getMainListing(context, sideNavigationModel.mainListing),
              getAzaListing(context, sideNavigationModel.azaListing),
              getBuyingGuideListing(context, sideNavigationModel.buyingGuideList),
              getPolicyListing(context, sideNavigationModel.policyList),


              SizedBox(
                height: 50,
              )
            ],
          )),
    );
  }

  Widget getMainListing(BuildContext context, MainListing mainListing) {
    return new ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10.0),
      itemCount: mainListing.mainItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            InkWell(
                onTap: () async {

                  if(mainListing.mainItems[index].title == "Home Decor"){
                    Options.menu = mainListing.mainItems[index].title;
                  }
                  if (mainListing.mainItems[index].title == "Designers") {

                    WebEngagePlugin.trackEvent("Hamburger / Side Navigation Screen : ${mainListing.mainItems[index].title}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Scaffold(
                                  appBar: AppBarWidget().myAppBar(context, mainListing.mainItems[index].title, scaffoldKey,webview: ""),
                                  body: DesignerUI(),
                                )));
                  } else {
                    WebEngagePlugin.trackScreen("Hamburger / Side Navigation Screen : ${mainListing.mainItems[index].title}");

                    if (mainListing.mainItems[index].url_tag == "collection") {

                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (__) => new DetailPage(mainListing.mainItems[index].title,
                                  mainListing.mainItems[index].url)));
                    } else if (mainListing.mainItems[index].url_tag ==
                        "landing") {

                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (__) => new DynamicLandingPage(
                                  mainListing.mainItems[index].url,mainListing.mainItems[index].title)));
                    }

                    else if (mainListing.mainItems[index].url_tag ==
                        "web_view") {

                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (__) => new WebViewContainer(
                                  mainListing.mainItems[index].url,
                                  mainListing.mainItems[index].title,"WEBVIEW")));
                    }
                    else{
                      await launch(mainListing.mainItems[index].url);
                    }

                    // return route;
                  }},
                child: Container(
                    padding: EdgeInsets.only(left: 10),
                    height: 48,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right:10),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        "${mainListing.mainItems[index].image}")
                                  //Can use CachedNetworkImage
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0))),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(mainListing.mainItems[index].title,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "PlayfairDisplay",
                                color: Colors.black)),
                      ],
                    ))),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              height: 10,
              child: Divider(),
            ),
          ],
        );
      },
    );
  }

  Widget getAzaListing(BuildContext context, AzaListing azaListing) {
    return Column(
      children: [
        //Aza Listing
        InkWell(
          onTap: () {
            setState(() {

              if (azaSelected == false) {
                azaSelected = true;
              } else {
                azaSelected = false;
              }

            });

          },
          child: Container(
              padding: EdgeInsets.only(left: 25, right: 20, top: 10, bottom: 5),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: new Text('${azaListing.title}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black)),
                  ),
                  azaSelected==true?Align(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.keyboard_arrow_up_outlined,
                        size: 25,
                        color: Colors.black,
                      )):Align(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.arrow_forward_ios,
                      size: 14.5,
                      color: Colors.black,
                    ),
                  )
                ],
              )),
        ),
        azaSelected == true
            ? new ListView.builder(
          controller: _controller,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10.0),
          itemCount: azaListing.azaItems.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                InkWell(
                    onTap: () async {
                      WebEngagePlugin.trackScreen("Hamburger / Side Navigation Screen : ${azaListing.azaItems[index].title}");
                      if(azaListing.azaItems[index].title=="Rate Aza App"){
                        Platform.isIOS? await launch("https://apps.apple.com/in/app/aza/id1541608860"):await launch("https://play.google.com/store/apps/details?id=com.azaOnline.azaFashions");

                      }
                      if (azaListing.azaItems[index].url_tag ==
                          "collection") {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DetailPage(
                                    azaListing.azaItems[index].url_tag,
                                    azaListing.azaItems[index].url)));
                      }

                      else if (azaListing.azaItems[index].url_tag ==
                          "landing") {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DynamicLandingPage(
                                    azaListing.azaItems[index].url,azaListing.azaItems[index].title)));
                      } else if (azaListing.azaItems[index].url_tag ==
                          "web_view") {

                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new WebViewContainer(
                                    azaListing.azaItems[index].url,
                                    azaListing.azaItems[index].title,"AZALISTING")));
                      }
                      else if (azaListing.azaItems[index].url_tag ==
                          "inline_html") {
                        LoginProvider.htmlRes = "";
                        print(azaListing.azaItems[index].url);
                        await LoginProvider().html(
                            context, azaListing.azaItems[index].url);
                        print(LoginProvider.htmlRes);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new HTMLFile(
                                  content: LoginProvider.htmlRes,
                                )));
                      }
                      else{

                        await launch(azaListing.azaItems[index].url);
                      }

                      // return route;
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 15),
                        height: 45,
                        child: Row(
                          children: <Widget>[
                            azaListing.azaItems[index].image != null
                                ? Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image:CachedNetworkImageProvider(azaListing.azaItems[index].image)
                                    //Can use CachedNetworkImage
                                  ),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft:
                                      Radius.circular(0),
                                      bottomRight:
                                      Radius.circular(0))),
                            )
                                : Center(),
                            SizedBox(
                              width: 10,
                            ),
                            new Text(azaListing.azaItems[index].title,
                                style: TextStyle(
                                    fontSize: 13.5,
                                    fontFamily: "PlayfairDisplay",
                                    color: Colors.black)),
                          ],
                        ))),
                Container(
                  padding: EdgeInsets.only(
                      left: 15, right: 15, top: 5, bottom: 5),
                  height: 10,
                  child: Divider(),
                ),
              ],
            );
          },
        )
            : Center(),
      ],
    );
  }

  Widget getBuyingGuideListing(
      BuildContext context, BuyingGuideList buyingGuideList) {
    return Column(
      children: [
        //Aza Listing
        InkWell(
          onTap: () {
            setState(() {

              if (buyingSelected == false) {
                buyingSelected = true;
              } else {
                buyingSelected = false;
              }
            });
          },
          child: Container(
              padding: EdgeInsets.only(left: 25, right: 20, top: 10, bottom: 5),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: new Text('${buyingGuideList.title}',
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.normal,
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black)),
                  ),
                  buyingSelected == true?Align(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.keyboard_arrow_up_outlined,
                      size: 25,
                      color: Colors.black,
                    ),
                  ):Align(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black,
                    ),
                  )
                ],
              )),
        ),
        buyingSelected == true
            ? new ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10.0),
          itemCount: buyingGuideList.buyingGuideItems.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                InkWell(
                    onTap: () async{
                      WebEngagePlugin.trackScreen("Hamburger / Side Navigation Screen : ${buyingGuideList.buyingGuideItems[index].title}");

                      if (buyingGuideList
                          .buyingGuideItems[index].url_tag ==
                          "collection") {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DetailPage(
                                    buyingGuideList.buyingGuideItems[index].url_tag,
                                    buyingGuideList
                                        .buyingGuideItems[index].url)));
                      } else if (buyingGuideList
                          .buyingGuideItems[index].url_tag ==
                          "landing") {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DynamicLandingPage(
                                    buyingGuideList
                                        .buyingGuideItems[index].url, buyingGuideList
                                    .buyingGuideItems[index].title)));
                      } else if (buyingGuideList
                          .buyingGuideItems[index].url_tag ==
                          "web_view") {

                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new WebViewContainer(
                                    buyingGuideList
                                        .buyingGuideItems[index].url,
                                    buyingGuideList
                                        .buyingGuideItems[index].title,"BUYINGLIST")));
                      }
                      else{

                        await launch(buyingGuideList
                            .buyingGuideItems[index].url);
                      }


                      // return route;
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 15),
                        height: 45,
                        child: Row(
                          children: <Widget>[
                            buyingGuideList
                                .buyingGuideItems[index].image !=
                                null
                                ? Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image:CachedNetworkImageProvider(buyingGuideList.buyingGuideItems[index].image)
                                    //Can use CachedNetworkImage
                                  ),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft:
                                      Radius.circular(0),
                                      bottomRight:
                                      Radius.circular(0))),
                            )
                                : Center(),
                            SizedBox(
                              width: 10,
                            ),
                            new Text(
                                buyingGuideList
                                    .buyingGuideItems[index].title,
                                style: TextStyle(
                                    fontSize: 13.5,
                                    fontFamily: "PlayfairDisplay",
                                    color: Colors.black)),
                          ],
                        ))),
                Container(
                  padding: EdgeInsets.only(
                      left: 15, right: 15, top: 5, bottom: 5),
                  height: 10,
                  child: Divider(),
                ),
              ],
            );
          },
        )
            : Center(),
      ],
    );
  }

  Widget getPolicyListing(BuildContext context, PolicyList policyListing) {
    return Column(
      children: [
        //Aza Listing
        InkWell(
          onTap: () {
            setState(() {

              if (policySelected == false) {
                policySelected = true;

              } else {
                policySelected = false;
              }
            });

          },
          child: Container(
              padding: EdgeInsets.only(left: 25, right: 20, top: 10, bottom: 5),
              height:50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: new Text('${policyListing.title}',
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.normal,
                            fontFamily: "PlayfairDisplay",
                            color: Colors.black)),
                  ),

                  policySelected == true?Align(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.keyboard_arrow_up_outlined,
                      size: 25,
                      color: Colors.black,
                    ),
                  ):Align(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black,
                    ),
                  )
                ],
              )),
        ),
        policySelected == true
            ? new ListView.builder(
          shrinkWrap: true,
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left:10.0,right:10,top:5,bottom:10),
          itemCount: policyListing.policyItems.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                InkWell(
                    onTap: ()async {
                      WebEngagePlugin.trackScreen("Hamburger / Side Navigation Screen : ${policyListing.policyItems[index].title}");
                      if (policyListing.policyItems[index].url_tag ==
                          "collection") {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DetailPage(policyListing.policyItems[index].url_tag,
                                    policyListing
                                        .policyItems[index].url)));
                      } else if (policyListing
                          .policyItems[index].url_tag ==
                          "landing") {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new DynamicLandingPage(
                                    policyListing
                                        .policyItems[index].url,policyListing
                                    .policyItems[index].title)));
                      } else if (policyListing
                          .policyItems[index].url_tag ==
                          "web_view") {

                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (__) => new WebViewContainer(
                                    policyListing.policyItems[index].url,
                                    policyListing
                                        .policyItems[index].title,"POLICY LISTING")));
                      }
                      else{

                        await launch( policyListing
                            .policyItems[index].url);
                      }

                      // return route;
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 15),
                        height: 45,
                        child: Row(
                          children: <Widget>[
                            policyListing.policyItems[index].image != null
                                ? Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image:CachedNetworkImageProvider(policyListing.policyItems[index].image)
                                  ),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft:
                                      Radius.circular(0),
                                      bottomRight:
                                      Radius.circular(0))),
                            )
                                : Center(),
                            SizedBox(
                              width: 10,
                            ),
                            new Text(
                                policyListing.policyItems[index].title,
                                style: TextStyle(
                                    fontSize: 13.5,
                                    fontFamily: "PlayfairDisplay",
                                    color: Colors.black)),
                          ],
                        ))),
                Container(
                  padding: EdgeInsets.only(
                      left: 15, right: 15, top: 5, bottom: 5),
                  height: 10,
                  child: Divider(),
                ),
              ],
            );
          },
        )
            : Center(),

      ],
    );
  }

}
