import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:azaFashions/models/Listing/ListingModel.dart';
import 'package:azaFashions/ui/BaseFiles/DynamicLandingPage.dart';
import 'package:azaFashions/bloc/LoginBloc/HomeApiBloc.dart';
import 'package:azaFashions/models/Login/BulletMenuList.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Options extends StatefulWidget {
BulletMenuList bulletMenu;
static String menu="";
Options(this.bulletMenu);
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {

  Widget menu(String image,String title){
     return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
        Align(
        alignment: Alignment.topCenter,
        child:   Container(
          width: 65,
          height:55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fitWidth,
              image:CachedNetworkImageProvider(image),

              //Can use CachedNetworkImage
            ),
          ),
        ),
      ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: new Text(title,textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.normal,fontFamily: "Helvetica",fontSize: 12.0,color: Colors.black),),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(5.0),
          itemCount:widget.bulletMenu.menu_model.length,
          itemBuilder: (context, index){
            return InkWell(
                child:menu(widget.bulletMenu.menu_model[index].image,widget.bulletMenu.menu_model[index].title),
                onTap: () async{
                  if (widget.bulletMenu.menu_model[index].title ==
                      "Home Decor") {
                    Options.menu = widget.bulletMenu.menu_model[index].title;
                  }
                  else{
                    Options.menu = "";
                  }
                  if (widget.bulletMenu.menu_model[index].url_tag=="collection") {
                    setState(() {
                      ListingModel.finalModel_List= new  List<ModelList>();
                      MyFilter.filterModel = new List<FilterModel>();
                      DetailPageState.count=1;
                    });

                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (__) =>
                            new DetailPage(widget.bulletMenu.menu_model[index].title,
                                widget.bulletMenu.menu_model[index].url)));
                  }
                  else if(widget.bulletMenu.menu_model[index].url_tag=="landing"){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (__) =>
                            new DynamicLandingPage(
                                widget.bulletMenu.menu_model[index].url,widget.bulletMenu.menu_model[index].title)));


                  }
                  else if(widget.bulletMenu.menu_model[index].url_tag=="web_view"){
                      Navigator.push(
                      context,
                      new MaterialPageRoute(
                      builder: (__) => new WebViewContainer(widget.bulletMenu.menu_model[index].url,widget.bulletMenu.menu_model[index].title,"WEBVIEW")));
                  }

                  else if(widget.bulletMenu.menu_model[index].url_tag=="external_browser"){
                    await launch(widget.bulletMenu.menu_model[index].url);
                  }
                });

          },
        ));



  }

}
