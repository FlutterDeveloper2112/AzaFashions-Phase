import 'package:azaFashions/models/LandingPages/AzaMagzine.dart';
import 'package:azaFashions/ui/BaseFiles/WebViewContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class MagzineWidget extends StatefulWidget {
  AzaMagzine magzine;
  MagzineWidget(this.magzine);


  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<MagzineWidget>  with SingleTickerProviderStateMixin{
  String imageValue = "";
  int totalPages;

  Animation<double> _progressAnimation;
  AnimationController _progressAnimcontroller;
  double growStepWidth, beginWidth, endWidth = 0.0;

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  void initState() {
    super.initState();
    setState(() {
      totalPages=widget.magzine.magzineList.length;
    });

    _progressAnimcontroller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: beginWidth, end: endWidth)
        .animate(_progressAnimcontroller);

    _setProgressAnim(0, 1);
  }

  _setProgressAnim(double maxWidth, int curPageIndex) {
    setState(() {
      growStepWidth = maxWidth / totalPages;
      beginWidth = growStepWidth * (curPageIndex - 1);
      endWidth = growStepWidth * curPageIndex;

      _progressAnimation = Tween<double>(begin: beginWidth, end: endWidth)
          .animate(_progressAnimcontroller);
    });

    _progressAnimcontroller.forward();
  }



  @override
  Widget build(BuildContext context) {
    return  Column(
        children: <Widget>[
          //HEADER
          Container(
            padding: EdgeInsets.only(top:20,left:10,right: 10),
            width: double.infinity,
            height: 210,
            child: PageView.builder(
                onPageChanged: (i) {
                  _currentPageNotifier.value = i;
                },
                scrollDirection: Axis.horizontal,
                itemCount: widget.magzine.magzineList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return    InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget> [
                            //image
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child:  Align(
                                  alignment: Alignment.centerLeft,
                                  child:Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: 120,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image:CachedNetworkImageProvider(widget.magzine.magzineList[index].image),
                                          //Can use CachedNetworkImage
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0))),
                                  )
                              ),
                            ),
                            //title section
                            Expanded(
                              child:Container(
                                height:320 ,
                                color: Colors.grey[200],
                                child: Column(
                                  children: <Widget>[
                                    //title
                                    Padding(
                                        padding: EdgeInsets.only(left:15,top:15,bottom:5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${widget.magzine.magzineList[index].title}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                fontFamily: "PlayfairDisplay",
                                                color: Colors.black),
                                          ),
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left:15,top:4,bottom:5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${widget.magzine.magzineList[index].description}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13,
                                                fontFamily: "Helvetica",
                                                color: HexColor("#666666")),
                                          ),
                                        )),

                                   /* Padding(
                                        padding: EdgeInsets.only(left:10,top:5,bottom:5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${widget.designSubDescription}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12,
                                                fontFamily: "Helvetica",
                                                color: Colors.black),
                                          ),
                                        )),*/

                                    InkWell(

                                      child: Padding(
                                          padding: EdgeInsets.only(left:15,top: 8),
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child:  Container(
                                              color:HexColor("#999999"),
                                              width: 120,
                                              height: 35,
                                              child:
                                              FlatButton(
                                                onPressed: () async{
                                                  print("${widget.magzine.magzineList[index].url} ${widget.magzine.magzineList[index].url} ${widget.magzine.url_tag} ");
                                                  if(widget.magzine.url_tag=="external_browser"){
                                                            await launch(widget.magzine.magzineList[index].url);
                                                  }
                                                  else{
                                                     Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (__) => WebViewContainer(widget.magzine.magzineList[index].url, widget.magzine.magzineList[index].title,"WEBVIEW")));


                                                  }

                                                },
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(color: Colors.grey[400],width: 1,style: BorderStyle.solid),
                                                    borderRadius: BorderRadius.all(Radius.circular(1.0))
                                                ),
                                                child: Text('READ MORE', textAlign:TextAlign.left,style: TextStyle(fontFamily: "Helvetica",fontSize:13.5,color: Colors.white),),
                                                color: Colors.grey[500],),
                                            ),
                                          )

                                      ),
                                    ),



                                  ],
                                ),
                              ),
                            )

                          ],
                        ),

                      ),
                    ),
                  );
                }
            ),
          ),
          _buildCircleIndicator(),

          // ListView.builder() shall be used here.
        ]);

  }

  _buildCircleIndicator() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CirclePageIndicator(
        selectedBorderColor: Colors.black,
        selectedDotColor: Colors.black,
        borderWidth: 1.5,
        borderColor: Colors.black,
        dotColor: Colors.white,
        itemCount: totalPages,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

}
