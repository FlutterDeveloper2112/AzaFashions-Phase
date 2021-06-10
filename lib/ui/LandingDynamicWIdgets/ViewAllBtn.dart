
import 'package:azaFashions/models/LandingPages/BannerCarousel.dart';
import 'package:azaFashions/ui/BaseFiles/CelebrityDetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

//BANNER IMAGES WITH PAGE VIEW

class ViewAllBtn extends StatefulWidget {
String view_all_url, view_all_urltag,insider_view,main_view,title;
ViewAllBtn(this.view_all_url,this.view_all_urltag,this.insider_view,this.main_view,this.title);
  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<ViewAllBtn> {

  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return widget.main_view=="View All"?Padding(
        padding: EdgeInsets.only(top:3,bottom: 2),
        child:Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child:
          FlatButton(
            onPressed: () async{
              if( widget.view_all_urltag=="celebrity_collection"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new CelebrityDetailPage()));

              }else if( widget.view_all_urltag=="landing"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new ChildDynamicLanding( widget.view_all_url,widget.title)));

              }
              else if( widget.view_all_urltag=="collection"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new DetailPage("Collection", widget.view_all_url)));
              }
                else if( widget.view_all_urltag=="web_view"){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (__) => new WebViewContainer(widget.view_all_url,widget.title,"WEBVIEW")));
                }

                else if( widget.view_all_urltag=="external_browser"){
                  await launch(widget.view_all_url);
                }

            },
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[200],width: 1,style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(1.0))
            ),
            child: Text('View All', textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:16,fontFamily: "Helvetica",color: Colors.black),),
            color: Colors.grey[200],),
        )
    ):Padding(
        padding: EdgeInsets.only(right: 10,top:20),
        child:Container(
          width: MediaQuery.of(context).size.width/3,
          height: 40,
          child:
          FlatButton(
            onPressed: ()async{
              if( widget.view_all_urltag=="celebrity_collection"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new CelebrityDetailPage()));

              }else if( widget.view_all_urltag=="landing"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new ChildDynamicLanding( widget.view_all_url,widget.title)));

              }
              else if( widget.view_all_urltag=="collection"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new DetailPage(widget.title, widget.view_all_url)));
              }
              else if( widget.view_all_urltag=="web_view"){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new WebViewContainer(widget.view_all_url,widget.title,"WEBVIEW")));
              }
              else if( widget.view_all_urltag=="external_browser"){
                await launch(widget.view_all_url);
              }


            },
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black,width: 1,style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(1.0))
            ),
            child: Text('VIEW ALL', textAlign:TextAlign.center,style: TextStyle(fontFamily: "Helvetica",color: Colors.black),),
            color: Colors.transparent,),
        )
    );


    // ListView.builder() shall be used here.

  }

}
