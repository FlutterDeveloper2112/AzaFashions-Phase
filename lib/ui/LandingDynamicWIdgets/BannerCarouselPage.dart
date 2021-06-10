import 'dart:io';
import 'package:azaFashions/models/LandingPages/BannerCarousel.dart';
import 'package:azaFashions/ui/LandingDynamicWIdgets/BannerCardDesign.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

//BANNER IMAGES WITH PAGE VIEW

class BannerCarouselPage extends StatefulWidget {
  BannerCarousel banners;
  String designerImage, designertitle, designDescription, tag,patternName;

  BannerCarouselPage({this.banners});

  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<BannerCarouselPage> with SingleTickerProviderStateMixin {
  int totalPages;

  Animation<double> _progressAnimation;
  AnimationController _progressAnimcontroller;
  double growStepWidth, beginWidth, endWidth = 0.0;

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  void initState() {
    super.initState();
    setState(() {
      totalPages=widget.banners.bannerList.length;
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
  void dispose() {
    _progressAnimcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          //HEADER
          Container(
            height:465/* Platform.isIOS != null?460:435*/,
            child: PageView.builder(
                onPageChanged: (i) {
                  _currentPageNotifier.value = i;
                },
                scrollDirection: Axis.horizontal,
                itemCount: widget.banners.bannerList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                return   BannerCardsDesign(widget.banners.bannerList[index]);
                }
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:15),
            child: _buildCircleIndicator(),
          )


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
