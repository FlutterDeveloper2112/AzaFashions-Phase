
import 'package:azaFashions/ui/BaseFiles/ChildDynamicLanding.dart';
import 'package:azaFashions/models/LandingPages/SliderList.dart';
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/ViewAllBtn.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//SLIDERPAGE UI INDICATES IMAGES AND DESIGNER NAME in CAROSUEL format

class SliderPage extends StatefulWidget {
 SliderList slider;
 String tag;


  SliderPage({this.slider,this.tag});

  @override
  SliderItems createState() => SliderItems();
}

class SliderItems extends State<SliderPage> {
  SliderDetails sliderDetails;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
       widget.slider.title!=null?   Container(
              width: double.infinity,
           padding: EdgeInsets.only(left:15,right:15,top:10,bottom:15),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),
                    Expanded(
                        flex: 5,
                        child:Container(
                            padding: EdgeInsets.only(left:3,right: 3),
                            width: double.infinity,
                            child:Align(
                              alignment: Alignment.center,
                              child: Text(" ${widget.slider.title} ",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:22,fontFamily: "PlayfairDisplay",color: Colors.black),),
                            )
                        )),
                    Expanded(
                      child: Divider(color: Colors.black,),
                    ),

                  ]
              )
          ):Center(),
          Padding(padding: EdgeInsets.only(top: 20),
              child:Container(
                height: 425,
                child: CarouselSlider(
                  options: CarouselOptions(
                      /*height: 400,
                      aspectRatio: 16/9,
                      viewportFraction: 0.55,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,*/
                      height: 490,
                      autoPlay: true,
                      //  aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      viewportFraction: 0.65
                  ),
                  items: widget.slider.sliderList.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return   InkWell(
                          onTap: ()async{
                            if(i.url_tag=="landing"){
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (__) => new ChildDynamicLanding(i.url,i.section_heading)));

                            }
                            else if(i.url_tag=="collection"){
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (__) => new DetailPage(i.section_heading, i.url)));
                            }
                            else if(i.url_tag=="web_view"){
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (__) => new WebViewContainer(i.url,i.section_heading,"WEBVIEW")));
                            }

                            else if(i.url_tag=="external_browser"){
                              await launch(i.url);
                            }


                          },
                          child: Container(
                            child:Container(
                              width: 400,
                              height: 450,
                              child: ClipRRect(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          width: 400,height: 375,
                                          child: Image(image:CachedNetworkImageProvider(i.image))
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text("${i.section_heading}",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize :18, fontFamily: "Helvetica-Condensed",color: Colors.black),),
                                          ))
                                    ],
                                  )
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              )),
          widget.slider.view_all_title!=""?
          Padding(
            padding: const EdgeInsets.only(bottom:10.0),
            child: ViewAllBtn(widget.slider.view_all_url,widget.slider.view_all_urltag,widget.slider.view_all_title,"",""),
          )
              :Padding(padding: EdgeInsets.all(0)),


        ])
    );
  }
}
