import 'package:azaFashions/models/LandingPages/VanillaBanner.dart';
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/DynamicLandingPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//VANILLA BANNER INDICATES TO DISPLAY ONLY IMAGE
class VanillaBannerPage extends StatefulWidget {
  VanillaBanner banners;
  String tag;
  String title;

  VanillaBannerPage({this.banners,this.tag,this.title});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<VanillaBannerPage> {
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print("WIDGET TAG: ${widget.tag}");
    return Column(
        children: <Widget>[
        InkWell(
        onTap: ()async{
          print("WIDGET TAG: ${widget.tag}");
      if(widget.banners.url_tag=="landing"){
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (__) => new DynamicLandingPage(widget.banners.url,widget.banners.screen_title)));

      }
      else if(widget.banners.url_tag=="collection"){
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (__) => new DetailPage("Collection", widget.banners.url)));
      }
      else if(widget.banners.url_tag=="web_view"){
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (__) => new WebViewContainer(widget.banners.url,"Collection","WEBVIEW")));
      }

      else if(widget.banners.url_tag=="external_browser"){
        await launch(widget.banners.url);
      }

    },
    child:
    //HEADER
          Container(
               padding: EdgeInsets.only(left:35,right: 35,top: 20,bottom:12),
               width:MediaQuery.of(context).size.width ,
                height:TargetPlatform.iOS != null?200:180,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                    image:CachedNetworkImageProvider(widget.banners.image)
                      //Can use CachedNetworkImage
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0))),
              )),

          // ListView.builder() shall be used here.
        ]);
  }


}
